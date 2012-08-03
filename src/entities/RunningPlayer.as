package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.Monster;

    public class RunningPlayer extends Player {

	private const 
	    JUMP_SPEED:Number = 230,
	    MIN_SPEED:Number = 10.0,
	    FAST_MAX_SPEED:Number = 170,
	    SLOW_MAX_SPEED:Number = 90,
	    COLLISION_TIME:Number = 1,
	    PICKUP_DISTANCE:Number = 30;

	private var
	    gravity:Number = 400,
	    fastXAcceleration:Number = 20,
	    slowXAcceleration:Number = 10,
	    xFriction:Number = 0.1;

	public var
	    fallen:Boolean = false,
	    pickingUp:Boolean = false;

	public var
	    goingFast:Boolean = true;

	public function RunningPlayer(x:int=0, y:int=0) {
	    super(x, y);
	}

	override public function update():void {
	    super.update();

	    if (controllable) { 
	    	checkMonsterCollisions();
	    	checkKeyPresses(); 
	    }
	    if (fallen) { sprActor.play("sit"); }
	    if (pickingUp) { sprActor.play("jump"); }
	}

	private function checkKeyPresses():void {
	    var jumping:Boolean = collide("level", x, y+1) == null;

	    
	    var xAccel:Number;
	    xAccel = (goingFast) ? fastXAcceleration : slowXAcceleration;

	    var maxSpeed:Number;
	    maxSpeed = (goingFast) ? FAST_MAX_SPEED : SLOW_MAX_SPEED;

	    // left / right movement
	    if (Input.check(Key.RIGHT)) { vx += xAccel; }
	    else if (Input.check(Key.LEFT)) { vx -= xAccel; }
	    vx -= vx * xFriction;
	    if (Math.abs(vx) > maxSpeed) { vx = FP.sign(vx)*maxSpeed; }

	    if(vx != 0) { vx < 0 ? flip(true) : flip(false); }

	    if (Math.abs(vx) < MIN_SPEED) {
		sprActor.play("stand");
	    }
	    else {
		sprActor.play("run");
		sprActor.rate = FP.scale(Math.abs(vx), 0, maxSpeed, 0, 1);
	    }
	    
	    // jumping movement
	    if (Input.check(Key.UP)) {
		if (!jumping) { vy = -JUMP_SPEED }
	    }
	    if (jumping) {
		vy > 0 ? sprActor.play("fall") : sprActor.play("jump");
		vy += gravity * FP.elapsed;
	    }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}

	private function checkMonsterCollisions():void {
	    var monster:Monster = collide("monster", x, y) as Monster;
	    if (monster != null) {
		xFriction = 0.2;

		var alphaTween:VarTween = new VarTween(fadeIn);
		alphaTween.tween(sprActor, "alpha", 0.4, COLLISION_TIME/2);
		addTween(alphaTween);

		monster.despawn();
		FP.alarm(COLLISION_TIME, function():void { xFriction = 0.1; });
	    }
	}

	private function fadeIn():void {
	    var alphaTween:VarTween = new VarTween();
	    alphaTween.tween(sprActor, "alpha", 1, COLLISION_TIME/2);
	    addTween(alphaTween);
	}

	/*
	 * picking up
	 */ 

	public function liftUp():void {
	    var upTween:VarTween = new VarTween(liftDown);
	    var blah:Number = this.y - PICKUP_DISTANCE;
	    upTween.tween(this, "y", blah, 1);
	    FP.world.addTween(upTween);
	}

	private function liftDown():void {
	    var downTween:VarTween = new VarTween();
	    var blah:Number = this.y + PICKUP_DISTANCE;
	    downTween.tween(this, "y", blah, 1);
	    FP.world.addTween(downTween);
	}

    }

}
