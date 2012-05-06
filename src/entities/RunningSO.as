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

    import entities.*;
    import worlds.*;

    public class RunningSO extends SO {
	private const 
	    JUMP_SPEED:Number = 230,
	    GRAVITY:Number = 400,
	    // how far the SO looks ahead to see whether or not to jump
	    JUMP_LOOKAHEAD:Number = 64,
	    PLAYER_PICKUP_TIME:Number = 4,
	    PLAYER_BOUNCE_SPEED:Number = 1,
	    TEXT_OFFSET:Number = -25,
	    TOUCHDOWN_DISTANCE:Number = 96,
	    RETURN_DISTANCE:Number = 400;

	public var
	    running:Boolean = false,
	    spawningMonsters:Boolean = false;

	private var
	    flyingBackToPlayer:Boolean = false,
	    flyingAwayFromPlayer:Boolean = false,
	    playerY:Number = 0,
	    floatUpTween:VarTween,
	    floatDownTween:VarTween,
	    text:Text,
	    textEntity:Entity,
	    textOptions:Object,
	    spawnTimer:Number = 0,
	    monsterSpawnTime:Number=2,
	    player:RunningPlayer;

	public function RunningSO(x:int=0, y:int=0) {
	    super(x, y);

	    // make the SO a little slower than the player so that you can catch up
	    xSpeed -= 10;
	}

	override public function update():void {
	    if (flyingBackToPlayer) {
		sprActor.play("jump");
		flip(true);
		return;
	    }
	    else if (flyingAwayFromPlayer) {
		sprActor.play("jump");
		flip(false);
		return;
	    }

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

	public function pickUpPlayer(fallenPlayer:RunningPlayer):void {
	    this.player = fallenPlayer;
	    flyingBackToPlayer = true;

	    playerY = this.player.y - TOUCHDOWN_DISTANCE;
	    floatLeftToPlayer(this.player.x+40);
	    floatUpToPlayer();
	    tiltLeft();
	}

	/******************************
	 * TWEENS
	 ******************************/

	/*
	 * Picking up player float
	 */
	private function floatLeftToPlayer(endX:Number):void {
	    var floatLeftTween:VarTween = new VarTween();
	    floatLeftTween.tween(this, "x", endX + this.width, 
				 PLAYER_PICKUP_TIME, Ease.sineInOut);
	    FP.world.addTween(floatLeftTween, true);
	}

	private function floatUpToPlayer():void {
	    floatUpTween = new VarTween(floatDownToPlayer);
	    var distanceToTopOfScreen:Number = Math.abs(this.y - FP.camera.y);
	    floatUpTween.tween(this, "y", this.y - distanceToTopOfScreen + 60, 
			       PLAYER_PICKUP_TIME/2, Ease.sineInOut);
	    FP.world.addTween(floatUpTween, true);
	}

	private function floatDownToPlayer():void {
	    floatDownTween = new VarTween(touchDown);
	    floatDownTween.tween(this, "y", playerY, PLAYER_PICKUP_TIME/2,
				 Ease.sineInOut);
	    FP.world.addTween(floatDownTween, true);
	}

	private function tiltLeft():void {
	    var tiltLeftTween:VarTween = new VarTween(tiltUpRight);
	    tiltLeftTween.tween(sprActor, "angle", 45, PLAYER_PICKUP_TIME/2);
	    FP.world.addTween(tiltLeftTween, true);
	}

	private function tiltUpRight():void {
	    var tiltRightTween:VarTween = new VarTween();
	    tiltRightTween.tween(sprActor, "angle", 0, PLAYER_PICKUP_TIME/2);
	    FP.world.addTween(tiltRightTween, true);
	}

	private function touchDown():void {
	    var touchdownTween:VarTween = new VarTween(liftPlayer);
	    touchdownTween.tween(this, "y", this.y + TOUCHDOWN_DISTANCE, 2);
	    FP.world.addTween(touchdownTween, true);
	}

	private function liftPlayer():void {
	    flyingBackToPlayer = false;
	    flyingAwayFromPlayer = true;
	    
	    // adjust player state
	    this.player.fallen = false;
	    this.player.pickingUp = true;
	    this.player.liftUp();
	    
	    floatRightAwayFromPlayer();
	    floatUpAwayFromPlayer();
	}

	/*
	 * flying back after picking up player
	 */
	private function floatRightAwayFromPlayer():void {
	    var floatRight:VarTween = new VarTween(resumeRunning);
	    floatRight.tween(this, "x", 
			     this.x + RETURN_DISTANCE, 
			     PLAYER_PICKUP_TIME);
	    FP.world.addTween(floatRight);
	}

	private function floatUpAwayFromPlayer():void {
	    var endX:Number = this.x + RETURN_DISTANCE;
	    // adjust where we're checking to return the SO to account for the
	    // difference between hitbox and position
	    var endY:Number = Reality(FP.world).firstSolidGroundY(endX+hitboxXBuffer) - this.height;

	    var floatUp:VarTween = new VarTween();
	    floatUp.tween(this, "y", endY, PLAYER_PICKUP_TIME);
	    FP.world.addTween(floatUp);
	}

	private function resumeRunning():void {
	    this.player.pickingUp = false;
	    this.player.setControllable(true);
	    
	    flyingAwayFromPlayer = false;
	    running = true;
	    spawningMonsters = true;

	    Reality(FP.world).pickingUp = false;
	}

    }
}