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

	private static const
	    TO_CLOUD_TIME:Number = 2,
	    HALF_ARC_TIME:Number = 2;

	private var
	    couple:Couple,
	    level:Level,
	    skyBackground:SkyBackground,
	    flyingToClouds:Boolean,
	    xTween:VarTween,
	    yTween:VarTween,
	    camXTween:VarTween,
	    camYTween:VarTween,
	    cloudHeight:Number,
	    camFollowCouple:Boolean = false;

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

	    var transitionIn:TransitionIn = new TransitionIn(0.1, 0xFFFFFF);
	    add(transitionIn);
	}

	private function initLevel():void {
	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();

	    // eventually we will have one single entity for the cloud layer
	    // which will make this assignment of cloudHeight less strange/confusing
	    var dataList:XMLList = levelData.objects.cloudLayer3;
	    var dataElement:XML;
	    dataList = levelData.objects.cloudLayer3;
	    for each(dataElement in dataList) {
		var newCloud:CloudLayer = new CloudLayer(int(dataElement.@x), 
							 int(dataElement.@y), 3);
	    	add(newCloud);
	    }

	    dataList = levelData.objects.cloudLayer2;
	    for each(dataElement in dataList) {
		newCloud = new CloudLayer(int(dataElement.@x), 
					  int(dataElement.@y), 2);
	    	add(newCloud);
	    }

	    dataList = levelData.objects.cloudLayer1;
	    for each(dataElement in dataList) {
	    	newCloud = new CloudLayer(int(dataElement.@x), 
							 int(dataElement.@y), 1);
	    	add(newCloud);
	    	cloudHeight = int(dataElement.@y);
	    }

	    // the couple in the ogmo file is used only for height positioning.
	    // the x-position is fed in from the previous world
	    dataList = levelData.objects.couple;
	    for each(dataElement in dataList) {
		couple.y = dataElement.@y;
	    }

	    FP.camera.y = couple.y - FP.height + couple.height;

	    skyBackground = new SkyBackground(couple.y + couple.height, 
					      level.height);
	    add(skyBackground);
	}

	override public function update():void {
	    super.update();

	    if (flyingToClouds) { toCloudsUpdate();  }
	    if (camFollowCouple) { updateCamera(); }
	}

	private function toCloudsUpdate():void {
	    if (!yTween) {
		yTween = new VarTween(coupleUpArc);
		yTween.tween(couple, "y", cloudHeight, TO_CLOUD_TIME);
		FP.world.addTween(yTween);
	    }
	    if (!camYTween) {
		camYTween = new VarTween();
		// TODO: Change 32, the temporary thickness of the cloud layer,
		// to be related to an actual entity
		var camY:Number = cloudHeight + 32 - FP.height;
		camYTween.tween(FP.camera, "y", camY, TO_CLOUD_TIME);
		FP.world.addTween(camYTween);
	    }
	    if (!camXTween) {
		camXTween = new VarTween();
		var camX:Number = couple.x - FP.halfWidth + couple.width/2;
		camXTween.tween(FP.camera, "x", camX, TO_CLOUD_TIME);
		FP.world.addTween(camXTween);
	    }
	}

	private function coupleUpArc():void {
	    camFollowCouple = true;

	    yTween = new VarTween(coupleDownArc);
	    var yPeak:Number = couple.y - FP.halfHeight;
	    yTween.tween(couple, "y", yPeak, HALF_ARC_TIME, Ease.quadOut);
	    FP.world.addTween(yTween);

	    xTween = new VarTween();
	    var xPeak:Number = couple.x + FP.halfWidth - couple.width/2;
	    xTween.tween(couple, "x", xPeak, HALF_ARC_TIME);
	    FP.world.addTween(xTween);
	}

	private function coupleDownArc():void {
	    yTween = new VarTween(goToFallingWorld);
	    var yBottom:Number = couple.y + FP.halfHeight;
	    yTween.tween(couple, "y", yBottom, HALF_ARC_TIME, Ease.quadIn);
	    FP.world.addTween(yTween);

	    xTween = new VarTween();
	    var xBottom:Number = couple.x + FP.halfWidth - couple.width/2;
	    xTween.tween(couple, "x", xBottom, HALF_ARC_TIME);
	    FP.world.addTween(xTween);		
	}

	private function goToFallingWorld():void {
	    FP.world = new Falling();
	}

	private function updateCamera():void {
	    camera.x = couple.x - FP.halfWidth + (couple.width / 2);
	}

    }
}