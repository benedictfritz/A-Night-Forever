package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    public class Darkness extends Entity{
	[Embed(source='../../assets/images/darkness.png')]
	    private const DARKNESS_IMAGE:Class;

	public var done:Boolean = false;

	private const
	    ALPHA_SPEED:Number = 0.1;

	private var
	    camOffset:Number,
	    darknessImg:Image = new Image(DARKNESS_IMAGE);

	public function Darkness() {
	    super();

	    darknessImg.alpha = 0;
	    darknessImg.scrollX = 0;
	    darknessImg.scrollY = 0;
	    this.graphic = darknessImg;

	    layer = -500;
	}

	override public function update():void {
	    if (darknessImg.alpha < 1) {
		darknessImg.alpha += ALPHA_SPEED*FP.elapsed;
	    }
	    else {
		done = true;
	    }
	}
    }
}