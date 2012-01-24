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
	    JUMP_SPEED:Number = 130;

	private var
	    gravity:Number = 300;

	public function RunningPlayer(x:int=0, y:int=0) {
	    super(x, y);
	    xSpeed = 160;
	    ySpeed = 0;
	}

	override public function update():void {
	    super.update();
	    if (controllable) { checkKeyPresses(); }
	}

	private function checkKeyPresses():void {
	    var jumping:Boolean = collide("level", x, y+1) == null;

	    // left / right movement
	    if (Input.check(Key.D)) { vx = xSpeed; }
	    else if (Input.check(Key.A)) { vx = -xSpeed; }
	    else { vx = 0; }
	    vx == 0 ? sprActor.play("stand") : sprActor.play("run");
	    
	    if(vx != 0) { vx < 0 ? flip(true) : flip(false); }

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