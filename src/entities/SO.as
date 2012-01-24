package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class SO extends Actor {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const SO_SPRITE:Class;

	public function SO(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    this.color = 0xEE0000;

	    // set variables declared in super
	    sprActor = new Spritemap(SO_SPRITE, 64, 64);
	    xSpeed = 160;
	    ySpeed = 0;

	    sprActor.add("stand", [0], 1, true);
	    sprActor.add("jump", [4], 1, true);
	    sprActor.add("run", [1, 2, 3, 4, 5, 6, 7, 6], 8, true);
	    sprActor.color = color;
	    this.graphic = sprActor;
	    setHitbox(sprActor.width, sprActor.height);
	    type = "player";
	}

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