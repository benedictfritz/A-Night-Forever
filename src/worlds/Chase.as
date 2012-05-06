package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import worlds.Interlude;
    import util.Util;

    import flash.geom.Point;

    public class Chase extends World
    {
	[Embed(source="../../assets/levels/Chase.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static var
	    GIVE_UP_BUFFER:Number = 1000;

	private var
	    player:FlyingPlayer,
	    sO:FlyingSO,
	    startingY:Number,
	    level:Level,
	    levelHeight:Number = 100000,
	    spawnSectorHeight:Number = 500,
	    spawnedWindTunnels:Boolean = false,
	    spawnedSlowingClouds:Boolean = false,
	    skyBackground:SkyBackground;

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

	    skyBackground = new SkyBackground(0, FP.height, 1, levelHeight/SkyBackground.TILE_HEIGHT);
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
							     spawnPoint.y, 
							     cloudScale);
	    return slowingCloud;
	}

	private function randomSpawnPoint(yStart:Number):Point {
	    var x:Number = (FP.random * FP.width) - 50;
	    var y:Number = yStart + FP.random * spawnSectorHeight;
	    return new Point(x, y);
	}

	override public function update():void {
	    super.update();

	    lameSpawnStuff();
	    updateCamera();
	    checkCatchingPlayer();
	    
	    if (sO.distanceFrom(player, true) > 700) { sO.goSlow(); }
	    else { sO.goFast(); }

	    var stoppingPoint:Number = -Math.abs(startingY - levelHeight);
	    if (sO.y < stoppingPoint) {
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
	    // player's origin is at the feet, so we need to subtract off height
	    if (player.y-player.height <= sO.y) {
		FP.world = new Interlude(player.x, player.y);
	    }
	}

    }
}