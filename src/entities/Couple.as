package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;

    public class Couple extends Entity
    {
	private static const
	    GRAVITY:Number = 700,
	    MAX_VY:Number = 500,
	    MIN_Y:Number = 0,
	    X_SPEED:Number = 300;

	private var
	    vx:Number = 0,
	    vy:Number = 0;

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
	    checkKeyPresses();
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

	    vy += GRAVITY * FP.elapsed;
	    if (vy > MAX_VY) { vy = MAX_VY; }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed);

	    if (y < MIN_Y) { y = MIN_Y; }
	}

	public function starBoost():void {
	    vy = -400;
	}
    }
}