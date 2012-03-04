package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Tilemap;

    public class SkyBackground extends Entity {
	[Embed(source="../../assets/images/star_background.png")]
	    private const SKY_TILE:Class;

	private var
	    tiles:Tilemap,
	    TILE_WIDTH:Number = 400,
	    TILE_HEIGHT:Number = 300;

	public function SkyBackground(x:Number, y:Number, 
				      numHorizontal:Number, 
				      numVertical:Number):void {
	    this.x = x;
	    this.y = y - numVertical*TILE_HEIGHT;

	    tiles = new Tilemap(SKY_TILE, TILE_WIDTH*numHorizontal, 
				TILE_HEIGHT*numVertical, TILE_WIDTH, TILE_HEIGHT);
	    tiles.scrollX = 0.2;
	    tiles.scrollY = 0.2;
	    graphic = tiles;

	    // render in the background
	    layer = 100;

	    for (var _x:Number=0; _x < numHorizontal; _x += 1) {
	    	for (var _y:Number=0; _y < numVertical; _y+=1) {
	    	    FP.console.log("Setting tile " + _x + ", " + _y);
	    	    tiles.setTile(_x, _y, 0);
	    	}
	    }
	}

    }

}