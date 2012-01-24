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
	    gravity:Number = 300;

	public function Player(x:int=0, y:int=0) {
	}

	override public function update():void {
	    super.update();
	}
    }
}