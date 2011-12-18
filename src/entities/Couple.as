package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;

    public class Couple extends Entity
    {
	private const
	    Y_SPEED_MAX:Number = -5,
	    JUMP_SPEED:Number = 8;

	private var
	    gravity:Number = 0.5,
	    jumping:Boolean = false,
	    xSpeed:Number = 180,
	    ySpeed:Number = 0;

	[Embed(source="../../assets/images/png/couple.png")]
	    private const COUPLE_IMG:Class;

	public function Couple(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    var img:Image = new Image(COUPLE_IMG);
	    this.graphic = img;
	    setHitbox(img.width, img.height);
	    type = "couple";
	}

	override public function update():void {
	    super.update();
	    checkKeyPresses();
	}

	private function checkKeyPresses():void {
	    var moveDistance:Number = xSpeed * FP.elapsed;

	    if (Input.check(Key.D)) {
		x += moveDistance;
		if(collide("level", x, y)) {
		    x -= moveDistance;
		}
	    }
	    if (Input.check(Key.A)) {
		x -= moveDistance;
		if(collide("level", x, y)) {
		    x += moveDistance;
		}
	    }

	    if (Input.pressed(Key.W)) {
		if (!jumping) {
		    jumping = true;
		    ySpeed = JUMP_SPEED;
		}
	    }

	    if (jumping) {
		y -= ySpeed;
		if (ySpeed > Y_SPEED_MAX) {
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

	public function starBoost():void {
	    ySpeed = 10;
	}
    }
}