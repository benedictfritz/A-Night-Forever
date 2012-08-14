package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.graphics.Tilemap;

    public class SkyBackground extends Entity {
	[Embed(source="../../assets/images/star_background.png")]
	    private const SKY_TILE:Class;

	public static var
	    TILE_WIDTH:Number = 800,
	    TILE_HEIGHT:Number = 600,
	    SCROLL_SCALE:Number = 0.2;

	public var
	    tiles:Tilemap;

	private var skyNumber:Text;

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

	    tiles.usePositions = true;

	    skyNumber = new Text("("+x+", "+y+")");
	    skyNumber.size = 46;

	    for (var _x:Number=0; _x < numHorizontal*TILE_WIDTH; _x += TILE_WIDTH) {
	    	for (var _y:Number=0; _y < numVertical*TILE_HEIGHT; _y += TILE_HEIGHT) {
	    	    tiles.setTile(_x, _y, 0);
	    	}
	    }
	}

	override public function render():void {
	    super.render();
	    // debug code
	    tiles.drawGraphic(380, 280, skyNumber);
	}

    }

}