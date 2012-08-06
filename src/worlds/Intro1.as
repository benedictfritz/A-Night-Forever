package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.tweens.misc.VarTween;
    import net.flashpunk.tweens.sound.SfxFader;

    import util.Util;
    import entities.*;
	
    public class Intro1 extends World {
	[Embed(source="../../assets/levels/Intro1.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_1_a')]
	    static public const MUSIC_1_A:Class;

	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_1_b')]
	    static public const MUSIC_1_B:Class;

	private static const
	    PAN_TIME:Number = 3,
	    CAMERA_START_Y:Number = -400,
	    NUM_CLOUDS:Number = 10;

	private var
	    level:Level,
	    titleScreen:TitleScreen,
	    transitionOut:TransitionOut,
	    player:RunningPlayer,
	    SO:RunningSO,
	    panDownTween:VarTween,
	    inMenu:Boolean=true,
	    panning:Boolean=true,
	    skyBackground:SkyBackground;

	private var
	    music_a:Sfx,
	    music_b:Sfx,
	    currentSong:Sfx,
	    aFader:SfxFader,
	    bFader:SfxFader;

	override public function begin():void {
	    super.begin();

	    music_a = new Sfx(MUSIC_1_A);
	    music_b = new Sfx(MUSIC_1_B);
	    // set the current song to the other song as soon 
	    // as it completes
	    music_a.complete = function():void { currentSong = music_b; };
	    music_b.complete = function():void { currentSong = music_a; };
	    music_a.play();
	    currentSong = music_a;

	    FP.camera.y = CAMERA_START_Y;

	    titleScreen = new TitleScreen(0, CAMERA_START_Y);
	    add(titleScreen);
	    
	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();

	    var dataElement:XML;
	    var dataList:XMLList = levelData.objects.player;
	    for each(dataElement in dataList) {
		player = new RunningPlayer(int(dataElement.@x),
					   int(dataElement.@y));
		add(player);
	    }
	    player.goMedium();
	    player.setControllable(false);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		SO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
		add(SO);
	    }

	    for (var i:int = 0; i < NUM_CLOUDS; i++) {
		var randCloudX:Number = Math.random()*(FP.width + FP.halfWidth);
		var randCloudY:Number = 
		    Math.random()*(FP.halfHeight - CAMERA_START_Y)
		    + CAMERA_START_Y;
		add(new VisualCloud(randCloudX, randCloudY));
	    }

	    skyBackground = new SkyBackground(0, FP.height, 1, 3);
	    add(skyBackground);
	}

	override public function update():void {
	    super.update();

	    if (inMenu) {
		if (Input.check(Key.DOWN)) { inMenu = false; }
	    }
	    else {
		if (!panDownTween) {
		    panDownTween = new VarTween(finishPanning);
		    panDownTween.tween(FP.camera, "y", 0, PAN_TIME);
		    FP.world.addTween(panDownTween);
		}
	    }

	    // run SO off screen as soon as the player 
	    // moves right
	    if (!panning && Input.check(Key.RIGHT)) {
		SO.running = true;
	    }
	    
	    if (player.x > FP.width) {
		if (!aFader || !bFader || !transitionOut) {
		    // fade out the music
		    aFader = new SfxFader(music_a);
		    aFader.fadeTo(0, 3);
		    FP.tweener.addTween(aFader);
		    bFader = new SfxFader(music_b);
		    bFader.fadeTo(0, 3);
		    FP.tweener.addTween(bFader);

		    transitionOut = new TransitionOut(new Intro2());
		    add(transitionOut);
		}
	    }
	    else {
		updateMusic();
	    }
	}

	private function finishPanning():void {
	    panning = false;
	    player.setControllable(true);
	}

	private function updateMusic():void {
	    // the updating of the current song var
	    // happens in the music's completion callback
	    // set in the initialization
	    if (currentSong == music_a) {
		if (music_a.length - music_a.position < 8
		    && !music_b.playing) {
		    music_b.play();
		}
	    }
	    if (currentSong == music_b) {
		if (music_b.length - music_b.position < 8
		    && !music_a.playing) {
		    music_a.play();
		}
	    }
	}

    }
}