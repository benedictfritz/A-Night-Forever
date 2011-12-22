package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class Player extends Actor {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const PLAYER_SPRITE:Class;

	private const JUMP_SPEED:Number = 130;

	private var
	    sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 32, 32),
	    gravity:Number = 300,
	    controllable:Boolean = true;

	public function Player(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    // declared within super
	    xSpeed = 80;
	    ySpeed = 0;

	    sprPlayer.add("stand", [0], 1, true);
	    sprPlayer.add("jump", [3], 1, true);
	    sprPlayer.add("fall", [8], 1, true);
	    sprPlayer.add("run", [1, 2, 3, 4, 5, 6, 7, 6], 8, true);
	    sprPlayer.color = 0xad2e3c;
	    this.graphic = sprPlayer;
	    setHitbox(sprPlayer.width, sprPlayer.height);
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
	    vx == 0 ? sprPlayer.play("stand") : sprPlayer.play("run");
	    flip(vx < 0);

	    // jumping movement
	    if (Input.check(Key.W)) {
		if (!jumping) { vy = -JUMP_SPEED }
	    }
	    if (jumping) {
		vy > 0 ? sprPlayer.play("fall") : sprPlayer.play("jump");
		vy += gravity * FP.elapsed;
	    }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}

	public function setGravity(gravity:Number):void {
	    this.gravity = gravity;
	}

	override public function playRight():void {
	    sprPlayer.play("run");
	    flip(false);
	}

	override public function playLeft():void {
	    sprPlayer.play("run");
	    flip(true);
	}

	override public function playFaceRight():void {
	    sprPlayer.play("stand");
	    flip(false);
	}

	override public function playFaceLeft():void {
	    sprPlayer.play("stand");
	    flip(true);
	}

	// used for flipping sprites
	private function flip(val:Boolean=true):void {
	    if (sprPlayer.flipped == val) return;
	    sprPlayer.flipped = val;
	}

	public function setControllable(val:Boolean=true):void {
	    this.controllable = val;
	}
	
	public function getControllable():Boolean {
	    return this.controllable;
	}
    }
}