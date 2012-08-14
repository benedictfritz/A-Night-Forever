package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Tilemap;

    public class SkyBackground extends Entity {
	[Embed(source="../../assets/images/star_background.png")]
	    private const SKY_TILE:Class;

	public static var
	    TILE_WIDTH:Number = 800,
	    TILE_HEIGHT:Number = 600,
	    SCROLL_SCALE:Number = 0.2;

	private var
	    tiles:Tilemap;

	public function SkyBackground(x:Number, y:Number, 
				      numHorizontal:Number, 
				      numVertical:Number):void {
	    this.x = x;
	    this.y = y - numVertical*TILE_HEIGHT;

	    tiles = new Tilemap(SKY_TILE, TILE_WIDTH*numHorizontal, 
				TILE_HEIGHT*numVertical, TILE_WIDTH, TILE_HEIGHT);
	    tiles.scrollX = SCROLL_SCALE;
	    tiles.scrollY = SCROLL_SCALE;
	    graphic = tiles;

	    // render in the background
	    layer = 100;

	    for (var _x:Number=0; _x < numHorizontal; _x += 1) {
	    	for (var _y:Number=0; _y < numVertical; _y+=1) {
	    	    tiles.setTile(_x, _y, 0);
	    	}
	    }
	}

    }

}