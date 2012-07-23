package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class VisualCloud extends Entity {
	[Embed(source="../../assets/images/cloud_small.png")]
	    private const SMALL_CLOUD_SPRITE:Class;
	[Embed(source="../../assets/images/cloud_med.png")]
	    private const MEDIUM_CLOUD_SPRITE:Class;
	[Embed(source="../../assets/images/cloud_large.png")]
	    private const LARGE_CLOUD_SPRITE:Class;

	public static var
	    IMG_WIDTH:Number = 128,
	    IMG_HEIGHT:Number = 64;

	private var
	    sprCloud:Spritemap,
	    vx:Number,
	    scale:Number;

	public function VisualCloud(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    this.scale = Math.random()*0.8+0.6;

	    var size:int = Math.random() * 3;
	    if (size == 0) {
		sprCloud = new Spritemap(SMALL_CLOUD_SPRITE, 128, 64);
		this.vx = FP.scale(scale, 0.6, 1.4, -5, -15);
	    }
	    if (size == 1) {
		sprCloud = new Spritemap(MEDIUM_CLOUD_SPRITE, 192, 96);
		this.vx = FP.scale(scale, 0.6, 1.4, -15, -25);
	    }
	    if (size == 2) {
		sprCloud = new Spritemap(LARGE_CLOUD_SPRITE, 256, 128);
		this.vx = FP.scale(scale, 0.6, 1.4, -30, -50);
	    }

	    layer = vx + 60;
	    sprCloud.add("default", [0], 1, false);
	    sprCloud.scale = scale;
	    this.graphic = sprCloud;
	}

	override public function update():void {
	    moveBy(vx*FP.elapsed, 0);

	    if ((x + sprCloud.width*scale) < FP.camera.x) {
		x = FP.camera.x + FP.width + 30;
	    }
	}
    }

}