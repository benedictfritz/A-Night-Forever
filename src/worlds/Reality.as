package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import util.Util;

    public class Reality extends World
    {
	[Embed(source="../../assets/levels/Reality.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    player:Player,
	    sO:SO;

	public function Reality():void {
	}

	override public function begin():void {
	    super.begin();
	    FP.screen.scale = 2;

	    var level:Level = new Level(MAP_DATA);
	    add(level);

	    // should only have one couple, but with this code, 
	    // only the last one will get added
	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.player;
	    var dataElement:XML;
	    for each(dataElement in dataList) {	    
		player = new Player(int(dataElement.@x), int(dataElement.@y));
		add(player);
	    }
	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {	    
		sO = new SO(int(dataElement.@x), int(dataElement.@y));
		add(sO);
	    }
	}

	override public function update():void {
	    super.update();
	    updateCamera();
	}

	private function updateCamera():void {
	}
    }
}