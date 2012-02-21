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

    public class Interlude extends World
    {
	[Embed(source="../../assets/levels/Interlude.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private var
	    couple:Couple,
	    level:Level,
	    skyBackground:SkyBackground;

	public function Interlude(playerX:Number, playerY:Number):void {
	    super();
	    couple = new Couple(playerX, playerY);
	    couple.controllable = false;
	    add(couple);
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
	}

	override public function update():void {
	    super.update();
	    updateCamera();
	}

	private function updateCamera():void {
	    FP.camera.y = couple.y - FP.height + couple.height;
	}

    }
}