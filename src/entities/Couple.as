package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Spritemap;

    import entities.LandingCloud;

    public class Couple extends Entity
    {
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'star_hit1')]
	    static public const STAR_HIT1:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'star_hit2')]
	    static public const STAR_HIT2:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'star_hit3')]
	    static public const STAR_HIT3:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'star_hit4')]
	    static public const STAR_HIT4:Class;

	public static const
	    MIN_SHAKE_VY:Number = 1000;
	
	private static const
	    GRAVITY:Number = 700,
	    MAX_GRAVITY:Number = 200,
	    MIN_Y:Number = 0,
	    X_AIR_ACCEL:Number = 30,
	    X_CLOUD_ACCEL:Number = 15,
	    X_FRICTION:Number = 0.05,
	    MAX_VX:Number = 300,
	    MAX_NORM_GRAV_VY:Number = 500;

	public var 
	    controllable:Boolean = true,
	    tweeningUp:Boolean,
	    vx:Number = 0,
	    vy:Number = 0;

	private var
	    sprCouple:Spritemap;

	private var
	    currentStarHit:Number=1,
	    starHit1:Sfx = new Sfx(STAR_HIT1),
	    starHit2:Sfx = new Sfx(STAR_HIT2),
	    starHit3:Sfx = new Sfx(STAR_HIT3),
	    starHit4:Sfx = new Sfx(STAR_HIT4);

	[Embed(source="../../assets/images/couple.png")]
	    private const COUPLE_SPRITE:Class;

	public function Couple(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    sprCouple = new Spritemap(COUPLE_SPRITE, 96, 96);
	    sprCouple.smooth = true;
	    sprCouple.add("down_left", [6,7], 14, true);
	    sprCouple.add("down_right", [2,3], 14, true);
	    sprCouple.add("up_left", [8, 9], 14, true);
	    sprCouple.add("up_right", [4, 5], 14, true);
	    sprCouple.add("stand_left", [11], 1, true);
	    sprCouple.add("stand_right", [10], 1, true);
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
		if (tweeningUp) { sprCouple.play("up_right"); }
		else { sprCouple.play("down_right"); }
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
		if (Input.check("right")) { vx += 80; }
		else if (Input.check("left")) { vx -= 80; }
		vx -= vx*0.1;
		if (Input.check("down")) { vy += 80; }
		else if (Input.check("up")) { vy -= 80; }
		vy -= vy*0.1;
	    }
	    else {
		/* standard left / right movement */
		var onCloud:Boolean =
		    collide("landingCloud", x, y+1) as LandingCloud != null;

		if (Input.check("right")) {
		    vx += (onCloud) ? X_CLOUD_ACCEL : X_AIR_ACCEL;
		}
		else if (Input.check("left")) {
		    vx -= (onCloud) ? X_CLOUD_ACCEL : X_AIR_ACCEL;
		}

		vx -= vx*X_FRICTION;

		if (MAX_VX < Math.abs(vx)) { vx = FP.sign(vx)*MAX_VX; }

		if (vy > MAX_NORM_GRAV_VY) { vy += MAX_GRAVITY * FP.elapsed; }
		else { vy += GRAVITY * FP.elapsed; }
	    }

	    if (vy < 0) {
		(vx < 0) ? sprCouple.play("up_left") 
		    : sprCouple.play("up_right");
	    }
	    else {
		// only escalate star-hit noise when going up
		currentStarHit = 1;
		(vx < 0) ? sprCouple.play("down_left")
		    : sprCouple.play("down_right");
	    }
	    sprCouple.rate = FP.scale(Math.abs(vy), 0, MAX_NORM_GRAV_VY, 0, 1);

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
		    (vx < 0) ? sprCouple.play("stand_left") 
			: sprCouple.play("stand_right");

		    // don't want vy accumulating while standing on cloud
		    vy = 0;
		}
	    }
	    else {
		moveBy(vx * FP.elapsed, vy * FP.elapsed);
	    }

	    if (y < MIN_Y) { y = MIN_Y; }
	}

	public function starBoost():void {
	    var hitVolume:Number = 0.15 + FP.random * 0.1;
	    if (currentStarHit == 1) { starHit1.play(hitVolume); }
	    if (currentStarHit == 2) { starHit2.play(hitVolume); }
	    if (currentStarHit == 3) { starHit3.play(hitVolume); }
	    if (currentStarHit > 3) { starHit4.play(hitVolume); }

	    currentStarHit++;

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
