package worlds
{
    import net.flashpunk.World;
    import net.flashpunk.FP;

    import entities.*;
	
    public class Intro2 extends World {
	[Embed(source="../../assets/levels/Intro2.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    level:Level,
	    player:RunningPlayer,
	    SO:RunningSO,
	    crowd:Crowd;

	override public function begin():void {
	    super.begin();

	    // start off one tile to the right so we can spawn things off 
	    // the screen and they can run in.
	    FP.camera.x = 64;

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

	    dataList = levelData.objects.crowd;
	    for each(dataElement in dataList) {
		crowd = new Crowd(int(dataElement.@x), int(dataElement.@y));
		add(crowd);
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