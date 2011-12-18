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
	    couple:Couple;

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

	    // should only have one couple, but with this code, only the last one will get added
	    dataList = levelData.objects.couple;
	    for each(dataElement in dataList) 
	    {	    
		couple = new Couple(int(dataElement.@x), int(dataElement.@y));
		add(couple);
	    }

	    dataList = levelData.objects.star;
	    for each(dataElement in dataList) 
	    {
		var star:Star = new Star(int(dataElement.@x), int(dataElement.@y));
		add(star);
	    }
	}

	override public function update():void {
	    super.update();
	    updateCamera();
	}

	private function updateCamera():void {
	    camera.x = couple.x - FP.halfWidth / FP.screen.scale + (couple.width / 2);
	    camera.y = couple.y - FP.halfHeight / FP.screen.scale + couple.height;
	    
	    if (camera.x < 0) {
		camera.x = 0;
	    }
	    if (camera.y < 0) {
		camera.y = 0;
	    }
	}
    }
}