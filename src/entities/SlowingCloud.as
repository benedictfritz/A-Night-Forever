package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class SlowingCloud extends Entity {
	[Embed(source="../../assets/images/cloud.png")]
	    private const SLOWING_CLOUD_SPRITE:Class;

	private var
	    sprCloud:Spritemap,
	    hitboxLeeway:Number = 15;

	public var
	    slowingVelocity:Number = 15;

	public function SlowingCloud(x:int=0, y:int=0, scale:Number=1) {
	    this.x = x;
	    this.y = y;

	    sprCloud = new Spritemap(SLOWING_CLOUD_SPRITE, 128, 64);
	    sprCloud.add("default", [0], 1, false);
	    sprCloud.add("burst", [0, 1, 2, 3], 12, false);
	    sprCloud.scale = scale;
	    this.graphic = sprCloud;
	    setHitbox(sprCloud.width*scale - hitboxLeeway*2*scale, 
		      sprCloud.height*scale - hitboxLeeway*2*scale, -hitboxLeeway*scale, - hitboxLeeway*scale);
	    type="slowingCloud";
	}

	public function poof():void {
	    sprCloud.play("burst");
	}

	override public function update():void {
	    if (sprCloud.currentAnim == "burst") {
		if (sprCloud.complete) FP.world.remove(this);
	    }
	}
    }

}