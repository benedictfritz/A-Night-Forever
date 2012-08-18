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
	
    public class Intro1 extends Intro {
	[Embed(source="../../assets/levels/Intro1.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static const
	    PAN_TIME:Number = 3,
	    CAMERA_START_Y:Number = -1200,
	    NUM_TITLE_CLOUDS:Number = 10,
	    NUM_PLAYING_CLOUDS:Number = 10;

	private var
	    level:Level,
	    titleScreen:TitleScreen,
	    transitionOut:TransitionOut,
	    player:RunningPlayer,
	    SO:RunningSO,
	    skyBackground:SkyBackground;

	private var
    	    inMenu:Boolean=true,
	    inText:Boolean=false,
	    playing:Boolean = false;

	private var
	    panToPlayingTween:VarTween,
	    panToTextTween:VarTween;

	override public function begin():void {
	    super.begin();
	    FP.camera.y = CAMERA_START_Y;
	    initLevel();
	}

	override public function update():void {
	    super.update();

	    if (inMenu) { inMenuUpdate(); }
	    else if (inText) { inTextUpdate(); }
	    else if (playing) { playingUpdate(); }
	}

	/*
	 * update methods
	 */
	private function inMenuUpdate():void {
	    if (Input.check(Key.DOWN)) {
		inMenu = false;

		panToTextTween = new VarTween(function():void { inText = true; });
		panToTextTween.tween(FP.camera, "y", -FP.height, PAN_TIME);
		addTween(panToTextTween);
	    }
	}

	private function inTextUpdate():void {
	    if (Input.check(Key.DOWN)) {
		inText = false;

		panToPlayingTween = new VarTween(function():void {
			playing = true;
			player.setControllable(true);
		    });
		panToPlayingTween.tween(FP.camera, "y", 0, PAN_TIME);
		addTween(panToPlayingTween);
	    }
	}

	private function playingUpdate():void {
	    if (!SO.running && Input.check(Key.RIGHT)) {
		SO.running = true;
	    }
	    if (player.x > FP.width && !transitionOut) {
		transitionOut = new TransitionOut(new Intro2());
		add(transitionOut);
	    }
	}

	/*
	 * level initialization
	 */

	private function initLevel():void {
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

	    spawnClouds();

	    skyBackground = new SkyBackground(0, FP.height, 1, 3);
	    add(skyBackground);
	}

	private function spawnClouds():void {
	    var i:int, j:int;

	    var numHorizontalCloudSectors:int = 8;
	    var numVerticalCloudSectors:int = 3;
	    var sectorWidth:Number = FP.width*2/numHorizontalCloudSectors;
	    var sectorHeight:Number = FP.height/numVerticalCloudSectors;

	    // title screen
	    for (i=0; i < numHorizontalCloudSectors; i++) {
		for (j=0; j < numVerticalCloudSectors; j++) {
		    // don't spawn clouds where title is
		    if (j == 1) { continue; }

		    var randCloudX:Number = Math.random()*sectorWidth
			+ i*sectorWidth;
		    // subtract 30 since big clouds have their origin high up
		    var randCloudY:Number = Math.random()*sectorHeight
			+ j*sectorHeight + FP.camera.y - 100;
		    add(new VisualCloud(randCloudX, randCloudY));
		}
	    }
	}

    }
}