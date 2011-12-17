package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import util.Util;

    public class Falling extends World
    {
	[Embed(source="../../assets/levels/Falling.oel", mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private const
	    FALLING_GRAVITY:Number = 0.1;

	private var
	    player:Player;

	public function Falling():void {
	    Util.addCenteredText("World One", this, 5, 1);
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
	    player.setGravity(FALLING_GRAVITY);
	}

	override public function update():void {
	    super.update();
	    updateCamera();
	}

	private function updateCamera():void {
	    camera.x = player.x - FP.halfWidth / FP.screen.scale + (player.width / 2);
	    camera.y = player.y - FP.halfHeight / FP.screen.scale + player.height;
	    
	    if (camera.x < 0) {
		camera.x = 0;
	    }
	    if (camera.y < 0) {
		camera.y = 0;
	    }
	}
    }
}