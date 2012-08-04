package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;

    public class EmptySpace extends World
    {
	private var fusedPlayer:FusedPlayer;
	private var skyBackground:SkyBackground;

	public function EmptySpace():void {}

	override public function begin():void {
	    super.begin();

	    skyBackground = new SkyBackground(0, FP.height, 1, 1);
	    add(skyBackground);

	    fusedPlayer = new FusedPlayer(FP.halfWidth, FP.halfHeight);
	    add(fusedPlayer);
	}

    }
}