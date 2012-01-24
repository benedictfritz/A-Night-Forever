package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import util.Util;

    public class Chase extends World
    {
	[Embed(source="../../assets/levels/Chase.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    player:Player,
	    sO:SO,
	    level:Level;

	public function Chase():void {
	    player = new Player();
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
		player = new Player(int(dataElement.@x), int(dataElement.@y));
	    }
	    add(player);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		sO = new SO(int(dataElement.@x), int(dataElement.@y));
	    }
	    add(sO);
	}

	override public function update():void {
	    super.update();
	    FP.camera.x = player.x - FP.halfWidth;
	    FP.camera.y = player.y - FP.halfWidth;
	}
    }
}