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
	    Y_SPEED_MAX:Number = -10,
	    JUMP_SPEED:Number = 16;

	public var
	    controllable:Boolean = true;

	private var
	    gravity:Number = 0.5,
	    jumping:Boolean = false,
	    xSpeed:Number = 360,
	    ySpeed:Number = 0,
	    vx:Number = 0,
	    vy:Number = 0,
	    maxY:Number;

	[Embed(source="../../assets/images/couple.png")]
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
	    if (controllable) { checkKeyPresses(); }
	}

	private function checkKeyPresses():void {
	    /* move-anywhere test code */
	    // if (Input.check(Key.D)) { vx += 80; }
	    // else if (Input.check(Key.A)) { vx -= 80; }
	    // vx -= vx*0.1;
	    // if (Input.check(Key.S)) { vy += 80; }
	    // else if (Input.check(Key.W)) { vy -= 80; }
	    // vy -= vy*0.1;
	    // moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);

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