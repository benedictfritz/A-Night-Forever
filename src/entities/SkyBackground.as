package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Tilemap;

    public class SkyBackground extends Entity {
	[Embed(source="../../assets/images/gerry/star_background.png")]
	    private const SKY_TILE:Class;

	private var
	    tiles:Tilemap,
	    TILE_WIDTH:Number = 400,
	    TILE_HEIGHT:Number = 300;

	public function SkyBackground(startY:Number, levelHeight:Number):void {
	    this.y = startY - levelHeight;
	    tiles = new Tilemap(SKY_TILE, FP.width, levelHeight,
				TILE_WIDTH, TILE_HEIGHT);
	    graphic = tiles;

	    // render in the background
	    layer = 1;

	    var numColumns:Number = FP.width / TILE_WIDTH;
	    var numRows:Number = levelHeight / TILE_HEIGHT;

	    for (var _x:int = 0; _x < numColumns; _x += 1) {
	    	for (var _y:int = 0; _y < numRows; _y+=1) {
	    	    tiles.setTile(_x, _y);
	    	}
	    }
	}

    }

}