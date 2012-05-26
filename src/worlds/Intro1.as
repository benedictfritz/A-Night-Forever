package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.tweens.misc.VarTween;

    import util.Util;
    import entities.*;
	
    public class Intro1 extends World {
	[Embed(source="../../assets/levels/Intro1.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	[Embed(source = "../../assets/sounds/music.swf#intro")]
	    static public const FLASH_MUSIC:Class;

	private static const
	    PAN_TIME:Number = 3,
	    CAMERA_START_Y:Number = -400,
	    NUM_CLOUDS:Number = 10;

	private var
	    level:Level,
	    music:Sfx,
	    titleScreen:TitleScreen,
	    player:RunningPlayer,
	    SO:RunningSO,
	    panDownTween:VarTween,
	    inMenu:Boolean=true,
	    panning:Boolean=true,
	    skyBackground:SkyBackground;

	override public function begin():void {
	    super.begin();

	    music = new Sfx(FLASH_MUSIC);
	    music.loop();

	    FP.camera.y = CAMERA_START_Y;

	    titleScreen = new TitleScreen(0, CAMERA_START_Y);
	    add(titleScreen);
	    
	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();

	    var dataElement:XML;
	    var dataList:XMLList = levelData.objects.player;
	    for each(dataElement in dataList) {
		player = new RunningPlayer(int(dataElement.@x), int(dataElement.@y));
		add(player);
	    }
	    player.setControllable(false);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		SO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
		add(SO);
	    }

	    for (var i:int = 0; i < NUM_CLOUDS; i++) {
		var randCloudX:Number = Math.random()*(FP.width + FP.halfWidth);
		var randCloudY:Number = 
		    Math.random()*(FP.halfHeight - CAMERA_START_Y) + CAMERA_START_Y;
		add(new VisualCloud(randCloudX, randCloudY, Math.random()*1.5+1));
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
		var transitionOut:TransitionOut = new TransitionOut(new Intro2());
		add(transitionOut);
	    }
	}

	private function finishPanning():void {
	    panning = false;
	    player.setControllable(true);
	}

    }
}