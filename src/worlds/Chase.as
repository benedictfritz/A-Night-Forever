package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.utils.Draw;

    import entities.*;
    import util.Util;

    public class Chase extends World
    {
	[Embed(source="../../assets/levels/Chase.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    player:FlyingPlayer,
	    sO:SO,
	    level:Level,
	    lowerBarrier:WindBarrier,
	    upperBarrier:WindBarrier;

	public function Chase():void {
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

	    dataList = levelData.objects.windBarrier;
	    for each(dataElement in dataList) {
	        if (!lowerBarrier) {
		    lowerBarrier = new WindBarrier(int(dataElement.@x), 
						   int(dataElement.@y));
		    add(lowerBarrier);
		    player.lowerBarrier = lowerBarrier;
		}
		else {
		    upperBarrier = new WindBarrier(int(dataElement.@x), 
						   int(dataElement.@y));
		    add(upperBarrier);
		    player.upperBarrier = upperBarrier;
		}
	    }
	    add(sO);
	}

	override public function update():void {
	    super.update();
	    FP.camera.x = player.x - FP.halfWidth;
	    FP.camera.y = player.y - FP.halfWidth;

	    var distanceToUpper:Number = 
		upperBarrier.distanceToLocation(player.x, player.y);
	    var distanceToLower:Number = 
	    	lowerBarrier.distanceToLocation(player.x, player.y);
	}
    }
}