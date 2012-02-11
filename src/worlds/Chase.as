package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import util.Util;

    import flash.geom.Point;

    public class Chase extends World
    {
	[Embed(source="../../assets/levels/Chase.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    player:FlyingPlayer,
	    sO:SO,
	    level:Level,
	    levelHeight:Number = 100000,
	    spawnSectorHeight:Number = 500,
	    spawnedWindTunnels:Boolean = false,
	    spawnedSlowingClouds:Boolean = false;

	public function Chase():void {
	    super();
	    player = new FlyingPlayer();
	    sO = new SO();
	}

	override public function begin():void {
	    super.begin();
	    initLevel();
	}

	private function initLevel():void {
	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.player;
	    for each(var dataElement:XML in dataList) {	    
		player = new FlyingPlayer(int(dataElement.@x), int(dataElement.@y));
	    }
	    add(player);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		sO = new SO(int(dataElement.@x), int(dataElement.@y));
	    }
	    add(sO);
	}

	private function spawnWindTunnels():void {
	    var startingY:Number = player.y;
	    var i:Number = startingY;

	    for (i; i > startingY - levelHeight; i -= spawnSectorHeight) {
		var spawnPoint:Point = randomSpawnPoint(i);
		var windTunnel:WindTunnel = new WindTunnel(spawnPoint.x, 
							   spawnPoint.y);
		add(windTunnel);
	    }
	}

	private function spawnSlowingClouds():void {
	    var startingY:Number = player.y;
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

	    // the world's entity list is only updated after an update loop.
	    // this is a really ugly way to fix this problem. ask online if there's
	    // a better way.
	    if (spawnedWindTunnels && !spawnedSlowingClouds) {
		spawnedSlowingClouds = true;
		spawnSlowingClouds();
	    }
	    if (!spawnedWindTunnels) {
		spawnedWindTunnels = true;
		spawnWindTunnels();
	    }

	    updateCamera();
	}

	private function updateCamera():void {
	    FP.camera.y = player.y - FP.height + player.height;
	}
    }
}