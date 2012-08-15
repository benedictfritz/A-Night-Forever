package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.tweens.sound.SfxFader;

    import entities.FlyingSO;

    public class Intro extends World {
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_1_a')]
	    static public const MUSIC_1_A:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_1_b')]
	    static public const MUSIC_1_B:Class;

	private static var
	    music_a:Sfx,
	    music_b:Sfx,
	    currentSong:Sfx,
	    aFader:SfxFader,
	    bFader:SfxFader,
	    initialized:Boolean = false;

	override public function begin():void {
	    if (!initialized) {
		initialized = true;
		music_a = new Sfx(MUSIC_1_A);
		music_b = new Sfx(MUSIC_1_B);
		// set the current song to the other song as soon 
		// as it completes
		music_a.complete = function():void { currentSong = music_b; };
		music_b.complete = function():void { currentSong = music_a; };
		music_a.play();
		currentSong = music_a;
	    }
	}

	override public function update():void {
	    super.update();

	    // the updating of the current song var
	    // happens in the music's completion callback
	    // set in the initialization
	    if (currentSong == music_a) {
		if (music_a.length - music_a.position < 8
		    && !music_b.playing) {
		    music_b.play();
		    FP.console.log("starting b");
		}
	    }
	    if (currentSong == music_b) {
		if (music_b.length - music_b.position < 8
		    && !music_a.playing) {
		    music_a.play();
		    FP.console.log("starting a");
		}
	    }
	}

	override public function end():void {
	    super.end();

	    // if we've moved to world with flyingSO, we need to pan out
	    if (FP.world.classFirst(FlyingSO) != null) {
		// fade out the music
		aFader = new SfxFader(music_a);
		aFader.fadeTo(0, 1);
		FP.tweener.addTween(aFader);
		bFader = new SfxFader(music_b);
		bFader.fadeTo(0, 1);
		FP.tweener.addTween(bFader);
	    }
	}
    }
}