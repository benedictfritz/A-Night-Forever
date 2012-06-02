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
	    vx:Number,
	    scale:Number;

	public function VisualCloud(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    this.scale = Math.random()*1.5+1;

	    // smaller clouds are faster and in the front	    
	    this.vx = FP.scale(scale, 1, 2.5, -30, -10);
	    layer = vx + 40;

	    sprCloud = new Spritemap(SLOWING_CLOUD_SPRITE, IMG_WIDTH, IMG_HEIGHT);
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