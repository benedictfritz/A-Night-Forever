package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;
    import worlds.EmptySpace;

    public class Conclusion extends World
    {
	[Embed(source = '../../assets/images/white_background.png')]
	    private const BACKGROUND_IMAGE:Class;
	[Embed(source = '../../assets/images/conclusion_text_1.png')]
	    private const CONCLUSION_TEXT_1:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'high_ring')]
	    static public const RING:Class;

	private var
	    whiteBackgroundEntity:Entity,
	    textEntity:Entity;

	private var
	    ring:Sfx = new Sfx(RING);

	override public function begin():void {
	    super.begin();

	    ring.play();

	    whiteBackgroundEntity = new Entity(0, 0, new Image(BACKGROUND_IMAGE));
	    add(whiteBackgroundEntity);

	    FP.alarm(3, goToEmpty);

	    // var textImage:Image = new Image(CONCLUSION_TEXT_1);
	    // textImage.alpha = 0;
	    // textEntity = new Entity(0, FP.halfHeight - textImage.height/2, textImage);
	    // add(textEntity);
	    // FP.alarm(2, fadeInText);
	}

	private function fadeInText():void {
	    var alphaTween:VarTween = new VarTween(goToEmpty);
	    var textImage:Image = Image(textEntity.graphic);
	    alphaTween.tween(textImage, "alpha", 1, 5);
	    addTween(alphaTween);
	}

	private function goToEmpty():void {
	    ring.stop();
	    FP.world = new EmptySpace();
	}
    }
}