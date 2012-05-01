package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;

    public class Monster extends Entity {
	private var 
	    xSpeed:Number = 100;

	public function Monster(x:int=0, y:int=0, graphic:Graphic=null):void {
	    type = "monster";
	    super(x, y, graphic);
	}

	override public function update():void {
	    super.update();
	    x -= FP.elapsed * xSpeed;
	}

	public function despawn():void {
	    FP.console.log("Subclasses should override the despawn function.");
	}
    }
}