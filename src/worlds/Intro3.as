package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;
	
    public class Intro3 extends World {
	[Embed(source="../../assets/levels/Intro3.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static const
	    CAM_X_OFFSET:Number = 64,
	    SO_TAKEOFF_DISTANCE:Number = 300,
	    SO_TAKEOFF_TIME:Number = 3,
	    NUM_CLOUDS:Number = 8;

	private var
	    level:Level,
	    runningPlayer:RunningPlayer,
	    flyingPlayer:FlyingPlayer,
	    runningSO:RunningSO,
	    flyingSO:FlyingSO,
	    skyBackground:SkyBackground,
	    transitionIn:TransitionIn,
	    runningPlayerEntering:Boolean=false,
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
		runningPlayer = new RunningPlayer(int(dataElement.@x), int(dataElement.@y));
		add(runningPlayer);
	    }
	    runningPlayer.setControllable(false);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		runningSO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
		add(runningSO);
	    }

	    for (var i:int = 0; i < NUM_CLOUDS; i++) {
		var randCloudX:Number = Math.random()*(FP.width+FP.halfWidth);
		var randCloudY:Number = Math.random()*(FP.halfHeight);
		add(new VisualCloud(randCloudX, randCloudY, Math.random()*2+1));
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
		if (!runningSO.running) {
		    runningSO.running = true;
		}
	    }

	    if (runningSO.x > 200 && !runningPlayerEntering && runningPlayer.x < CAM_X_OFFSET) {
		runningPlayerEntering = true;
	    }

	    if (runningPlayerEntering) {
		runningPlayer.playRight();
		runningPlayer.x += 2;
	    }

	    if (runningPlayer.x > CAM_X_OFFSET) {
		runningPlayerEntering = false;
		runningPlayer.setControllable(true);
	    }

	    if (runningSO.x > 500) {
		runningSO.running = false;
		runningSO.playFaceLeft();
	    }

	    // TODO: replace distance with distance where runningSO takes off.
	    if (runningPlayer.x > SO_TAKEOFF_DISTANCE && flyingSO == null) {
		// subtract off the hitbox buffers since the creation will account for them again
		flyingSO = new FlyingSO(runningSO.x + runningSO.hitboxXBuffer, runningSO.y - runningSO.hitboxYBuffer);
		flyingSO.flying = false;
		flyingSO.goingLeft = true;
		add(flyingSO);
		remove(runningSO);

		soUpTween = new VarTween();
		// use 100 because the hitbox has been adjusted to be 
		// small on the runningSO so we can't use that. just need to move
		// her offscreen.
		soUpTween.tween(flyingSO, "y", -100, SO_TAKEOFF_TIME);
		addTween(soUpTween);
	    }

	    if (flyingSO != null && flyingPlayer == null) {
		if (Input.check(Key.W)) {
		    // okay, initializing like this is a disaster. basically, the origin on the flying
		    // player is at the feet, so we need to account for that when we init the flying player.
		    // if this ever needs to be changed and you can't figure it out, just switch the running
		    // player to having its origin at its feet.
		    flyingPlayer = new FlyingPlayer(runningPlayer.x + runningPlayer.hitboxXBuffer + 
						    (runningPlayer.width+runningPlayer.hitboxXBuffer*2)/2, 
						    runningPlayer.y - runningPlayer.hitboxYBuffer + runningPlayer.height);
		    add(flyingPlayer);
		    flyingPlayer.xAcceleration = 20;
		    flyingPlayer.yAcceleration = 5;
		    remove(runningPlayer);
		}
	    }

	    if (flyingPlayer != null && flyingPlayer.y < -11) {
		FP.world = new Chase(flyingPlayer.x);
	    }
	}
    }
}