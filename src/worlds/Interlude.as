package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;
    import util.Util;

    import flash.geom.Point;

    public class Interlude extends World
    {
	[Embed(source = '../../assets/images/moon.png')]
	    private const MOON_IMAGE:Class;

	private static const
	    LEVEL_WIDTH:Number = 1600,
	    LEVEL_HEIGHT:Number = 1600,
	    TO_CLOUD_TIME:Number = 2,
	    HALF_ARC_TIME:Number = 2,
	    CLOUD_Y:Number = -1024;

	private var
	    couple:Couple,
	    skyBackground:SkyBackground,
	    flyingToClouds:Boolean,
	    moon:Image,
	    xTween:VarTween,
	    yTween:VarTween,
	    camXTween:VarTween,
	    camYTween:VarTween,
	    camFollowCouple:Boolean = false,
	    arcRadius:Number;

	public function Interlude(playerX:Number, playerY:Number):void {
	    super();

	    // set couple's height based on the parsing of the ogmo data
	    couple = new Couple(playerX, 0);
	    couple.controllable = false;
	    add(couple);

	    arcRadius = FP.halfWidth - couple.width/2;

	    flyingToClouds = true;
	}

	override public function begin():void {
	    super.begin();
	    initLevel();

	    var transitionIn:TransitionIn = new TransitionIn(0.1, 0xFFFFFF);
	    add(transitionIn);
	}

	private function initLevel():void {
	    FP.camera.y = couple.y - FP.height + couple.height;

	    for (var i:Number=-FP.width; i < FP.width*2; i+=256) {
		var newCloudLayer1:CloudLayer = new CloudLayer(i, CLOUD_Y, 1);
		add(newCloudLayer1);
		var newCloudLayer2:CloudLayer = new CloudLayer(i, CLOUD_Y-32, 2);
		add(newCloudLayer2);
		var newCloudLayer3:CloudLayer = new CloudLayer(i, CLOUD_Y-64, 3);
		add(newCloudLayer3);
	    }

	    moon = new Image(MOON_IMAGE);
	    moon.scrollX = 0.2;

	    skyBackground = new SkyBackground(-FP.halfWidth, FP.height, 4, 4);
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
		yTween.tween(couple, "y", CLOUD_Y, TO_CLOUD_TIME);
		FP.world.addTween(yTween);
	    }
	    if (!camYTween) {
		camYTween = new VarTween();
		// TODO: Change 32, the temporary thickness of the cloud layer,
		// to be related to an actual entity
		var camY:Number = CLOUD_Y + 32 - FP.height;
		camYTween.tween(FP.camera, "y", camY, TO_CLOUD_TIME);
		FP.world.addTween(camYTween);
	    }
	    if (!camXTween) {
		camXTween = new VarTween();
		
		var camCenterX:Number = couple.x + couple.width/2 - FP.halfWidth;

		// this is weird centering math for the moon, but it's not really
		// right because of the scrollX on the moon.
		var cameraDelta:Number = FP.camera.x - camCenterX - arcRadius + couple.width/2;
		var moonScrollXAdjust:Number = cameraDelta * (1-moon.scrollX);
		var moonX:Number = couple.x + arcRadius - FP.halfWidth;

		addGraphic(moon, 3, moonX + moonScrollXAdjust, CLOUD_Y-moon.height);
		FP.console.log(cameraDelta);

		camXTween.tween(FP.camera, "x", camCenterX, TO_CLOUD_TIME);
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
	    var xPeak:Number = couple.x + arcRadius;
	    xTween.tween(couple, "x", xPeak, HALF_ARC_TIME);
	    FP.world.addTween(xTween);
	}

	private function coupleDownArc():void {
	    yTween = new VarTween(goToFallingWorld);
	    var yBottom:Number = couple.y + FP.halfHeight;
	    yTween.tween(couple, "y", yBottom, HALF_ARC_TIME, Ease.quadIn);
	    FP.world.addTween(yTween);

	    xTween = new VarTween();
	    var xBottom:Number = couple.x + arcRadius;
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