package worlds
{
    import net.flashpunk.World;
    import net.flashpunk.FP;

    import entities.*;
	
    public class Intro2 extends World {
	[Embed(source="../../assets/levels/Intro2.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static const
	    CAM_X_OFFSET:Number = 64;

	private var
	    level:Level,
	    player:RunningPlayer,
	    SO:RunningSO,
	    crowd:Crowd,
	    skyBackground:SkyBackground,
	    transitionIn:TransitionIn,
	    playerEntering:Boolean=false;

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
		crowd = new Crowd(int(dataElement.@x), int(dataElement.@y), "foreground");
		add(crowd);
	    }

	    dataList = levelData.objects.backgroundCrowd;
	    for each(dataElement in dataList) {
		crowd = new Crowd(int(dataElement.@x), int(dataElement.@y), "background");
		add(crowd);
	    }

	    skyBackground = new SkyBackground(0, FP.height, 2, 2);
	    add(skyBackground);

	    transitionIn = new TransitionIn(0.02, 0x000000);
	    add(transitionIn);
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

	    if (player.x > FP.width+CAM_X_OFFSET) {
		var transitionOut:TransitionOut = new TransitionOut(new Intro3());
		add(transitionOut);
	    }
	}
    }
}