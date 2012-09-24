package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.VarTween;

    public class TheEnd extends World
    {
	[Embed(source = '../../assets/images/the_end.png')]
	    private const THE_END_TEXT:Class;
	[Embed(source = '../../assets/images/credits.png')]
	    private const CREDITS:Class;

	private var
	    blackBackgroundEntity:Entity,
	    textEntity:Entity,
	    creditsEntity:Entity;

	override public function begin():void {
	    super.begin();
	    
	    blackBackgroundEntity = new 
		Entity(0, 0, Image.createRect(FP.width, FP.height, 0x000000, 1));
	    add(blackBackgroundEntity);

	    var textImage:Image = new Image(THE_END_TEXT);
	    textImage.alpha = 0;
	    textEntity = new Entity(0, FP.halfHeight - textImage.height/2,
				    textImage);

	    creditsEntity = new Entity(0, 0, new Image(CREDITS));
	    Image(creditsEntity.graphic).alpha = 0;
	    add(creditsEntity);

	    add(textEntity);
	    FP.alarm(2, fadeInText);
	    FP.alarm(6, fadeOutText);
	    FP.alarm(9, fadeInCredits);
	}

	private function fadeInText():void {
	    var alphaTween:VarTween = new VarTween();
	    var textImage:Image = Image(textEntity.graphic);
	    alphaTween.tween(textImage, "alpha", 1, 3);
	    addTween(alphaTween);
	}

	private function fadeOutText():void {
	    var alphaTween:VarTween = new VarTween();
	    var textImage:Image = Image(textEntity.graphic);
	    alphaTween.tween(textImage, "alpha", 0, 3);
	    addTween(alphaTween);
	}

	private function fadeInCredits():void {
	    var creditsAlphaTween:VarTween = new VarTween();
	    creditsAlphaTween.tween(Image(creditsEntity.graphic), "alpha", 1, 3);
	    addTween(creditsAlphaTween);
	}

    }
}