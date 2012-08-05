package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.VarTween;

    import worlds.TheEnd;

    import entities.*;

    public class EmptySpace extends World
    {
	[Embed(source="../../assets/images/star_background.png")]
	    private const SKY:Class;

	private var fusedPlayer:FusedPlayer;

	private var 
	    rightBackground:Vector.<Entity>,
	    leftBackground:Vector.<Entity>,
	    downBackground:Vector.<Entity>,
	    upBackground:Vector.<Entity>;

	public function EmptySpace():void {}

	override public function begin():void {
	    super.begin();

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

	    FP.alarm(35, goToEnd);
	}

	private function goToEnd():void {
	    FP.world = new TheEnd();
	}

	override public function update():void {
	    super.update();

	    var background_1:Entity;
	    var background_2:Entity;

	    // sort the background entities so they are in the order of display
	    FP.sortBy(rightBackground, "x");
	    background_1 = rightBackground[0];
	    background_2 = rightBackground[1];
	    background_1.x += FP.elapsed * 200;
	    background_2.x += FP.elapsed * 200;
	    if (background_2.x >= FP.width) {
	    	// weird off-by-one issues
	    	background_2.x = background_1.x - FP.width - 1;
	    }

	    FP.sortBy(leftBackground, "x", false);
	    background_1 = leftBackground[0];
	    background_2 = leftBackground[1];
	    background_1.x -= FP.elapsed * 200;
	    background_2.x -= FP.elapsed * 200;
	    if (background_2.x <= -FP.width) {
	    	// weird off-by-one issues
	    	background_2.x = background_1.x + FP.width + 1;
	    }

	    FP.sortBy(downBackground, "y");
	    background_1 = downBackground[0];
	    background_2 = downBackground[1];
	    background_1.y += FP.elapsed * 200;
	    background_2.y += FP.elapsed * 200;
	    if (background_2.y >= FP.height) {
	    	// weird off-by-one issues
	    	background_2.y = background_1.y - FP.height - 1;
	    }

	    FP.sortBy(upBackground, "y", false);
	    background_1 = upBackground[0];
	    background_2 = upBackground[1];
	    background_1.y -= FP.elapsed * 200;
	    background_2.y -= FP.elapsed * 200;
	    if (background_2.y <= -FP.height) {
		// weird off-by-one issues
		background_2.y = background_1.y + FP.height + 1;
	    }
	}

    }
}