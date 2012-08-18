package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;
    import net.flashpunk.utils.Ease;

    import entities.*;


    public class FlyingSO extends SO {
	[Embed(source = '../../assets/images/couple.png')]
	    private const COUPLE_SPRITE:Class;

	public var
	    minX:Number,
	    maxX:Number,
	    flying:Boolean=true,
	    goingLeft:Boolean;

	private var
	    accelTween:VarTween = null;
	
	private var
	    nextX:Number,
	    swerveTween:VarTween;

	public var
	    stopped:Boolean = false;

	public function FlyingSO(x:int=0, y:int=0) {
	    super(x, y);

	    // make the hitbox shorter so the player has to get to head-level
	    // to collide
	    setHitbox(sprActor.width - hitboxXBuffer*2, 18, -hitboxXBuffer, 0);

	    sprActor = new Spritemap(COUPLE_SPRITE, 96, 96);
	    sprActor.add("slow", [12, 13], 8, true);
	    sprActor.add("fast", [12, 13], 16, true);
	    sprActor.add("stop", [12], 1, true);
	    sprActor.play("slow");
	    this.graphic = sprActor;



	    vy = 500;
	}

	public function goUncatchable():void {
	    if (!accelTween) {
		accelTween = new VarTween(endAccelTween);
		accelTween.tween(this, "vy", 1200, 1, Ease.sineInOut);
		addTween(accelTween);
	    }
	}

	private function endAccelTween():void {
	    accelTween = null;
	}

	public function goFaster():void {
	    if (!accelTween) { vy = 700; }
	}

	public function goFast():void {
	    if (!accelTween) { vy = 500; }
	}

	public function goSlow():void {
	    if (!accelTween) { vy = 100; }
	}

	public function stop():void {
	    // stop anything that could mess with our moveToCenterTween
	    FP.world.clearTweens();

	    stopped = true;
	    var moveToCenter:VarTween = new VarTween(stopCompletion);
	    var centerX:Number = FP.halfWidth-this.width/2-this.hitboxXBuffer/2;
	    FP.console.log(centerX);
	    moveToCenter.tween(this, "x", centerX, 1);
	    FP.world.addTween(moveToCenter);
	    goingLeft = centerX < x;
	}

	private function stopCompletion():void {
	    flying = false;
	    vy = 0;
	}

	override public function update():void {
	    super.update();

	    (goingLeft) ? flip(true) : flip(false);
	    adjustHair();

	    if (flying) {
		if (!nextX) { resetNextX(); };
		move();
	    }
	}

	private function move():void {
	    moveBy(0, -vy * FP.elapsed, "level", true);
	}

	private function adjustHair():void {
	    if (!flying) { sprActor.play("stop"); }
	    else if (vy < 500) { sprActor.play("slow"); }
	    else { sprActor.play("fast"); }
	}

	private function resetNextX():void {
	    if (flying) {
		var range:Number = maxX - minX;
		var numInRange:Number = FP.random * range;
		nextX = numInRange + (minX + originX);

		(nextX < x) ? goingLeft = true : goingLeft = false;

		swerveTween = new VarTween(resetNextX);
		swerveTween.tween(this, "x", nextX, 3, Ease.sineOut);
		FP.world.addTween(swerveTween);
	    }
	}
    }
}