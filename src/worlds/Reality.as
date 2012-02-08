package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import worlds.*;
    import util.Util;

    public class Reality extends World
    {
	[Embed(source="../../assets/levels/Reality.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    player:RunningPlayer,
	    SO:RunningSO,
	    pickingUp:Boolean,
	    level:Level;

	public function Reality():void {
	    super();
	}

	override public function begin():void {
	    super.begin();

	    level = new Level(MAP_DATA);
	    add(level);

	    // should only have one couple, but with this code, 
	    // only the last one will get added
	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.player;
	    var dataElement:XML;
	    for each(dataElement in dataList) {	    
		player = new RunningPlayer(int(dataElement.@x), int(dataElement.@y));
		add(player);
	    }
	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {	    
		SO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
		add(SO);
	    }
	}

	override public function update():void {
	    super.update();

	    if (pickingUp) {
		return;
	    }
	    
	    if (player.x < FP.camera.x) {
		// have so come back and pick player up
		SO.pickUpPlayer(player.x, player.y);
		pickingUp = true;
	    }
	    else {
		FP.camera.x = SO.x - FP.width + SO.width;
	    }
	}
    }
}