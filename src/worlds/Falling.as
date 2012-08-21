package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.tweens.misc.VarTween;
    import net.flashpunk.tweens.sound.SfxFader;

    import flash.geom.Point;

    import entities.*;
    import util.Util;

    public class Falling extends World
    {
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_6')]
	    static public const MUSIC:Class;

	[Embed(source = '../../assets/images/fall_pain.png')]
	    private const FALL_PAIN_IMG:Class;

	private const
	    STAR_RANGE:Number = 6,
	    FALLING_GRAVITY:Number = 0.2,
	    WORLD_CHANGE_BUFFER:Number = 3,
	    CLOUD_LAYER_HEIGHT:Number = 64,
	    CLOUD_LAYER_WIDTH:Number = 256;

	private var
	    sectors:Array,
	    currSector:Sector,
	    backgroundSectors:Array,
	    currBackgroundSector:Sector;

	private var
	    couple:Couple,
	    minStars:Number = 8,
	    chanceOfClouds:Number = 7,
	    transitionIn:TransitionIn,
	    cloudPoints:Array = new Array(),
	    darkness:Darkness,
	    transitioning:Boolean = false;

	private var
	    fallPain:Entity,
	    fallPainAlphaTween:VarTween;

	private var
	    scrollScale:Number;

	private var
	    music:Sfx = new Sfx(MUSIC);

	public function Falling():void {
	}

	override public function begin():void {
	    super.begin();

	    scrollScale = SkyBackground.SCROLL_SCALE;

	    music.loop();

	    fallPain = new Entity(0, 0, new Image(FALL_PAIN_IMG));
	    fallPain.layer = -500;
	    Image(fallPain.graphic).alpha = 0;
	    Image(fallPain.graphic).scrollX = 0;
	    Image(fallPain.graphic).scrollY = 0;
	    add(fallPain);

	    couple = new Couple(0, 0);
	    add(couple);

	    sectors = new Array();
	    currSector = new Sector(0, 0);
	    addCloudLayersToSector(0);
	    sectors.push(currSector);
	    updateSectors();

	    backgroundSectors = new Array();
	    currBackgroundSector = new Sector(0, 0);
	    sectors.push(currBackgroundSector);
	    updateBackgroundSectors();
	    var firstSectorBackground:SkyBackground =
	    	new SkyBackground(currSector.minX(),
				  currSector.maxY(), 1, 1);
	    add(firstSectorBackground);

	    var transitionIn:TransitionIn = new TransitionIn(0.1, 0xFFFFFF);
	    add(transitionIn);
	}

	override public function update():void {
	    super.update();

	    updateCamera();

	    if (couple.vy > 100) {
	    	Image(fallPain.graphic).alpha =
		    FP.scale(couple.vy, 0, Couple.MIN_SHAKE_VY, 0, 1);
	    }
	    else {
		if (!fallPainAlphaTween) {
		    fallPainAlphaTween = new VarTween(function():void {
			    fallPainAlphaTween = null;
			});
		    fallPainAlphaTween.tween(Image(fallPain.graphic),
					     "alpha", 0, 0.3);
		    addTween(fallPainAlphaTween);
		}
	    }

	    if (!currSector.contains(couple.x, couple.y)) {
		pushNewSector();
		updateSectors();

		if (minStars < -STAR_RANGE - WORLD_CHANGE_BUFFER) {
		    if (!darkness) { 
			darkness = new Darkness();
			var fadeOut:SfxFader = new SfxFader(music);
			fadeOut.fadeTo(0, 9);
			addTween(fadeOut);
			add(darkness);
		    }
		}
	    }

	    // HORRIBLE FIX: all background generation seems to be off by
	    // one vertical tile, so I pretend the couple's y is one tile down
	    // to fix spawning. this is also used in pushNewBackgroundSector
	    if (!currBackgroundSector.contains(couple.x*scrollScale,
					       (couple.y*scrollScale)+FP.height)) {
		pushNewBackgroundSector();
		updateBackgroundSectors();
	    }

	    if (darkness && darkness.done && !transitioning) {
		transitioning = true;
		FP.alarm(4, goToReality);
	    }
	}

	private function goToReality():void {
	    FP.world = new Reality();
	}

	override public function render():void {
	    super.render();
	    if (transitioning) {
		Draw.rect(FP.camera.x, FP.camera.y, FP.width, FP.height, 0x000000);
	    }
	}

	private function updateCamera():void {
	    var xShake:Number = 0;
	    var yShake:Number = 0;
	    
	    if (couple.vy > Couple.MIN_SHAKE_VY) {
		var intensity:Number = FP.scale(couple.vy, Couple.MIN_SHAKE_VY, 
						Couple.MIN_SHAKE_VY*1.5,
						0, 0.03);
		xShake = 
		    (Math.random()*intensity*FP.width*2-intensity*FP.width)*0.1;
		yShake = 
		    (Math.random()*intensity*FP.height*2-intensity*FP.height)*0.1;
	    }
	    camera.x = couple.x - FP.halfWidth + (couple.width / 2) + xShake;
	    camera.y = couple.y - FP.halfHeight + couple.height + yShake;

	    if (camera.y < 0) { camera.y = 0; }
	}

	// update the currSector variable to hold the sector the player is in.
	// if the new current sector isn't in the sectors array (which shouldn't
	// happen), be sure to create a new one. the sectors surrounding the new
	// current sector will be created in updateSectors()
	private function pushNewSector():void {
	    var newSectorX:int = int(couple.x/Sector.WIDTH);
	    var newSectorY:int = int(couple.y/Sector.HEIGHT);

	    // need to round down for negatives
	    if (couple.x < 0) { newSectorX--; }

	    var newCurrSector:Sector = isInSectorsArray(newSectorX, newSectorY);
	    if (newCurrSector) {
		currSector = newCurrSector;
	    }
	    else {
		currSector = new Sector(newSectorX, newSectorY);
		if (newSectorY == 0) { 
		    addCloudLayersToSector(newSectorX);
		}
		sectors.push(newCurrSector);
	    }
	}

	private function addCloudLayersToSector(sectorX:Number):void {
	    var x:Number = int(sectorX * Sector.WIDTH);
	    var cloudY:Number = 0 - (CLOUD_LAYER_HEIGHT / 2);

	    for (var i:Number = x; i < x+Sector.WIDTH; i+=CLOUD_LAYER_WIDTH) {
		var newCloudLayer:CloudLayer = new CloudLayer(i, cloudY);
		add(newCloudLayer);
	    }
	}

	// make sure all sectors surrounding the current sector exist and
	// are in the sectors array.
	private function updateSectors():void {
	    var sectorColumn:Number = currSector.column;
	    var sectorRow:Number = currSector.row;

	    for (var column:Number = sectorColumn-1; 
		 column <= sectorColumn+1; column++) {
		for (var row:Number = sectorRow-1; row <= sectorRow+1; row++) {
		    if (!isInSectorsArray(column, row)) {
			var newSector:Sector = new Sector(column, row);
			if (row == 0) { 
			    addCloudLayersToSector(column);
			}

			sectors.push(newSector);
			populateSector(newSector);

			minStars -= 0.2;
			chanceOfClouds -= 0.1;
		    }
		}
	    }
	}

	private function isInSectorsArray(column:Number, row:Number):Sector {
	    var numSectors:Number = sectors.length;
	    for (var i:Number=0; i < numSectors; i++) {
		if (sectors[i].column == column && sectors[i].row == row) {
		    return sectors[i];
		}
	    }
	    return null;
	}
	
	private function populateSector(sector:Sector):void {
	    var starX:Number;
	    var starY:Number;
	    var numStars:Number = minStars + FP.random * STAR_RANGE;
	    
	    for (var i:Number=0; i < numStars; i++) {
		starX = FP.random * Sector.WIDTH + sector.minX();
		starY = FP.random * Sector.HEIGHT + sector.minY();
		
		var newStar:Star = new Star(starX, starY);
		sector.addStar(newStar);
		add(newStar);
	    }

	    var cloudX:Number, cloudY:Number;
	    var numClouds:Number = int(FP.random * chanceOfClouds);
	    
	    for (i=0; i < numClouds; i++) {
		var newCloudPoint:Point = 
		    new Point(Math.random() * Sector.WIDTH + sector.minX(),
			      Math.random() * Sector.HEIGHT + sector.minY());

		if (cloudPoints.indexOf(newCloudPoint) == -1) {
		    cloudPoints.push(newCloudPoint);
		    var newCloud:LandingCloud = new LandingCloud(newCloudPoint.x,
								 newCloudPoint.y);
		    add(newCloud);
		}
	    }
	}

	/*
	 * background sector functions
	 * there is tons of duplication between this and the other sector functions
	 * and I might not fix it but honestly I just want to finish this game
	 * and this code will never have to be maintained.
	 */

	private function updateBackgroundSectors():void {
	    var sectorColumn:Number = currBackgroundSector.column;
	    var sectorRow:Number = currBackgroundSector.row;

	    for (var column:Number = sectorColumn-1;
		 column <= sectorColumn+1; column++) {
		for (var row:Number = sectorRow-1; row <= sectorRow+1; row++) {
		    if (!isInBackgroundSectorsArray(column, row)) {
			var newSector:Sector = new Sector(column, row);
			backgroundSectors.push(newSector);

			// scale new background position by scrollX
			var newSectorBackground:SkyBackground =
			    new SkyBackground(newSector.minX(), newSector.minY(),
					      1, 1);
			add(newSectorBackground);
		    }
		}
	    }
	}

	private function
	    isInBackgroundSectorsArray(column:Number, row:Number):Sector {

	    var numSectors:Number = backgroundSectors.length;
	    for (var i:Number=0; i < numSectors; i++) {
		if (backgroundSectors[i].column == column
		    && backgroundSectors[i].row == row) {
		    return backgroundSectors[i];
		}
	    }
	    return null;
	}

	private function pushNewBackgroundSector():void {
	    var scaledX:Number = couple.x*scrollScale;
	    var scaledY:Number = couple.y*scrollScale + FP.height;

	    var newSectorX:int = int(scaledX/Sector.WIDTH);
	    var newSectorY:int = int(scaledY/Sector.HEIGHT);

	    // need to round down for negatives
	    if (scaledX < 0) { newSectorX--; }

	    var newCurrBackgroundSector:Sector =
		isInBackgroundSectorsArray(newSectorX, newSectorY);
	    if (newCurrBackgroundSector) {
		currBackgroundSector = newCurrBackgroundSector;
	    }
	    else {
		currBackgroundSector = new Sector(newSectorX, newSectorY);
		backgroundSectors.push(newCurrBackgroundSector);
	    }
	}
    }
}