package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;

    public class Actor extends Entity {
	protected var
	    xSpeed:Number = 5,
	    ySpeed:Number = 0;

	public function moveLeft(xLimit:Number):void {
	    this.x -= xSpeed * FP.elapsed;
	    this.playLeft();
	    if (this.x <= xLimit) {
		this.playFaceLeft();
		this.x = xLimit;
	    }
	}

	public function moveRight(xLimit:Number):void {
	    this.x += xSpeed * FP.elapsed;
	    this.playRight();	    
	    if (this.x >= xLimit) {
		this.playFaceRight();
	    	this.x = xLimit;
	    }
	}

	// I'm basically trying to do an objective-c prototype without knowing how
	// to do it in actionscript. This is bad. I should come back and figure out
	// how to do this right.

	public function playRight():void {
	    // subclasses must implement this method to play their right-moving
	    // animation
	    FP.console.log("ERROR: Subclasses must implement playRight()");
	}

	public function playLeft():void {
	    // subclasses must implement this method to play their left-moving
	    // animation
	    FP.console.log("ERROR: Subclasses must implement playLeft()");
	}

	public function playFaceRight():void {
	    // subclasses must implement this method to play their right-facing
	    // animation
	    FP.console.log("ERROR: Subclasses must implement playFaceRight()");
	}

	public function playFaceLeft():void {
	    // subclasses must implement this method to play their left-moving
	    // animation
	    FP.console.log("ERROR: Subclasses must implement playFaceLeft()");
	}
    }
}