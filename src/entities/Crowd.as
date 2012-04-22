package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    public class Crowd extends Entity {
	[Embed(source = '../../assets/images/crowd.png')]
	    private const CROWD_IMAGE:Class;

	private var
	    yOffset:Number = 20;

	public function Crowd(x:int=0, y:int=0, position:String="foreground") {
	    this.x = x;
	    this.y = y;

	    if (position == "foreground") {
		this.layer = -10;
	    }
	    else if (position == "background") {
		this.layer = 10;
	    }
	    else {
		FP.console.log("Invalid position string passed. Must be 'foreground' or 'background'.");
	    }

	    this.graphic = new Image(CROWD_IMAGE);
	    this.y += yOffset;
	}
    }
}