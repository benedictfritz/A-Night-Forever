package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;

    public class FlyingSO extends SO {
	[Embed(source = '../../assets/images/couple.png')]
	    private const COUPLE_SPRITE:Class;

	public var
	    minX:Number,
	    maxX:Number;
	
	private var
	    nextX:Number,
	    swerveTween:VarTween,
	    goingLeft:Boolean;

	public function FlyingSO(x:int=0, y:int=0) {
	    super(x, y);

	    sprActor = new Spritemap(COUPLE_SPRITE, 96, 96);
	    sprActor.add("slow", [0, 1], 8, true);
	    sprActor.add("fast", [0, 1], 16, true);
	    this.graphic = sprActor;

	    vy = -500;
	}

	override public function update():void {
	    super.update();

	    if (!nextX) { resetNextX(); };
	    move();

	    (goingLeft) ? flip(true) : flip(false);
	    adjustHair();
	}

	private function move():void {
	    moveBy(0, vy * FP.elapsed, "level", true);
	}

	private function adjustHair():void {
	    if (vy > -500) { sprActor.play("slow"); }
	    else { sprActor.play("fast"); }
	}
	
	private function resetNextX():void {
	    var range:Number = maxX - minX;
	    var numInRange:Number = FP.random * range;
	    nextX = numInRange + (minX + originX);

	    (nextX < x) ? goingLeft = true : goingLeft = false;

	    swerveTween = new VarTween(resetNextX);
	    swerveTween.tween(this, "x", nextX, 3, Ease.sineInOut);
	    FP.world.addTween(swerveTween);
	}
    }
}