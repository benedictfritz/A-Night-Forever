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
	    alpha:Number = 1,
	    done:Boolean=false;

	private var 
	    transitionSpeed:Number,
	    color:uint;
		
	public function TransitionIn(transitionSpeed:Number=0.01, 
				     color:uint=0x000000) {
	    this.transitionSpeed = transitionSpeed;
	    this.color = color;
	    layer = -1000;
	}
		
	override public function render():void {
	    Draw.rect(FP.camera.x, FP.camera.y, FP.width, FP.height, color, alpha);

	    alpha -= transitionSpeed;

	    if (alpha < 0) {
		FP.world.remove(this);
		done = true;
	    }
	}

    }
}