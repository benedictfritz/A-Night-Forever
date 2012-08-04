package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class FusedPlayer extends Entity {
	[Embed(source = '../../assets/images/player.png')]
	    private const PLAYER_SPRITE:Class;
	[Embed(source = '../../assets/images/so.png')]
	    private const SO_SPRITE:Class;
	
	private static const TIME_PER_SWITCH:Number = 0.1;

	private var 
	    sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 96, 96),
	    sprSO:Spritemap = new Spritemap(SO_SPRITE, 96, 96);

	private var timer:Number = 0;

	public function FusedPlayer(x:int, y:int):void {
	    super(x, y);
	    centerOrigin();
	    sprPlayer.centerOO();
	    sprSO.centerOO();
	}

	override public function update():void {
	    timer += FP.elapsed;
	    if (timer > TIME_PER_SWITCH) {
		timer = 0;

		var randFrame:int = int(FP.random*10);
		sprPlayer.frame = randFrame;
		sprSO.frame = randFrame;
		this.graphic = ((FP.random * 2) < 1) ? sprPlayer : sprSO;
	    }

	    sprPlayer.angle += FP.elapsed * 20;
	    sprSO.angle += FP.elapsed * 20;
	}
    }
}