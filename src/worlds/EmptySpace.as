package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.VarTween;

    import worlds.TheEnd;

    import entities.*;

    public class EmptySpace extends World
    {
	[Embed(source="../../assets/images/moving_star_background.png")]
	    private const SKY:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'wind')]
	    static public const WIND:Class;

	private var fusedPlayer:FusedPlayer;

	private var 
	    rightBackground:Vector.<Entity>,
	    leftBackground:Vector.<Entity>,
	    downBackground:Vector.<Entity>,
	    upBackground:Vector.<Entity>;

	private var
	    right_v:Number = 200,
	    left_v:Number = 200,
	    down_v:Number = 200,
	    up_v:Number = 200;

	private var
	    windSound:Sfx = new Sfx(WIND);

	private static const
	    DECEL:Number = 800,
	    MAX_ACCEL:Number = 1500,
	    MIN_ACCEL:Number = 200;

	private var
	    accel:Number = 400;

	public function EmptySpace():void {}

	override public function begin():void {
	    super.begin();

	    windSound.play(0.2);

	    var backgroundImage:Image = new Image(SKY);
	    backgroundImage.alpha = 0.25;

	    var backgroundEntity:Entity;
	    // there is an off-by-one thing that I'm too lazy to figure out
	    rightBackground = new Vector.<Entity>();
	    rightBackground.push(add(new Entity(-FP.width-1, 0, backgroundImage)));
	    rightBackground.push(add(new Entity(0, 0, backgroundImage)));

	    leftBackground = new Vector.<Entity>();
	    leftBackground.push(add(new Entity(-1, 0, backgroundImage)));
	    leftBackground.push(add(new Entity(FP.width, 0, backgroundImage)));

	    downBackground = new Vector.<Entity>();
	    downBackground.push(add(new Entity(0, -FP.height-1, backgroundImage)));
	    downBackground.push(add(new Entity(0, 0, backgroundImage)));

	    upBackground = new Vector.<Entity>();
	    upBackground.push(add(new Entity(0, 0, backgroundImage)));
	    upBackground.push(add(new Entity(0, FP.height+1, backgroundImage)));

	    fusedPlayer = new FusedPlayer(FP.halfWidth, FP.halfHeight);
	    add(fusedPlayer);

	    FP.alarm(30, goToEnd);
	}

	private function goToEnd():void {
	    windSound.stop();
	    FP.world = new TheEnd();
	}

	override public function update():void {
	    super.update();

	    if (Input.check("right")) {
		right_v += FP.elapsed*accel;
		if (right_v > MAX_ACCEL) { right_v = MAX_ACCEL; }
	    }
	    else {
		right_v -= FP.elapsed*DECEL;
		if (right_v < MIN_ACCEL) { right_v = MIN_ACCEL; }
	    }

	    if (Input.check("left")) {
		left_v += FP.elapsed*accel;
		if (left_v > MAX_ACCEL) { left_v = MAX_ACCEL; }
	    }
	    else {
		left_v -= FP.elapsed*DECEL;
		if (left_v < MIN_ACCEL) { left_v = MIN_ACCEL; }
	    }

	    if (Input.check("up")) {
		up_v += FP.elapsed*accel;
		if (up_v > MAX_ACCEL) { up_v = MAX_ACCEL; }
	    }
	    else {
		up_v -= FP.elapsed*DECEL;
		if (up_v < MIN_ACCEL) { up_v = MIN_ACCEL; }
	    }

	    if (Input.check("down")) {
		down_v += FP.elapsed*accel;
		if (down_v > MAX_ACCEL) { down_v = MAX_ACCEL; }
	    }
	    else {
		down_v -= FP.elapsed*DECEL;
		if (down_v < MIN_ACCEL) { down_v = MIN_ACCEL; }
	    }

	    var maxVel:Number = Math.max.apply(null, new Array(Math.abs(right_v),
							       Math.abs(left_v),
							       Math.abs(up_v),
							       Math.abs(down_v)));
	    FP.console.log(windSound.volume);
	    windSound.volume = FP.scale(maxVel, 0, MAX_ACCEL, 0.2, 1);

	    var background_1:Entity;
	    var background_2:Entity;

	    // sort the background entities so they are in the order of display
	    FP.sortBy(rightBackground, "x");
	    background_1 = rightBackground[0];
	    background_2 = rightBackground[1];
	    background_1.x += FP.elapsed * right_v;
	    background_2.x += FP.elapsed * right_v;
	    if (background_2.x >= FP.width) {
	    	// weird off-by-one issues
	    	background_2.x = background_1.x - FP.width - 1;
	    }

	    FP.sortBy(leftBackground, "x", false);
	    background_1 = leftBackground[0];
	    background_2 = leftBackground[1];
	    background_1.x -= FP.elapsed * left_v;
	    background_2.x -= FP.elapsed * left_v;
	    if (background_2.x <= -FP.width) {
	    	// weird off-by-one issues
	    	background_2.x = background_1.x + FP.width + 1;
	    }

	    FP.sortBy(downBackground, "y");
	    background_1 = downBackground[0];
	    background_2 = downBackground[1];
	    background_1.y += FP.elapsed * down_v;
	    background_2.y += FP.elapsed * down_v;
	    if (background_2.y >= FP.height) {
	    	// weird off-by-one issues
	    	background_2.y = background_1.y - FP.height - 1;
	    }

	    FP.sortBy(upBackground, "y", false);
	    background_1 = upBackground[0];
	    background_2 = upBackground[1];
	    background_1.y -= FP.elapsed * up_v;
	    background_2.y -= FP.elapsed * up_v;
	    if (background_2.y <= -FP.height) {
		// weird off-by-one issues
		background_2.y = background_1.y + FP.height + 1;
	    }
	}

    }
}