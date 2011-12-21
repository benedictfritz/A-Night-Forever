package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class Player extends Actor {
	[Embed(source = '../../assets/images/png/player_anim_blank.png')]
	    private const PLAYER_SPRITE:Class;

	private const
	    Y_SPEED_MAX:Number = 100,
	    JUMP_SPEED:Number = 8;

	private var
	    sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 32, 32),
	    gravity:Number = 1,
	    jumping:Boolean = false;

	public function Player(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    // declared within super
	    xSpeed = 80;
	    ySpeed = 0;

	    sprPlayer.add("stand", [0], 1, true);
	    sprPlayer.add("jump", [3], 1, true);
	    sprPlayer.add("right", [1, 2, 3, 4, 5, 6, 7, 6], 8, true);
	    sprPlayer.color = 0xad2e3c;
	    this.graphic = sprPlayer;
	    setHitbox(sprPlayer.width, sprPlayer.height);
	    type = "player";
	}

	override public function update():void {
	    super.update();
	    checkKeyPresses();
	}

	private function checkKeyPresses():void {
	    var moveDistance:Number = xSpeed * FP.elapsed;

	    if (Input.check(Key.D)) {
		jumping ? sprPlayer.play("jumpRight") : sprPlayer.play("right");
		x += moveDistance;
		if(collide("level", x, y)) {
		    x -= moveDistance;
		}
	    }
	    else if (Input.check(Key.A)) {
		jumping ? sprPlayer.play("jumpLeft") : sprPlayer.play("left");

		x -= moveDistance;
		if(collide("level", x, y)) {
		    x += moveDistance;
		}
	    }
	    else {
		jumping ? sprPlayer.play("jumpStraight") : sprPlayer.play("stand");
	    }

	    if (Input.pressed(Key.W)) {
		// if (FP.sign(moveDistance)) { sprPlayer.play("jumpRight"); }
		// else { sprPlayer.play("jumpLeft"); }

		if (!jumping) {
		    jumping = true;
		    ySpeed = JUMP_SPEED;
		}
	    }

	    if (jumping) {
		y -= ySpeed;
		if (ySpeed < Y_SPEED_MAX) {
		    ySpeed -= gravity;
		}
		if (collide("level", x, y)) {
		    jumping = false;
		    while(collide("level", x, y)) {
			y -= 1;
		    }
		}
	    }
	    // walking off edges case
	    else if (!collide("level", x, y+1)) {
		jumping = true;
		ySpeed = 0;
	    }
	}

	public function setGravity(gravity:Number):void {
	    this.gravity = gravity;
	}

	override public function playRight():void {
	    sprPlayer.play("right");
	}

	override public function playLeft():void {
	    sprPlayer.play("left");
	}

	override public function playFaceRight():void {
	    sprPlayer.play("standRight");
	}

	override public function playFaceLeft():void {
	    sprPlayer.play("standLeft");
	}

	// used for flipping sprites
	private function flip(f:Boolean = true):void {
	    if (sprPlayer.flipped == f) return;
	    sprPlayer.flipped = f;
	}
    }
}