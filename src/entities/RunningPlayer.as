package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    public class RunningPlayer extends Player {

	private const 
	    JUMP_SPEED:Number = 230,
	    MIN_SPEED:Number = 10.0,
	    MAX_SPEED:Number = 170;

	private var
	    gravity:Number = 400,
	    xAcceleration:Number = 20,
	    xFriction:Number = 0.1;

	public function RunningPlayer(x:int=0, y:int=0) {
	    super(x, y);
	}

	override public function update():void {
	    super.update();
	    if (controllable) { checkKeyPresses(); }
	}

	private function checkKeyPresses():void {
	    var jumping:Boolean = collide("level", x, y+1) == null;

	    // left / right movement
	    if (Input.check(Key.D)) { vx += xAcceleration; }
	    else if (Input.check(Key.A)) { vx -= xAcceleration; }
	    vx -= vx * xFriction;
	    if (Math.abs(vx) > MAX_SPEED) { vx = FP.sign(vx)*MAX_SPEED; }

	    if(vx != 0) { vx < 0 ? flip(true) : flip(false); }

	    FP.console.log(vx);

	    if (Math.abs(vx) < MIN_SPEED) {
		sprActor.play("stand");
	    }
	    else {
		sprActor.play("run");
		sprActor.rate = FP.scale(Math.abs(vx), 0, MAX_SPEED, 0, 1);
	    }
	    
	    // jumping movement
	    if (Input.check(Key.W)) {
		if (!jumping) { vy = -JUMP_SPEED }
	    }
	    if (jumping) {
		vy > 0 ? sprActor.play("fall") : sprActor.play("jump");
		vy += gravity * FP.elapsed;
	    }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}

    }

}