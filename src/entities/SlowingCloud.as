package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class SlowingCloud extends Entity {
	[Embed(source="../../assets/images/cloud_small.png")]
	    private const SMALL_CLOUD_SPRITE:Class;
	[Embed(source="../../assets/images/cloud_med.png")]
	    private const MEDIUM_CLOUD_SPRITE:Class;
	[Embed(source="../../assets/images/cloud_large.png")]
	    private const LARGE_CLOUD_SPRITE:Class;

	private var
	    sprCloud:Spritemap,
	    hitboxLeeway:Number = 15,
	    vx:Number = -30 - Math.random()*30;

	public var
	    slowingVelocity:Number = 15;

	public function SlowingCloud(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    var size:int = Math.random() * 3;
	    FP.console.log(size);
	    if (size == 0) {
		sprCloud = new Spritemap(SMALL_CLOUD_SPRITE, 128, 64);
	    }
	    if (size == 1) {
		sprCloud = new Spritemap(MEDIUM_CLOUD_SPRITE, 192, 96);
	    }
	    if (size == 2) {
		sprCloud = new Spritemap(LARGE_CLOUD_SPRITE, 256, 128);
	    }

	    sprCloud.add("default", [0], 1, false);
	    sprCloud.add("burst", [0, 1, 2, 3], 12, false);
	    this.graphic = sprCloud;

	    var scale:Number = Math.random()*0.8+0.6;
	    sprCloud.scale = scale;
	    setHitbox(sprCloud.width*scale - hitboxLeeway*2*scale, 
	    	      sprCloud.height*scale - hitboxLeeway*2*scale, 
	    	      -hitboxLeeway*scale, - hitboxLeeway*scale);
	    type="slowingCloud";
	}

	public function poof():void {
	    sprCloud.play("burst");
	}

	override public function update():void {
	    moveBy(vx*FP.elapsed, 0);

	    if ((right+width/5) < FP.camera.x) {
		x = FP.camera.x + FP.width + width/5;
	    }

	    if (sprCloud.currentAnim == "burst") {
		if (sprCloud.complete) FP.world.remove(this);
	    }
	    if (y > FP.camera.y + FP.height*2) {
		FP.world.recycle(this);
	    }
	}
    }

}