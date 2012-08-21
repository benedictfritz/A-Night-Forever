package
{
    import net.flashpunk.FP;
    import net.flashpunk.Engine;
    import net.flashpunk.graphics.Text;

    import worlds.*;

    [SWF(width="800", height="600")]

    public class Main extends Engine {
	[Embed(source = '../assets/Marion.ttc', embedAsCFF="false", 
	       fontFamily = 'marion_font')]
	    public static const MARION:Class;

        public function Main() {
	    super(800, 600, 60, false);
	    Text.font = 'marion_font';
	    FP.world = new Intro1();
        }
    }
}
