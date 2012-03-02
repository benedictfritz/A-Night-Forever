package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import util.Util;

    public class Falling extends World
    {
	private const
	    STAR_RANGE:Number = 4,
	    FALLING_GRAVITY:Number = 0.2,
	    WORLD_CHANGE_BUFFER:Number = 3,
	    CLOUD_LAYER_HEIGHT:Number = 64,
	    CLOUD_LAYER_WIDTH:Number = 256;

	private var
	    sectors:Array,
	    currSector:Sector,
	    couple:Couple,
	    minStars:Number = 4,
	    transitionIn:TransitionIn;

	public function Falling():void {
	}

	override public function begin():void {
	    super.begin();

	    couple = new Couple(0, 0);
	    add(couple);

	    sectors = new Array();
	    currSector = new Sector(0, 0);
	    addCloudLayersToSector(0);
	    
	    sectors.push(currSector);
	    updateSectors();
	}

	override public function update():void {
	    super.update();

	    updateCamera();

	    if (!currSector.contains(couple.x, couple.y)) {
		pushNewSector();
		updateSectors();

		if (minStars < -STAR_RANGE - WORLD_CHANGE_BUFFER) {
		    FP.world = new Reality();
		}
	    }
	}

	private function updateCamera():void {
	    camera.x = couple.x - FP.halfWidth + (couple.width / 2);
	    camera.y = couple.y - FP.halfHeight + couple.height;
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

	// make sure all sectors surrounding the current sector exist and are in the
	// sectors array.
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
			minStars -= 0.1;
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
	}
    }
}