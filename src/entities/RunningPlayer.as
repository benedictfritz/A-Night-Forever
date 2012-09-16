package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.Monster;

    public class RunningPlayer extends Player {
	[Embed(source = '../../assets/sounds/music.swf', symbol='step1')]
	    static public const STEP_1:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step2')]
	    static public const STEP_2:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step3')]
	    static public const STEP_3:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step4')]
	    static public const STEP_4:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step5')]
	    static public const STEP_5:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step6')]
	    static public const STEP_6:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step7')]
	    static public const STEP_7:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step8')]
	    static public const STEP_8:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='step9')]
	    static public const STEP_9:Class;

	private const 
	    JUMP_SPEED:Number = 240,
	    MIN_SPEED:Number = 10.0,
	    COLLISION_TIME:Number = 1,
	    PICKUP_DISTANCE:Number = 30,
	    PICKUP_TIME:Number = 4;

	private const
	    FAST_MAX_SPEED:Number = 170,
	    MEDIUM_MAX_SPEED:Number = 130,
	    SLOW_MAX_SPEED:Number = 60;

	private const
	    FAST_X_ACCEL:Number = 20,
	    MEDIUM_X_ACCEL:Number = 15,
	    SLOW_X_ACCEL:Number = 5;

	private var
	    gravity:Number = 400,
	    xFriction:Number = 0.1;

	public var
	    fallen:Boolean = false,
	    pickingUp:Boolean = false;

	private var
	    goingFast:Boolean = true,
	    goingMedium:Boolean = false,
	    goingSlow:Boolean = false;

	private var
	    _currentStepSound:Number = 0,
	    _stepSounds:Array;

	public var canJump:Boolean = false;

	public function RunningPlayer(x:int=0, y:int=0) {
	    super(x, y);

	    _stepSounds = new Array(new Sfx(STEP_1), new Sfx(STEP_2),
				   new Sfx(STEP_3), new Sfx(STEP_4),
				   new Sfx(STEP_5), new Sfx(STEP_6),
				   new Sfx(STEP_7), new Sfx(STEP_8),
				   new Sfx(STEP_9));
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
	    var maxSpeed:Number;
	    if (goingFast) {
		xAccel = FAST_X_ACCEL;
		maxSpeed = FAST_MAX_SPEED;
	    }
	    if (goingSlow) {
		xAccel = SLOW_X_ACCEL;
		maxSpeed = SLOW_MAX_SPEED;
	    }
	    if (goingMedium) {
		xAccel = MEDIUM_X_ACCEL;
		maxSpeed = MEDIUM_MAX_SPEED;
	    }

	    // left / right movement
	    if (Input.check("right")) { vx += xAccel; }
	    else if (Input.check("left")) { vx -= xAccel; }
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
	    if (canJump && Input.pressed("up") && !jumping) {
		vy = -JUMP_SPEED;
		jumping = true;
	    }

	    if (jumping) {
		vy > 0 ? sprActor.play("fall") : sprActor.play("jump");
		vy += gravity * FP.elapsed;
	    }
	    else {
		vy = 0;
	    }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);

	    if (!jumping && (sprActor.frame == 3 || sprActor.frame == 7)) {
		if (!(_stepSounds[_currentStepSound].playing)) {
		    _currentStepSound++;
		    if (_currentStepSound >= _stepSounds.length) {
			_currentStepSound = 0;
		    }
		    FP.console.log(_currentStepSound);
		    _stepSounds[_currentStepSound].play(0.05);
		}
	    }

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
	    var endY:Number = this.y - PICKUP_DISTANCE;
	    upTween.tween(this, "y", endY, PICKUP_TIME/2);
	    FP.world.addTween(upTween);
	}

	private function liftDown():void {
	    var downTween:VarTween = new VarTween();
	    var endY:Number = this.y + PICKUP_DISTANCE;
	    downTween.tween(this, "y", endY, PICKUP_TIME/2);
	    FP.world.addTween(downTween);
	}

	/*
	 * speed modification
	 */

	public function goFast():void {
	    goingFast = true;
	    goingMedium = false;
	    goingSlow = false;
	}

	public function goMedium():void {
	    goingFast = false;
	    goingMedium = true;
	    goingSlow = false;
	}

	public function goSlow():void {
	    goingFast = false;
	    goingMedium = false;
	    goingSlow = true;
	}

    }

}
