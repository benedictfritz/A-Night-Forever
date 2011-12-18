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
	[Embed(source="../../assets/levels/TestStars.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private const
	    NUM_STARS:Number = 8,
	    FALLING_GRAVITY:Number = 0.1;

	private var
	    sectors:Array,
	    currSector:Sector,
	    couple:Couple;

	public function Falling():void {
	    Util.addCenteredText("World One", this, 5, 1);
	}

	override public function begin():void {
	    super.begin();
	    var level:Level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML;
	    var dataList:XMLList;
	    var dataElement:XML;
	    levelData = level.getLevelData();

	    // should only have one couple, but with this code, 
	    // only the last one will get added
	    dataList = levelData.objects.couple;
	    for each(dataElement in dataList) 
	    {	    
		couple = new Couple(int(dataElement.@x), int(dataElement.@y));
		add(couple);
	    }

	    sectors = new Array();
	    currSector = new Sector(0, 0);
	    sectors.push(currSector);
	    updateSectors();
	}

	override public function update():void {
	    super.update();
	    updateCamera();

	    if (!currSector.contains(couple.x, couple.y)) {
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
		updateSectors();
	    }
	}

	private function updateCamera():void {
	    camera.x = couple.x - FP.halfWidth / FP.screen.scale + 
		(couple.width / 2);
	    camera.y = couple.y - FP.halfHeight / FP.screen.scale + couple.height;
	    
	    if (camera.x < 0) {
		camera.x = 0;
	    }
	    if (camera.y < 0) {
		camera.y = 0;
	    }
	}

	private function updateSectors():void {
	    var sectorColumn:Number = currSector.column;
	    var sectorRow:Number = currSector.row;

	    // you could write this more concisely with just a nested loop, but this
	    // way is much easier for me to understand.
	    
	    // start at the sector above the current sector and then update clockwise
	    var column:Number = sectorColumn;
	    var row:Number = sectorRow - 1;
	    updateSector(column, row);

	    // top right
	    column = sectorColumn + 1;
	    row = sectorRow - 1;
	    updateSector(column, row);

	    // right
	    column = sectorColumn + 1;
	    row = sectorRow;
	    updateSector(column, row);

	    // bottom right
	    column = sectorColumn + 1;
	    row = sectorRow + 1;
	    updateSector(column, row);

	    // bottom
	    column = sectorColumn;
	    row = sectorRow + 1;
	    updateSector(column, row);

	    // bottom left
	    column = sectorColumn - 1;
	    row = sectorRow + 1;
	    updateSector(column, row);

	    // left
	    column = sectorColumn - 1;
	    row = sectorRow;
	    updateSector(column, row);

	    // top left
	    column = sectorColumn - 1;
	    row = sectorRow - 1;
	    updateSector(column, row);
	}
	
	private function updateSector(column:Number, row:Number):void {
	    if (!isInSectorsArray(column, row)) {
		var newSector:Sector = new Sector(column, row);
		sectors.push(newSector);
		populateSector(newSector);
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
	
	// fill sector randomly with stars
	private function populateSector(sector:Sector):void {
	    var starX:Number;
	    var starY:Number;
	    for (var i:Number=0; i < NUM_STARS; i++) {
		starX = FP.random * Sector.WIDTH + sector.minX();
		starY = FP.random * Sector.HEIGHT + sector.minY();
		
		var newStar:Star = new Star(starX, starY);
		sector.addStar(newStar);
		add(newStar);
	    }
	}
    }
}