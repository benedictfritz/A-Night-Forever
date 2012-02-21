package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.tweens.misc.VarTween;

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
	    skyBackground:SkyBackground,
	    flyingToClouds:Boolean,
	    xTween:VarTween,
	    yTween:VarTween,
	    cloudHeight:Number;

	public function Interlude(playerX:Number, playerY:Number):void {
	    super();

	    // set couple's height based on the parsing of the ogmo data
	    couple = new Couple(playerX, 0);
	    couple.controllable = false;
	    add(couple);

	    flyingToClouds = true;
	}

	override public function begin():void {
	    super.begin();
	    initLevel();
	}

	private function initLevel():void {
	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();

	    // eventually we will have one single entity for the cloud layer
	    // which will make this assignment of cloudHeight less strange/confusing
	    var dataList:XMLList = levelData.objects.cloud;
	    var dataElement:XML;
	    for each(dataElement in dataList) {
		var newCloud:SlowingCloud = new SlowingCloud(int(dataElement.@x), 
							     int(dataElement.@y));
		add(newCloud);
		cloudHeight = int(dataElement.@y);
	    }

	    // the couple in the ogmo file is used only for height positioning.
	    // the x-position is fed in from the previous world
	    dataList = levelData.objects.couple;
	    for each(dataElement in dataList) {
		couple.y = dataElement.@y;
	    }

	    skyBackground = new SkyBackground(couple.y + couple.height, level.height);
	    add(skyBackground);

	    var transitionIn:TransitionIn = new TransitionIn(0.1, 0xFFFFFF);
	    add(transitionIn);
	}

	override public function update():void {
	    super.update();
	    updateCamera();

	    if (flyingToClouds) { toCloudsUpdate();  }
	}

	private function toCloudsUpdate():void {
	    if (!xTween) {
		xTween = new VarTween();
		var centerX:Number = FP.halfWidth - couple.width/2;
		xTween.tween(couple, "x", centerX, 2, Ease.sineInOut);
		FP.world.addTween(xTween);
	    }
	    if (!yTween) {
		yTween = new VarTween();
		yTween.tween(couple, "y", cloudHeight, 5);
		FP.world.addTween(yTween);
	    }
	}

	private function updateCamera():void {
	    FP.camera.y = couple.y - FP.height + couple.height;
	}

    }
}