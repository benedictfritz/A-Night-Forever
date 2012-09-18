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

	private var
	    blackBackgroundEntity:Entity,
	    textEntity:Entity;

	override public function begin():void {
	    super.begin();
	    
	    blackBackgroundEntity = new Entity(0, 0, Image.createRect(FP.width, FP.height, 0x000000, 1));
	    add(blackBackgroundEntity);

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