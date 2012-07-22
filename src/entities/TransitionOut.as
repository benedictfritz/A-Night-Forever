package entities 
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.graphics.Particle;
    import net.flashpunk.tweens.misc.VarTween;
	
    /*
     * This class is from Noel Berry's OSPE
     * http://www.noelberry.ca/
     * Much love
     */
    public class TransitionOut extends Entity {
	// alpha is used for the rectangle which is drawn over the screen 
	// (so that it fades out)
	private var 
	    colour:uint = 0x000000,
	    transitionToWorld:World;

	public var
	    alpha:Number = 0;
		
	public function TransitionOut(worldToTransitionTo:World) {
	    //set ourselves above everything else
	    layer = -1000;
	    transitionToWorld = worldToTransitionTo;

	    var alphaTween:VarTween = new VarTween(transition);
	    alphaTween.tween(this, "alpha", 1, 1);
	    FP.world.addTween(alphaTween);
	}

	private function transition():void {
	    FP.world = transitionToWorld;
	}

	override public function render():void {
	    Draw.rect(FP.camera.x, FP.camera.y, FP.width, FP.height, colour, alpha);
	}

    }
}