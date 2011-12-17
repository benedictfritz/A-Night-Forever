package worlds
{
    import flash.utils.ByteArray;

    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    // level takes care of drawing all the tiles. the worlds' code
    // is responsible for adding objects.
    public class Level extends Entity {
	// TODO: make private again
	public var 
	    tiles:Tilemap,
	    grid:Grid,
	    levelData:XML;
	
	private static const
	    WORLD_WIDTH:Number = FP.width,
	    WORLD_HEIGHT:Number = FP.height,
	    TILE_WIDTH:Number = 16,
	    TILE_HEIGHT:Number = 16;
	
	[Embed(source="../../assets/levels/images/png/tiles.png")]
	    private const TILESET:Class;

	public function Level(xml:Class) {
	    tiles = new Tilemap(TILESET, WORLD_WIDTH, WORLD_HEIGHT, 
				 TILE_WIDTH, TILE_HEIGHT);
	    graphic = tiles;
	    layer = 1;

	    grid = new Grid(WORLD_WIDTH, WORLD_HEIGHT, 
			     TILE_WIDTH, TILE_HEIGHT, 0, 0);
	    mask = grid;

	    type = "level";
	    loadLevel(xml);
	}

	private function loadLevel(xml:Class):void {
	    var rawData:ByteArray = new xml;
	    var dataString:String = rawData.readUTFBytes(rawData.length);

	    levelData = new XML(dataString);

	    var dataList:XMLList = levelData.tiles.tile;
	    for each(var dataElement:XML in dataList) {
		tiles.setTile(int(dataElement.@x)/TILE_WIDTH,
			       int(dataElement.@y)/TILE_HEIGHT,
			       int(dataElement.@tx)/TILE_WIDTH);
		// all tiles are solid
		grid.setTile(int(dataElement.@x)/TILE_WIDTH,
			      int(dataElement.@y)/TILE_HEIGHT,
			      true);
	    }
	}

	public function getLevelData():XML {
	    return levelData;
	}
    }
}