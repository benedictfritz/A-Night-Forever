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
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const PLAYER_SPRITE:Class;

	public function Player(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    this.color = 0xEEEEEE;

	    sprActor = new Spritemap(PLAYER_SPRITE, 64, 64),
	    sprActor.add("stand", [0], 1, true);
	    sprActor.add("jump", [3], 1, true);
	    sprActor.add("fall", [8], 1, true);
	    sprActor.add("run", [1, 2, 3, 4, 5, 6, 7, 6], 8, true);
	    sprActor.color = color;
	    this.graphic = sprActor;
	    setHitbox(sprActor.width, sprActor.height);
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
    }
}