package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Spritemap;

    public class Couple extends Entity
    {
	private static const
	    GRAVITY:Number = 700,
	    MAX_VY:Number = 500,
	    MIN_Y:Number = 0,
	    X_SPEED:Number = 300;

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
	    sprCouple.add("downOne", [2], 4, true);
	    sprCouple.add("downTwo", [3], 4, true);
	    sprCouple.add("upOne", [4], 4, true);
	    sprCouple.add("upTwo", [5], 4, true);
	    sprCouple.play("upOne");
	    
	    this.graphic = sprCouple;
	    setHitbox(sprCouple.width, sprCouple.height);
	    type = "couple";
	    layer = 0;
	}

	override public function update():void {
	    super.update();

	    if (tweeningUp) { sprCouple.play("upOne"); }
	    else { sprCouple.play("downOne"); }

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

	    /* standard left / right movement */
	    if (Input.check(Key.D)) { vx = X_SPEED; }
	    else if (Input.check(Key.A)) { vx = -X_SPEED; }
	    else { vx = 0; }
	    if(vx != 0) { vx < 0 ? flip(true) : flip(false); }

	    vy += GRAVITY * FP.elapsed;
	    if (vy > MAX_VY) { vy = MAX_VY; }

	    if (vy <= 0) { sprCouple.play("upOne"); }
	    else { sprCouple.play("downOne"); }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed);

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