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
	[Embed(source = '../../assets/images/player.png')]
	    private const PLAYER_SPRITE:Class;

	public var
	    minX:Number,
	    maxX:Number;
	
	private var
	    nextX:Number,
	    swerveTween:VarTween;

	public function FlyingSO(x:int=0, y:int=0) {
	    super(x, y);
	    vy = -500;
	}

	override public function update():void {
	    super.update();

	    if (!nextX) { resetNextX(); };
	    move();
	}

	private function move():void {
	    moveBy(0, vy * FP.elapsed, "level", true);
	}
	
	private function resetNextX():void {
	    var range:Number = maxX - minX;
	    var numInRange:Number = FP.random * range;
	    nextX = numInRange + (minX + originX);

	    swerveTween = new VarTween(resetNextX);
	    swerveTween.tween(this, "x", nextX, 3, Ease.sineInOut);
	    FP.world.addTween(swerveTween);
	}
    }
}