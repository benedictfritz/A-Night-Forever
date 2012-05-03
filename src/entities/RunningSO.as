package entities
{
    import flash.utils.*;

    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.tweens.misc.VarTween;

    public class RunningSO extends SO {
	private const 
	    JUMP_SPEED:Number = 230,
	    GRAVITY:Number = 400,
	    // how far the SO looks ahead to see whether or not to jump
	    JUMP_LOOKAHEAD:Number = 64,
	    PLAYER_PICKUP_TIME:Number = 3,
	    PLAYER_BOUNCE_SPEED:Number = 1,
	    TEXT_OFFSET:Number = -25;

	public var
	    running:Boolean = false,
	    spawningMonsters:Boolean = false;

	private var
	    pickingUp:Boolean = false,
	    lifting:Boolean = false,
	    playerY:Number = 0,
	    floatUpTween:VarTween,
	    floatDownTween:VarTween,
	    text:Text,
	    textEntity:Entity,
	    textOptions:Object,
	    spawnTimer:Number = 0,
	    monsterSpawnTime:Number=2;

	public function RunningSO(x:int=0, y:int=0) {
	    super(x, y);

	    // make the SO a little slower than the player so that you can catch up
	    xSpeed -= 10;
	}

	override public function update():void {
	    if (pickingUp || lifting) 
		return;

	    if (spawningMonsters) {
		checkSpawnTimer();
	    }

	    if (running) {
		var jumping:Boolean = collide("level", x, y+1) == null;

		vx = xSpeed;
		sprActor.play("run");

		if (collide("level", x+JUMP_LOOKAHEAD, y) && !jumping) {
		    vy = -JUMP_SPEED;
		}
		if (jumping) {
		    vy > 0 ? sprActor.play("fall") : sprActor.play("jump");
		    vy += GRAVITY * FP.elapsed;
		}

		moveBy(vx * FP.elapsed, vy * FP.elapsed, "level", true);
	    }
	}

	private function checkSpawnTimer():void {
	    spawnTimer += FP.elapsed;
	    if (spawnTimer > monsterSpawnTime) {
		var newMonster:Monster;

		if (FP.random < 0.5) {
		    newMonster = new MonsterFish(x, y);
		}
		else {
		    newMonster = new MonsterMouth(x, y);		    
		}
		
		FP.world.add(newMonster);
		spawnTimer = 0;

		// set random time for next spawn
		monsterSpawnTime = (FP.random * 2) + 2;
	    }
	}

	public function liftPlayer():void {
	    pickingUp = false;
	    lifting = true;
	    bounceUp();
	    
	    textOptions = new Object();
	    textOptions["wordWrap"] = true;
	    textOptions["size"] = 8;
	    text = new Text("Don't give up.", 
			    0, TEXT_OFFSET, textOptions);
	    textEntity = new Entity(this.x, this.y, text);
	    FP.world.add(textEntity);
	}

	public function pickUpPlayer(x:Number, y:Number):void {
	    pickingUp = true;
	    flip(true);
	    sprActor.play("jump");

	    playerY = y;
	    floatLeft(x);
	    floatUp();
	    tiltLeft();
	}

	/******************************
	 * TWEENS
	 ******************************/

	/*
	 * Picking up player float
	 */
	private function floatLeft(endX:Number):void {
	    var floatLeftTween:VarTween = new VarTween(liftPlayer);
	    floatLeftTween.tween(this, "x", endX + this.width, 
				 PLAYER_PICKUP_TIME, Ease.sineInOut);
	    FP.world.addTween(floatLeftTween, true);
	}

	private function floatUp():void {
	    floatUpTween = new VarTween(floatDown);
	    floatUpTween.tween(this, "y", this.y - 40, 
			       PLAYER_PICKUP_TIME/2, Ease.sineInOut);
	    FP.world.addTween(floatUpTween, true);
	}

	private function floatDown():void {
	    floatDownTween = new VarTween();
	    floatDownTween.tween(this, "y", playerY, PLAYER_PICKUP_TIME/2,
				 Ease.sineInOut);
	    FP.world.addTween(floatDownTween, true);
	}

	private function tiltLeft():void {
	    var tiltLeftTween:VarTween = new VarTween(tiltRight);
	    tiltLeftTween.tween(sprActor, "angle", 45, PLAYER_PICKUP_TIME/2);
	    FP.world.addTween(tiltLeftTween, true);
	}

	private function tiltRight():void {
	    var tiltRightTween:VarTween = new VarTween();
	    tiltRightTween.tween(sprActor, "angle", 0, PLAYER_PICKUP_TIME/2);
	    FP.world.addTween(tiltRightTween, true);
	}

	/*
	 * Bounce
	 */
	private function bounceUp():void {
	    var bounceUpTween:VarTween = new VarTween(bounceDown);
	    bounceUpTween.tween(this, "y", this.y - 10, PLAYER_BOUNCE_SPEED);
	    FP.world.addTween(bounceUpTween, true);
	}

	private function bounceDown():void {
	    var bounceDownTween:VarTween = new VarTween(bounceUp);
	    bounceDownTween.tween(this, "y", this.y + 10, PLAYER_BOUNCE_SPEED);
	    FP.world.addTween(bounceDownTween, true);
	}

    }
}