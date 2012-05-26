package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Spritemap;

    import entities.LandingCloud;

    public class Couple extends Entity
    {
	private static const
	    GRAVITY:Number = 700,
	    MAX_VY:Number = 500,
	    MIN_Y:Number = 0,
	    X_AIR_ACCEL:Number = 30,
	    X_CLOUD_ACCEL:Number = 15,
	    X_FRICTION:Number = 0.05,
	    MAX_VX:Number = 300;

	public var 
	    controllable:Boolean = true,
	    tweeningUp:Boolean;

	private var
	    vx:Number = 0,
	    vy:Number = 0,
	    sprCouple:Spritemap;

	[Embed(source="../../assets/images/couple.png")]
	    private const COUPLE_SPRITE:Class;

	public function Couple(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    sprCouple = new Spritemap(COUPLE_SPRITE, 96, 96);
	    sprCouple.add("down", [2,3], 14, true);
	    sprCouple.add("up", [4, 5], 14, true);
	    sprCouple.add("stand", [4], 1, true);
	    this.graphic = sprCouple;

	    setHitbox(50, 15, 25, -30);
	    sprCouple.centerOO();
	    type = "couple";
	    layer = 0;
	}

	override public function update():void {
	    super.update();

	    if (controllable) { checkKeyPresses(); }
	    else {
		if (tweeningUp) { sprCouple.play("up"); }
		else { sprCouple.play("down"); }
	    }

	    if (vy < 0) {
		// rotate the player's head in the direction they want to go
		var scaledVx:Number = FP.scale(Math.abs(vx), 0, 720, 0, 10);
		sprCouple.angle = -FP.sign(vx) * scaledVx;
	    }
	    else {
		sprCouple.angle = 0;
	    }
	}

	private function checkKeyPresses():void {
	    /* move-anywhere test code */
	    var debugMovement:Boolean = false;
	    if (debugMovement) {
		if (Input.check(Key.RIGHT)) { vx += 80; }
		else if (Input.check(Key.LEFT)) { vx -= 80; }
		vx -= vx*0.1;
		if (Input.check(Key.DOWN)) { vy += 80; }
		else if (Input.check(Key.UP)) { vy -= 80; }
		vy -= vy*0.1;
	    }
	    else {
		/* standard left / right movement */
		var onCloud:Boolean = 
		    collide("landingCloud", x, y+1) as LandingCloud != null;

		if (Input.check(Key.RIGHT)) { 
		    vx += (onCloud) ? X_CLOUD_ACCEL : X_AIR_ACCEL;
		}
		else if (Input.check(Key.LEFT)) { 
		    vx -= (onCloud) ? X_CLOUD_ACCEL : X_AIR_ACCEL;
		}

		vx -= vx*X_FRICTION;

		if (MAX_VX < Math.abs(vx)) { vx = FP.sign(vx)*MAX_VX; }
		vy += GRAVITY * FP.elapsed;
	    }

	    if(vx != 0) { vx < 0 ? flip(true) : flip(false); }

	    if (vy > MAX_VY) { vy = MAX_VY; }

	    if (vy < 0) { sprCouple.play("up"); }
	    else { sprCouple.play("down"); }
	    sprCouple.rate = FP.scale(Math.abs(vy), 0, MAX_VY, 0, 1);

	    var collisionCloud:LandingCloud = 
		collide("landingCloud", x, y) as LandingCloud;
	    // couple can only land on cloud if they are heading down and 
	    // aren't already in a cloud
	    if (vy > 0 && !collisionCloud) {
		moveBy(vx * FP.elapsed, vy * FP.elapsed, "landingCloud");

		// after moving, check if we landed on cloud
		var doomCloud:LandingCloud = 
		    collide("landingCloud", x, y+1) as LandingCloud;
		if (doomCloud != null && !doomCloud.doomed) {
		    doomCloud.doomed = true;
		}
		if (doomCloud) {
		    // if we're on a cloud, stand on it
		    sprCouple.play("stand");
		}
	    }
	    else {
		moveBy(vx * FP.elapsed, vy * FP.elapsed);
	    }

	    if (y < MIN_Y) { y = MIN_Y; }
	}

	public function starBoost():void {
	    vy = -400;
	}

	/* this is the same flip code that the actor class has. unfortunately,
	 I don't think this class needs the functionality of the Actor class
	besides the ability to flip. should consider forking flashpunk and putting
	flip in the Entity class. */
	protected function flip(val:Boolean=true):void {
	    if (sprCouple.flipped == val) return;
	    sprCouple.flipped = val;
	}
    }
}
