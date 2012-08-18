package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.tweens.sound.SfxFader;

    import entities.*;
    import worlds.Interlude;
    import util.Util;

    import flash.geom.Point;

    public class Chase extends World
    {
	[Embed(source="../../assets/levels/Chase.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_4')]
	    static public const MUSIC:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'scene_5')]
	    static public const INTERLUDE_MUSIC:Class;

	private static var
	    GIVE_UP_BUFFER:Number = 1000;

	private var
	    player:FlyingPlayer,
	    sO:FlyingSO;

	private var
	    startingY:Number,
	    levelHeight:Number = 40000,
	    spawnSectorHeight:Number = 500;

	private var
	    level:Level,
	    skyBackground:SkyBackground,
	    music:Sfx = new Sfx(MUSIC),
	    interludeMusic:Sfx = new Sfx(INTERLUDE_MUSIC);

	private var
	    uncatchable:Boolean = true,
	    uncatchableTimer:Number = 0;
	private static var
	    UNCATCHABLE_TIME:Number = 45;

	private var
	    spawnedWindTunnels:Boolean = false,
	    spawnedSlowingClouds:Boolean = false;
	
	public function Chase(playerX:Number):void {
	    super();
	    player = new FlyingPlayer();
	    player.x = playerX;
	    player.minX = 0;
	    player.maxX = FP.width;
	    player.maxY = player.y;
	    add(player);

	    sO = new FlyingSO();
	}

	override public function begin():void {
	    super.begin();
	    initLevel();

	    var transitionIn:TransitionIn = new TransitionIn(0.1, 0xFFFFFF);
	    add(transitionIn);

	    music.loop();
	}

	private function initLevel():void {
	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.so;
	    dataList = levelData.objects.player;
	    for each(var dataElement:XML in dataList) {
		player.y = int(dataElement.@y);
	    }
	    startingY = player.y;

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		sO = new FlyingSO(int(dataElement.@x), int(dataElement.@y));
	    }
	    sO.minX = 0;
	    sO.maxX = FP.width;
	    add(sO);

	    skyBackground =
		new SkyBackground(0, FP.height, 1,
				  levelHeight/SkyBackground.TILE_HEIGHT);
	    add(skyBackground);
	}

	private function spawnWindTunnels():void {
	    var i:Number = startingY;

	    for (i; i > startingY - levelHeight; i -= spawnSectorHeight) {
		var spawnPoint:Point = randomSpawnPoint(i);
		var windTunnel:WindTunnel = new WindTunnel(spawnPoint.x, 
							   spawnPoint.y);
		add(windTunnel);
	    }
	}

	private function spawnSlowingClouds():void {
	    var i:Number = startingY;
	    for (i; i > startingY - levelHeight; i -= spawnSectorHeight) {
		var slowingCloud:SlowingCloud = spawnIndividualCloud(i);
		var nearestTunnel:WindTunnel = 
		    WindTunnel(this.nearestToEntity("windTunnel", 
						    slowingCloud));
		while (nearestTunnel && 
		       slowingCloud.distanceFrom(nearestTunnel, true) < 50) {
		    slowingCloud = spawnIndividualCloud(i);
		    nearestTunnel = WindTunnel(this.nearestToEntity("windTunnel", 
								    slowingCloud, 
								    true));
		}
		add(slowingCloud);
            }
        }

	private function spawnIndividualCloud(spawnSectorY:Number):SlowingCloud {
	    var spawnPoint:Point = randomSpawnPoint(spawnSectorY);
	    var cloudScale:Number = FP.random*2 + 1;
	    var slowingCloud:SlowingCloud = new SlowingCloud(spawnPoint.x, 
							     spawnPoint.y);
	    return slowingCloud;
	}

	private function randomSpawnPoint(yStart:Number):Point {
	    var x:Number = FP.random * FP.width;
	    var y:Number = yStart + FP.random * spawnSectorHeight;
	    return new Point(x, y);
	}

	override public function update():void {
	    super.update();

	    lameSpawnStuff();
	    updateCamera();
	    checkCatchingPlayer();
	    
	    if (uncatchable) {
		uncatchableTimer += FP.elapsed;
		if (uncatchableTimer > UNCATCHABLE_TIME) { uncatchable = false; }
	    }

	    var chaseDistance:Number = sO.distanceFrom(player, true);
	    if (uncatchable && chaseDistance < 100) { sO.goUncatchable(); }
	    if (chaseDistance < 200) { sO.goFaster(); }
	    else if (chaseDistance > 700) { sO.goSlow(); }
	    else { sO.goFast(); }

	    var stoppingPoint:Number = -Math.abs(startingY - levelHeight);
	    if (sO.y < stoppingPoint && !sO.stopped) {
		sO.stop();
	    }
	}

	private function lameSpawnStuff():void {
	    // the world's entity list is only updated after an update loop.
	    // this is a really ugly way to fix this problem. askonline if there's
	    // a better way.
	    if (spawnedWindTunnels && !spawnedSlowingClouds) {
		spawnedSlowingClouds = true;
		spawnSlowingClouds();
	    }
	    if (!spawnedWindTunnels) {
		spawnedWindTunnels = true;
		spawnWindTunnels();
	    }
	}

	private function updateCamera():void {
	    FP.camera.y = player.y - FP.height + player.height;
	}

	private function checkCatchingPlayer():void {
	    // if the sO has stopped, all the player needs to do is go past
	    // the sO to trigger the next world.
	    // player's origin is at the feet, so we need to subtract off height
	    if (sO.stopped && player.y-player.height <= sO.y) {
		transitionToInterlude();
	    }
	    else if (player.collide("SO", player.x, player.y) != null) {
		transitionToInterlude();
	    }
	}

	private function transitionToInterlude():void {
	    FP.world = new Interlude(player.x, player.y);

	    var crossfade:SfxFader = new SfxFader(music);
	    crossfade.crossFade(interludeMusic, false, 1, 1);
	    FP.tweener.addTween(crossfade);
	}

    }
}