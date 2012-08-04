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
	
	private var 
	    sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 96, 96),
	    sprSO:Spritemap = new Spritemap(SO_SPRITE, 96, 96);

	private var 
	    timePerFrame:Number = 0.3,
	    timePerFrameDecrementor:Number = 0.003;
	private static var MIN_TIME_PER_FRAME:Number = 0.05;

	private var spinAngleSpeed:Number = 10;

	private var timer:Number = 0;

	public function FusedPlayer(x:int, y:int):void {
	    super(x, y);
	    centerOrigin();
	    sprPlayer.centerOO();
	    sprSO.centerOO();
	}

	override public function update():void {
	    timer += FP.elapsed;
	    if (timer > timePerFrame) {
		timer = 0;

		// make the time per frame decrease
		timePerFrame -= timePerFrameDecrementor;
		if (timePerFrame < MIN_TIME_PER_FRAME) {
		    timePerFrame = MIN_TIME_PER_FRAME;
		}

		var randFrame:int = int(FP.random*10);
		sprPlayer.frame = randFrame;
		sprSO.frame = randFrame;
		this.graphic = ((FP.random * 2) < 1) ? sprPlayer : sprSO;
	    }

	    sprPlayer.angle += FP.elapsed * spinAngleSpeed;
	    sprSO.angle += FP.elapsed * spinAngleSpeed;
	    spinAngleSpeed += FP.elapsed*40;
	}
    }
}