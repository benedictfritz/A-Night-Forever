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
	    yAcceleration:Number = 20,
	    xAcceleration:Number = 80,
	    xFriction:Number = 0.1,
	    yFriction:Number = 0.04,
	    windBoost:Number = 12;

	public function FlyingPlayer(x:int=0, y:int=0) {
	    super(x, y);
	}

	override public function update():void {
	    super.update();
	    if (controllable) { checkKeyPresses(); }
	    checkWindTunnels();
	    checkSlowingClouds();
	    move();
	}

	private function checkKeyPresses():void {
	    if (Input.check(Key.D)) { vx += xAcceleration; }
	    else if (Input.check(Key.A)) { vx -= xAcceleration; }
	    vx -= vx*xFriction;

	    if (Input.check(Key.S)) { vy += yAcceleration; }
	    else if (Input.check(Key.W)) { vy -= yAcceleration; }
	    vy -= vy*yFriction;
	}

	private function checkWindTunnels():void {
	    var boost:Boolean = collide("windTunnel", x, y) != null;
	    if (boost) {
		vy *= 1.1;
	    }
	}

	private function checkSlowingClouds():void {
	    var cloud:SlowingCloud = collide("slowingCloud", x, y) as SlowingCloud;
	    if (cloud) {
		var slowingVelocity:Number = cloud.slowingVelocity;
		vx *= 0.95;
		vy *= 0.95;
		cloud.poof();
	    }
	}

	private function move():void {
	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	}
    }
}