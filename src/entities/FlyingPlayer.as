package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    import entities.*;

    public class FlyingPlayer extends Player {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const PLAYER_SPRITE:Class;

	public var
	    upperBarrier:WindBarrier,
	    lowerBarrier:WindBarrier;

	private var
	    acceleration:Number = 20,
	    friction:Number = 0.05,
	    bounceBuffer:Number = 0.1,
	    windBoost:Number = 60;

	public function FlyingPlayer(x:int=0, y:int=0) {
	    super(x, y);
	}

	override public function update():void {
	    super.update();
	    if (controllable) { checkKeyPresses(); }
	    checkWindBarriers();
	    checkWindTunnels();
	    checkSlowingClouds();
	    move();
	}

	private function checkKeyPresses():void {
	    if (Input.check(Key.D)) { vx += acceleration; }
	    else if (Input.check(Key.A)) { vx -= acceleration; }
	    vx -= vx*friction;

	    if (Input.check(Key.S)) { vy += acceleration; }
	    else if (Input.check(Key.W)) { vy -= acceleration; }
	    vy -= vy*friction;
	}

	private function checkWindBarriers():void {
	    var distanceToBarrier:Number = upperBarrier.distanceToLocation(x, y);
	    if (distanceToBarrier < 10) {
		if (vy < 0) { vy = -vy * (bounceBuffer * distanceToBarrier); }
		if (vx < 0) { vx = -vx * (bounceBuffer * distanceToBarrier); }
	    }

	    distanceToBarrier = lowerBarrier.distanceToLocation(x, y);
	    if (distanceToBarrier < 10) {
		if (vy > 0) { vy = -vy * (bounceBuffer * distanceToBarrier); }
		if (vx > 0) { vx = -vx * (bounceBuffer * distanceToBarrier); }
	    }
	}

	private function checkWindTunnels():void {
	    var boost:Boolean = collide("windTunnel", x, y) != null;
	    if (boost) {
		vx += windBoost;
		vy -= windBoost;
	    }
	}

	private function checkSlowingClouds():void {
	    var cloud:SlowingCloud = collide("slowingCloud", x, y) as SlowingCloud;
	    if (cloud) {
		var slowingVelocity:Number = cloud.slowingVelocity;
		vx -= FP.sign(vx)*slowingVelocity;
		vy -= FP.sign(vy)*slowingVelocity;
		cloud.poof();
	    }
	}

	private function move():void {
	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}
    }
}