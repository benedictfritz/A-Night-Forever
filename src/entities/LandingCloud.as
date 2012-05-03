package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class LandingCloud extends Entity {
	[Embed(source="../../assets/images/cloud.png")]
	    private const LANDING_CLOUD_SPRITE:Class;

	private var
	    sprCloud:Spritemap,
	    hitboxLeeway:Number = 15,
	    destructionCountdown:Number = 3;

	public var
	    doomed:Boolean = false;

	public function LandingCloud(x:int=0, y:int=0, scale:Number=1) {
	    this.x = x;
	    this.y = y;

	    sprCloud = new Spritemap(LANDING_CLOUD_SPRITE, 128, 64);
	    sprCloud.add("default", [0], 1, false);
	    sprCloud.add("burst", [0, 1, 2, 3], 12, false);
	    sprCloud.scale = scale;
	    this.graphic = sprCloud;
	    setHitbox(sprCloud.width*scale - hitboxLeeway*2*scale, 
		      sprCloud.height*scale - hitboxLeeway*2*scale, -hitboxLeeway*scale, - hitboxLeeway*scale);
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
		if (sprCloud.complete) {
		    FP.console.log("Removing");
		    FP.world.remove(this);
		}
	    }
	}
    }

}