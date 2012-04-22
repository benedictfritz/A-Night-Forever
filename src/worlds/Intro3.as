package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;
	
    public class Intro3 extends World {
	[Embed(source="../../assets/levels/Intro3.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static const
	    CAM_X_OFFSET:Number = 64,
	    SO_TAKEOFF_DISTANCE:Number = 300,
	    SO_TAKEOFF_TIME:Number = 3;

	private var
	    level:Level,
	    player:RunningPlayer,
	    SO:RunningSO,
	    skyBackground:SkyBackground,
	    transitionIn:TransitionIn,
	    playerEntering:Boolean=false,
	    soUpTween:VarTween;

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

	    if (SO.x > 500) {
		SO.running = false;
		SO.playFaceLeft();
	    }

	    // TODO: replace distance with distance where SO takes off.
	    if (player.x > SO_TAKEOFF_DISTANCE) {
		soUpTween = new VarTween();
		// use 100 because the hitbox has been adjusted to be 
		// small on the SO so we can't use that.
		soUpTween.tween(SO, "y", -100, SO_TAKEOFF_TIME);
		addTween(soUpTween);
	    }

	}

    }
}