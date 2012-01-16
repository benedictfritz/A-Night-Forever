package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    public class Player extends Actor {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const PLAYER_SPRITE:Class;

	private const JUMP_SPEED:Number = 130;

	private var
	    gravity:Number = 300;

	public var
	    color:uint = 0xEEEEEE;

	public function Player(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    // declared within super
	    xSpeed = 80;
	    ySpeed = 0;
	    sprActor = new Spritemap(PLAYER_SPRITE, 32, 32),

	    sprActor.add("stand", [0], 1, true);
	    sprActor.add("jump", [3], 1, true);
	    sprActor.add("fall", [8], 1, true);
	    sprActor.add("run", [1, 2, 3, 4, 5, 6, 7, 6], 8, true);
	    sprActor.color = color;
	    this.graphic = sprActor;
	    setHitbox(sprActor.width, sprActor.height);
	    type = "player";
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

	public function setGravity(gravity:Number):void {
	    this.gravity = gravity;
	}

	/*
	 * Actor overrides
	 */
	override public function playRight():void {
	    sprActor.play("run");
	    flip(false);
	}

	override public function playLeft():void {
	    sprActor.play("run");
	    flip(true);
	}

	override public function playFaceRight():void {
	    sprActor.play("stand");
	    flip(false);
	}

	override public function playFaceLeft():void {
	    sprActor.play("stand");
	    flip(true);
	}
    }
}