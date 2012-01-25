package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    public class FlyingPlayer extends Player {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const PLAYER_SPRITE:Class;

	private var
	    acceleration:Number = 50,
	    friction:Number = 0.05;

	public function FlyingPlayer(x:int=0, y:int=0) {
	    super(x, y);
	}

	override public function update():void {
	    super.update();
	    FP.console.log("update " + FP.elapsed);
	    if (controllable) { checkKeyPresses(); }
	}

	private function checkKeyPresses():void {
	    if (Input.check(Key.D)) { vx += acceleration; }
	    else if (Input.check(Key.A)) { vx -= acceleration; }
	    vx -= vx*friction;

	    if (Input.check(Key.S)) { vy += acceleration; }
	    else if (Input.check(Key.W)) { vy -= acceleration; }
	    vy -= vy*friction;

	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}
    }
}