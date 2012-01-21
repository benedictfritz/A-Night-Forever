package entities 
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.graphics.Particle;
	
    /*
     * Based on Noel's TransitionIn class
     */
    public class TransitionIn extends Entity {
	public var 
	    alpha:Number = 1;
	private var 
	    colour:uint = 0x000000;
		
	public function TransitionIn() {
	    layer = -1000;
	}
		
	override public function render():void {
	    Draw.rect(FP.camera.x, FP.camera.y, FP.width, FP.height, colour, alpha);

	    alpha -= 0.01;

	    if (alpha < 0) {
		FP.world.remove(this);
	    }
	}

    }
}