package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import worlds.*;
    import util.Util;

    public class Intro extends World
    {
	[Embed(source="../../assets/levels/Intro.oel", mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    player:Player;

	public function Intro():void {
	}

	override public function begin():void {
	    super.begin();
	    var level:Level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML;
	    var dataList:XMLList;
	    var dataElement:XML;

	    levelData = level.getLevelData();
	    dataList = levelData.objects.player;

	    // should only have one player, but with this code, only the last one will get added
	    for each(dataElement in dataList) 
	    {	    
		player = new Player(int(dataElement.@x), int(dataElement.@y));
		add(player);
	    }
	}

	override public function update():void {
	    super.update();
	    if (player.x > FP.width / FP.screen.scale) {
		FP.world = new Falling();
	    }
	}
    }
}