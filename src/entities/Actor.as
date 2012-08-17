package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class Actor extends Entity {
	protected var
	    xSpeed:Number,
	    ySpeed:Number,
	    controllable:Boolean = true,
	    sprActor:Spritemap;

	public var
	    vx:Number = 0,
	    vy:Number = 0;

	public var
	    isAdjusting:Boolean = false,
	    color:uint = 0xFFFFFF;

	public function moveLeft(xLimit:Number):void {
	    vx = -xSpeed;
	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	    this.playLeft();
	    if (this.centerX <= xLimit) {
		this.playFaceLeft();
		this.x = xLimit - this.halfWidth;
	    }
	}

	public function moveRight(xLimit:Number):void {
	    vx = xSpeed;
	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	    this.playRight();	    

	    if (this.centerX >= xLimit) {
		this.playFaceRight();
		this.x = xLimit - this.halfWidth;
	    }
	}

	// used for flipping sprites
	protected function flip(val:Boolean=true):void {
	    if (sprActor.flipped == val) return;
	    sprActor.flipped = val;
	}

	public function setControllable(val:Boolean=true):void {
	    this.controllable = val;
	}
	
	public function getControllable():Boolean {
	    return this.controllable;
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