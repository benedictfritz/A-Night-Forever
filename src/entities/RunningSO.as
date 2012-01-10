package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class RunningSO extends SO {
	private const 
	    JUMP_SPEED:Number = 130,
	    GRAVITY:Number = 300,
	    // how far the SO looks ahead to see whether or not to jump
	    JUMP_LOOKAHEAD:Number = 32;

	private var
	    pickingUp:Boolean = false;

	public function RunningSO(x:int=0, y:int=0) {
	    super(x, y);

	    // make the SO a little slower than the player so that you can catch up
	    xSpeed -= 10
	}

	public function pickUpPlayer(x:Number, y:Number):void {
	    pickingUp = true;

	    
	}

	override public function update():void {
	    if (pickingUp) 
		return;

	    var jumping:Boolean = collide("level", x, y+1) == null;

	    vx = xSpeed;
	    sprActor.play("run");

	    if (collide("level", x+JUMP_LOOKAHEAD, y) && !jumping) {
		vy = -JUMP_SPEED;
	    }
	    if (jumping) {
		vy > 0 ? sprActor.play("fall") : sprActor.play("jump");
		vy += GRAVITY * FP.elapsed;
	    }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}
    }
}