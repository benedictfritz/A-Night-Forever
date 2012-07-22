package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.tweens.sound.SfxFader;

    import entities.*;
	
    public class Intro2 extends World {
	[Embed(source="../../assets/levels/Intro2.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_2')]
	    static public const MUSIC:Class;

	private static const
	    CAM_X_OFFSET:Number = 64,
	    NUM_CLOUDS:Number = 8;

	private var
	    level:Level,
	    player:RunningPlayer,
	    SO:RunningSO,
	    crowd:Crowd,
	    skyBackground:SkyBackground,
	    transitionIn:TransitionIn,
	    transitionOut:TransitionOut,
	    playerEntering:Boolean=false;

	private var
	    music:Sfx = new Sfx(MUSIC);

	override public function begin():void {
	    super.begin();

	    // start off one tile to the right so we can spawn things off 
	    // the screen and they can run in.
	    FP.camera.x = CAM_X_OFFSET;

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

	    dataList = levelData.objects.foregroundCrowd;
	    for each(dataElement in dataList) {
		crowd = new Crowd(int(dataElement.@x), int(dataElement.@y), 
				  "foreground");
		add(crowd);
	    }

	    dataList = levelData.objects.backgroundCrowd;
	    for each(dataElement in dataList) {
		crowd = new Crowd(int(dataElement.@x), int(dataElement.@y), 
				  "background");
		add(crowd);
	    }

	    for (var i:int = 0; i < NUM_CLOUDS; i++) {
		var randCloudX:Number = Math.random()*(FP.width+FP.halfWidth);
		var randCloudY:Number = Math.random()*(FP.halfHeight);
		add(new VisualCloud(randCloudX, randCloudY));
	    }

	    skyBackground = new SkyBackground(0, FP.height, 2, 2);
	    add(skyBackground);

	    transitionIn = new TransitionIn(0.02, 0x000000);
	    add(transitionIn);

	    music.play(0);
	    var fadeIn:SfxFader = new SfxFader(music);
	    fadeIn.fadeTo(1, 2);
	    this.addTween(fadeIn);
	}

	override public function update():void {
	    super.update();

	    // yo dawg i heard you like working with lots of state

	    if (transitionIn.done) {
		if (!SO.running) {
		    SO.running = true;
		}
	    }

	    if (SO.x > 200 && !playerEntering && player.x < CAM_X_OFFSET) {
		playerEntering = true;
	    }

	    if (playerEntering) {
		player.playRight();
		player.x += 2;
	    }

	    if (player.x > CAM_X_OFFSET) {
		playerEntering = false;
		player.setControllable(true);
	    }

	    if (player.x > FP.width+CAM_X_OFFSET && !transitionOut) {
		var fadeOut:SfxFader = new SfxFader(music);
		fadeOut.fadeTo(0, 3);
		FP.tweener.addTween(fadeOut);

		transitionOut = new TransitionOut(new Intro3());
		add(transitionOut);
	    }
	}
    }
}