package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class VisualCloud extends Entity {
	[Embed(source="../../assets/images/cloud.png")]
	    private const SLOWING_CLOUD_SPRITE:Class;

	public static var
	    IMG_WIDTH:Number = 128,
	    IMG_HEIGHT:Number = 64;

	private var
	    sprCloud:Spritemap,
	    vx:Number = -10 - Math.random()*10;

	public function VisualCloud(x:int=0, y:int=0, scale:Number=1) {
	    this.x = x;
	    this.y = y;

	    sprCloud = new Spritemap(SLOWING_CLOUD_SPRITE, IMG_WIDTH, IMG_HEIGHT);
	    sprCloud.add("default", [0], 1, false);
	    sprCloud.scale = scale;
	    this.graphic = sprCloud;

	    layer = 50;
	}

	override public function update():void {
	    moveBy(vx*FP.elapsed, 0);
	}
    }

}