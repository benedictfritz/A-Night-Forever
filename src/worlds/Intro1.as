package worlds
{
    import net.flashpunk.World;
    import net.flashpunk.FP;
    
    import entities.*;
	
    public class Intro1 extends World {
	[Embed(source="../../assets/levels/Intro1.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    level:Level,
	    player:RunningPlayer,
	    SO:RunningSO;

	override public function begin():void {
	    super.begin();

	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();

	    var dataElement:XML;
	    var dataList:XMLList = levelData.objects.player;
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
	    if (player.x > FP.width) {
		FP.world = new Intro2();
	    }
	}

    }
}