package
{
    import net.flashpunk.Engine;
    import net.flashpunk.FP;

    import worlds.*;

    [SWF(width="800", height="600")]

    public class Main extends Engine {
	public function Main() {
	    super(800, 600, 60, false);
	    FP.screen.scale = 2;
	    FP.console.enable();
	    FP.world = new Intro();
	}
    }
}