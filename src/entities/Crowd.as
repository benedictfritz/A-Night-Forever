package entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    public class Crowd extends Entity {
	[Embed(source = '../../assets/images/crowd.png')]
	    private const CROWD_IMAGE:Class;

	public function Crowd(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    this.layer = -10;

	    this.graphic = new Image(CROWD_IMAGE);
	}
    }
}