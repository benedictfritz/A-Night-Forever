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
	[Embed(source="../../assets/levels/Falling.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private const
	    STAR_RANGE:Number = 4,
	    FALLING_GRAVITY:Number = 0.1,
	    WORLD_CHANGE_BUFFER:Number = 3;

	private var
	    sectors:Array,
	    currSector:Sector,
	    couple:Couple,
	    minStars:Number = 8,
	    transitionIn:TransitionIn;

	public function Falling():void {
	    sectors = new Array();
	}

	override public function begin():void {
	    super.begin();

	    var level:Level = new Level(MAP_DATA);
	    add(level);

	    // should only have one couple, but with this code, 
	    // only the last one will get added
	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.couple;
	    for each(var dataElement:XML in dataList) {	    
		couple = new Couple(int(dataElement.@x), int(dataElement.@y));
		add(couple);
	    }

	    sectors = new Array();
	    currSector = new Sector(0, 0);
	    sectors.push(currSector);
	    updateSectors();

	    // fade in from black
	    transitionIn = new TransitionIn();
	    add(transitionIn);
	}

	override public function update():void {
	    // no interaction is allowed while transitioning in
	    if (transitionIn.alpha > 0) { return; }

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
	    
	    if (camera.x < 0) { camera.x = 0; }
	    if (camera.y < 0) { camera.y = 0; }
	}

	private function pushNewSector():void {
	    var newSectorX:int = int(couple.x/Sector.WIDTH);
	    var newSectorY:int = int(couple.y/Sector.HEIGHT);

	    var newCurrSector:Sector = isInSectorsArray(newSectorX, newSectorY);
	    if (newCurrSector) {
		currSector = newCurrSector;
	    }
	    else {
		newCurrSector = new Sector(newSectorX, newSectorY);
		sectors.push(newCurrSector);
	    }
	}

	private function updateSectors():void {
	    var sectorColumn:Number = currSector.column;
	    var sectorRow:Number = currSector.row;

	    for (var column:Number = sectorColumn-1; 
		 column <= sectorColumn+1; column++) {
		for (var row:Number = sectorRow-1; row <= sectorRow+1; row++) {
		    if (!isInSectorsArray(column, row)) {
			var newSector:Sector = new Sector(column, row);
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