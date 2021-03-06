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
	private var 
	    tiles:Tilemap,
	    levelData:XML;

	public var 
	    grid:Grid;
	
	private static const
	    TILE_WIDTH:Number = 64,
	    TILE_HEIGHT:Number = 64;
	
	[Embed(source="../../assets/levels/images/tiles.png")]
	    private const TILESET:Class;

	public function Level(xml:Class) {
	    var rawData:ByteArray = new xml;
	    var dataString:String = rawData.readUTFBytes(rawData.length);
	    levelData = new XML(dataString);
	    
	    this.width = levelData.width;
	    this.height = levelData.height;

	    tiles = new Tilemap(TILESET, this.width, this.height, 
				TILE_WIDTH, TILE_HEIGHT);
	    graphic = tiles;
	    layer = 2;

	    grid = new Grid(this.width, this.height, TILE_WIDTH, TILE_HEIGHT, 0, 0);
	    mask = grid;

	    type = "level";
	    placeTiles();
	}

	private function placeTiles():void {
	    // tiles layer holds visuals
	    var dataList:XMLList = levelData.tiles.tile;
	    for each(var dataElement:XML in dataList) {
		var tileImageIndex:Number = 
			    tiles.getIndex(int(dataElement.@tx)/TILE_WIDTH, 
					   int(dataElement.@ty)/TILE_HEIGHT);
		tiles.setTile(int(dataElement.@x)/TILE_WIDTH,
			       int(dataElement.@y)/TILE_HEIGHT,
			       tileImageIndex);
	    }

	    // solids layer holds collidable information
	    dataList = levelData.solids.tile;
	    for each(dataElement in dataList) {
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