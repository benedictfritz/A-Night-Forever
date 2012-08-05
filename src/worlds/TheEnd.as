package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.VarTween;

    public class TheEnd extends World
    {
	[Embed(source = '../../assets/images/white_background.png')]
	    private const BACKGROUND_IMAGE:Class;
	[Embed(source = '../../assets/images/the_end.png')]
	    private const THE_END_TEXT:Class;

	private var
	    whiteBackgroundEntity:Entity,
	    textEntity:Entity;

	override public function begin():void {
	    super.begin();
	    
	    whiteBackgroundEntity = new Entity(0, 0, new Image(BACKGROUND_IMAGE));
	    add(whiteBackgroundEntity);

	    var textImage:Image = new Image(THE_END_TEXT);
	    textImage.alpha = 0;
	    textEntity = new Entity(0, FP.halfHeight - textImage.height/2, textImage);
	    add(textEntity);
	    FP.alarm(2, fadeInText);
	}

	private function fadeInText():void {
	    var alphaTween:VarTween = new VarTween();
	    var textImage:Image = Image(textEntity.graphic);
	    alphaTween.tween(textImage, "alpha", 1, 5);
	    addTween(alphaTween);
	}

    }
}