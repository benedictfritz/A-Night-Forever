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
	[Embed(source = '../../assets/images/couple.png')]
	    private const COUPLE_SPRITE:Class;

	public var
	    yAcceleration:Number = 20,
	    xAcceleration:Number = 80,
	    minX:Number,
	    maxX:Number,
	    maxY:Number;

	private var
	    xFriction:Number = 0.1,
	    yFriction:Number = 0.04,
	    windBoost:Number = 12;

	public function FlyingPlayer(x:int=0, y:int=0) {
	    super(x, y);

	    sprActor = new Spritemap(COUPLE_SPRITE, 96, 96);
	    sprActor.add("slow", [0, 1], 8, true);
	    sprActor.add("fast", [0, 1], 16, true);
	    sprActor.play("slow");

	    graphic = sprActor;

	    var hitboxWidth:Number = sprActor.width - hitboxYBuffer*2;
	    var hitboxHeight:Number = sprActor.height - hitboxYBuffer;
	    // need to center origin on bottom of hitbox so we can do rotations 
	    // on graphic that feel as if you're directing the head in the 
	    // direction you want to go.
	    sprActor.centerOO();
	    sprActor.originY += hitboxHeight/2;
	    setHitbox(hitboxWidth, hitboxHeight, hitboxWidth/2, hitboxHeight);
	}

	override public function update():void {
	    super.update();
	    if (controllable) { checkKeyPresses(); }
	    checkWindTunnels();
	    checkSlowingClouds();
	    adjustHair();
	    move();
	}

	private function checkKeyPresses():void {
	    if (Input.check(Key.RIGHT)) { vx += xAcceleration; }
	    else if (Input.check(Key.LEFT)) { vx -= xAcceleration; }
	    vx -= vx * xFriction;
	    if(vx != 0) { vx < 0 ? flip(true) : flip(false); }

	    if (Input.check(Key.DOWN)) { vy += yAcceleration; }
	    else if (Input.check(Key.UP)) { vy -= yAcceleration; }
	    vy -= vy*yFriction;
	    if (vy > 0) { vy = 0; }
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

	private function adjustHair():void {
	    if (vy > -500) { sprActor.play("slow"); }
	    else { sprActor.play("fast"); }
	}

	private function move():void {
	    moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);

	    // rotate the player's head in the direction they want to go
	    var scaledVx:Number = FP.scale(Math.abs(vx), 0, 720, 0, 10);
	    FP.console.log(scaledVx);
	    sprActor.angle = -FP.sign(vx) * scaledVx;

	    // constrain player within limits
	    if (left < minX) { x = minX + originX; }
	    if (right > maxX) { x = maxX + originX - width; }
	}
    }
}