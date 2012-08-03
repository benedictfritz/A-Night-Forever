package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    public class Player extends Actor {
	[Embed(source = '../../assets/images/player.png')]
	    private const PLAYER_SPRITE:Class;

	public var
	    hitboxXBuffer:Number = 35,
	    hitboxYBuffer:Number = 20;

	public function Player(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    this.color = 0xEEEEEE;

	    sprActor = new Spritemap(PLAYER_SPRITE, 96, 96);
	    sprActor.add("stand", [0], 1, true);
	    sprActor.add("jump", [5], 1, true);
	    sprActor.add("fall", [7], 1, true);
	    sprActor.add("sit", [9], 1, true);
	    sprActor.add("run", [1, 2, 3, 4, 5, 6, 7, 8], 7, true);
	    sprActor.color = color;
	    this.graphic = sprActor;
	    setHitbox(sprActor.width - hitboxXBuffer*2, 
		      sprActor.height-hitboxYBuffer, -hitboxXBuffer, 0);

	    // adjust the y position so the player doesn't fall after being
	    // added to the world
	    this.x -= hitboxXBuffer;
	    this.y += hitboxYBuffer;
	    type = "player";
	}

	/*
	 * Actor overrides
	 */
	override public function playRight():void {
	    sprActor.play("run");
	    flip(false);
	}

	override public function playLeft():void {
	    sprActor.play("run");
	    flip(true);
	}

	override public function playFaceRight():void {
	    sprActor.play("stand");
	    flip(false);
	}

	override public function playFaceLeft():void {
	    sprActor.play("stand");
	    flip(true);
	}

	public function playSitRight():void {
	    sprActor.play("sit");
	    flip(false);
	}
    }
}