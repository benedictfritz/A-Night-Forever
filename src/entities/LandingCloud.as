package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class LandingCloud extends Entity {
	[Embed(source="../../assets/images/cloud_small.png")]
	    private const SMALL_CLOUD_SPRITE:Class;
	[Embed(source="../../assets/images/cloud_med.png")]
	    private const MEDIUM_CLOUD_SPRITE:Class;
	[Embed(source="../../assets/images/cloud_large.png")]
	    private const LARGE_CLOUD_SPRITE:Class;

	private var
	    sprCloud:Spritemap,
	    hitboxLeeway:Number = 15,
	    destructionCountdown:Number = 0.3,
	    vx:Number = -10 - Math.random()*5;

	public var
	    doomed:Boolean = false;

	public function LandingCloud(x:int=0, y:int=0, scale:Number=1) {
	    this.x = x;
	    this.y = y;

	    var size:int = Math.random() * 3;
	    if (size == 0) {
		sprCloud = new Spritemap(SMALL_CLOUD_SPRITE, 128, 64);
		this.vx = FP.scale(scale, 0.6, 1.4, -5, -15);
		setHitbox(sprCloud.width-18, 4, -5, -40);
	    }
	    if (size == 1) {
		sprCloud = new Spritemap(MEDIUM_CLOUD_SPRITE, 192, 96);
		this.vx = FP.scale(scale, 0.6, 1.4, -15, -25);
		setHitbox(sprCloud.width-18, 4, -5, -75);
	    }
	    if (size == 2) {
		sprCloud = new Spritemap(LARGE_CLOUD_SPRITE, 256, 128);
		this.vx = FP.scale(scale, 0.6, 1.4, -30, -50);
		setHitbox(sprCloud.width-18, 4, -5, -90);
	    }

	    sprCloud.add("default", [0], 1, false);
	    sprCloud.add("burst", [0, 1, 2, 3], 12, false);
	    sprCloud.scale = scale;
	    this.graphic = sprCloud;

	    type="landingCloud";
	}

	public function poof():void {
	    sprCloud.play("burst");
	}

	override public function update():void {
	    if (doomed) {
		destructionCountdown -= FP.elapsed
	    }
	    
	    if (doomed && destructionCountdown < 0) {
		sprCloud.play("burst");
		doomed = false;
	    }

	    if (sprCloud.currentAnim == "burst") {
		if (sprCloud.complete) { FP.world.remove(this); }
	    }

	    moveBy(vx*FP.elapsed, 0);
	}
    }

}