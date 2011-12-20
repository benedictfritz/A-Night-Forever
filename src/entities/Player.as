package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class Player extends Entity {
	[Embed(source = '../../assets/images/png/player_anim_blank.png')]
	    private const PLAYER_SPRITE:Class;

	private const
	    Y_SPEED_MAX:Number = 100,
	    JUMP_SPEED:Number = 8;

	private var
	    sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 32, 32),
	    gravity:Number = 1,
	    jumping:Boolean = false,
	    xSpeed:Number = 80,
	    ySpeed:Number = 0;

	public function Player(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    sprPlayer.add("stand", [0], 1, true);
	    sprPlayer.add("jump", [4], 1, true);
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
		sprPlayer.play("right");
		x += moveDistance;
		if(collide("level", x, y)) {
		    x -= moveDistance;
		}
	    }
	    if (Input.check(Key.A)) {
		sprPlayer.play("right");
		x -= moveDistance;
		if(collide("level", x, y)) {
		    x += moveDistance;
		}
	    }

	    if (Input.pressed(Key.W)) {
		sprPlayer.play("jump");
		if (!jumping) {
		    jumping = true;
		    ySpeed = JUMP_SPEED;
		}
	    }

	    if (jumping) {
		sprPlayer.play("jump");
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
    }
}