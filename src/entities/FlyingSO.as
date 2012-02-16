package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;

    public class FlyingSO extends SO {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const PLAYER_SPRITE:Class;

	public var
	    minX:Number,
	    maxX:Number;
	
	private var
	    nextX:Number;

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
	    if (vx > 0 && x >= nextX) {
		resetNextX();
	    }
	    else if (vx < 0 && x < nextX) {
		resetNextX();
	    }

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}
	
	private function resetNextX():void {
	    var range:Number = maxX - minX;
	    var numInRange:Number = FP.random * range;
	    nextX = numInRange + (minX + originX);

	    FP.console.log(nextX);

	    if (x <= nextX) {
	    	vx = 200;
	    }
	    else if (x > nextX) {
	    	vx = -200;
	    }
	}
    }
}