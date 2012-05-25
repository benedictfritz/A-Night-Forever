package entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    
    public class TitleScreen extends Entity {

	[Embed(source='../../assets/images/title_screen.png')]
	    private const TITLE_SCREEN:Class;

	private var
	    titleImage:Image = new Image(TITLE_SCREEN);
	
	public function TitleScreen(x:int, y:int) {
	    super(x, y, titleImage);
	}

    }
}