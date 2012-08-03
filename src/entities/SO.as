package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class SO extends Actor {
	[Embed(source = '../../assets/images/so.png')]
	    private const SO_SPRITE:Class;

	public var
	    hitboxXBuffer:Number = 35,
	    hitboxYBuffer:Number = 20;

	public function SO(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    // set variables declared in super
	    xSpeed = 160;
	    ySpeed = 0;

	    sprActor = new Spritemap(SO_SPRITE, 96, 96);
	    sprActor.add("stand", [0], 1, true);
	    sprActor.add("jump", [5], 1, true);
	    sprActor.add("fall", [7], 1, true);
	    sprActor.add("run", [1, 2, 3, 4, 5, 6, 7, 8], 12, true);

	    this.graphic = sprActor;
	    setHitbox(sprActor.width - hitboxXBuffer*2, sprActor.height-hitboxYBuffer, 
		      -hitboxXBuffer, 0);
	    this.x -= hitboxXBuffer;
	    this.y += hitboxYBuffer;
	    type = "SO";
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