package worlds
{
    import flash.geom.Point;
    import flash.utils.*;
    
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import worlds.*;
    import util.Util;

    public class Intro extends World
    {
	[Embed(source="../../assets/levels/Intro.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static const
	    PLAYER_VAL:String = "player",
	    SO_VAL:String = "so";

	private var
	    textFadeRate:Number = 0.5,
	    cameraPanRate:Number = 140,
	    textBubbleHeight:Number = 460,
	    conversationOffset:Number = 600;

	private var 
	    inMenu:Boolean=true,
	    sweepingCam:Boolean=false,
	    inConversation:Boolean=false;

	private var
	    titleTextEntity:Entity,
	    instructionTextEntity:Entity;

	private var
	    player:RunningPlayer,
	    sO:SO,
	    level:Level;

	private var
	    adjustingPositions:Boolean,
	    playerTextBubble:Entity,
	    sOTextBubble:Entity,
	    conversation:Array,
	    textOptions:Object;

	public function Intro():void {
	    player = new RunningPlayer();
	    sO = new SO();
	    conversation = new Array();
	    adjustingPositions = false;

	    playerTextBubble = new Entity();
	    add(playerTextBubble);
	    playerTextBubble.visible = false;

	    sOTextBubble = new Entity();
	    add(sOTextBubble);
	    sOTextBubble.visible = false;
	}

	override public function begin():void {
	    super.begin();

	    initLevel();
	    initConversation();
	    initMenu();
	}

	/*
	 * update functions
	 */

	override public function update():void {
	    super.update();

	    if (inMenu) { menuUpdate(); }
	    if (sweepingCam) { camUpdate(); }
	    if (inConversation) { conversationUpdate(); }
	}

	private function menuUpdate():void {
	    if (Input.pressed(Key.X)) {
		endMenu();
		startCameraSweep();
	    }
	}

	private function camUpdate():void {
	    Text(titleTextEntity.graphic).alpha -= textFadeRate * FP.elapsed;
	    Text(instructionTextEntity.graphic).alpha -= textFadeRate * FP.elapsed;

	    if (Text(titleTextEntity.graphic).alpha <= 0.8) {
		this.camera.x += cameraPanRate * FP.elapsed;
		if (this.camera.x > FP.halfWidth) {
		    endCameraSweep();
		    startConversation();
		}
	    }
	}

	private function conversationUpdate():void {
	    if (adjustingPositions) {
		if (player.isAdjusting) { adjustActor(player, playerTextBubble); }
		if (sO.isAdjusting) { adjustActor(sO, sOTextBubble); }

		if (!player.isAdjusting && !sO.isAdjusting) {
		    adjustingPositions = false;
		}
	    }
	    
	    if (Input.pressed(Key.X) && !adjustingPositions) {
		conversation.pop()();
	    }

	    if (player.x > level.width) {
		endConversation();
	    }
	}


	/*
	 * starts
	 */

	private function startCameraSweep():void {
	    sweepingCam = true;
	}


	private function startConversation():void {
	    inConversation = true;
	    conversation.pop()();
	}

	/*
	 * ends
	 */

	private function endMenu():void {
	    inMenu = false;
	}

	private function endCameraSweep():void {
	    remove(titleTextEntity);
	    remove(instructionTextEntity);
	    sweepingCam = false;
	}

	private function endConversation():void {
	    var transition:TransitionOut = new TransitionOut(new Falling());
	    FP.world.add(transition);
	}

	/*
	 * inits
	 */
	
	private function initLevel():void {
	    level = new Level(MAP_DATA);
	    add(level);

	    // should only have one player and so, but with this code
	    // only the last one will get added
	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.player;
	    for each(var dataElement:XML in dataList) {	    
		player = new RunningPlayer(int(dataElement.@x), int(dataElement.@y));
	    }
	    player.setControllable(false);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		sO = new SO(int(dataElement.@x), int(dataElement.@y));
	    }
	}

	private function initMenu():void {
	    initTitleEntity();
	    initInstructionsEntity();
	}

	private function initTitleEntity():void {
	    var titleScale:Number = 5;
	    var titleText:Text = new Text("Valentine");
	    titleText.scale = titleScale;
	    titleTextEntity = new Entity(FP.halfWidth - 
					 titleScale*(titleText.width/2), 10, 
					 titleText);
	    add(titleTextEntity);	    
	}

	private function initInstructionsEntity():void {
	    var instructionScale:Number = 2;
	    var instructionText:Text = new Text("[x] - Start");
	    instructionText.scale = instructionScale;
	    instructionTextEntity = new Entity(FP.halfWidth - instructionScale *
					       (instructionText.width/2), 
					       130, instructionText);
	    add(instructionTextEntity);
	}

	private function initConversation():void {
	    conversation = new Array(convoFirst, convoSecond, convoThird, 
				     convoFourth, convoFifth, convoSixth,
				     convoSeventh);
	    conversation.reverse();
	}

	/*
	 * conversation
	 */

	private function adjustActor(actor:Actor, endEntity:Entity):void {
	    var adjustingX:Number = actor.centerX;
	    var endX:Number = endEntity.centerX;
	    if (adjustingX < endX) { actor.moveRight(endX); }
	    else if (adjustingX > endX) { actor.moveLeft(endX);}
	    if (endX == adjustingX) { 
	    	endEntity.visible = true;
		actor.isAdjusting = false;
	    }
	}

	// - not sure how to do compile-time constants, but speechY's default value
	// should always match textBubbleHeight
	// - if center is true, it will override whatever positions are passed in
	// and center the text right over the actor
	private function setupSpeechBubble(text:String, actor:Actor, 
					   speechBubble:Entity, center:Boolean,
					   speechX:Number=0):void {
	    textOptions = new Object();
	    textOptions["size"] = 16;
	    textOptions["color"] = actor.color;
	    textOptions["wordWrap"] = true;
	    
	    var words:Text = new Text(text, 0, 0, textOptions);
	    speechBubble.graphic = words;

	    speechBubble.setHitbox(words.width, words.height);
	    if (center) {
		speechBubble.x = actor.x + actor.halfWidth - speechBubble.halfWidth;
		speechBubble.visible = true;
	    }
	    else {
		speechBubble.x = speechX + conversationOffset;
		speechBubble.visible = false;
	    }
	    speechBubble.y = textBubbleHeight;
	}

	private function adjustPlayer():void {
	    adjustingPositions = true;
	    player.isAdjusting = true;
	}

	private function adjustSO():void {
	    adjustingPositions = true;
	    sO.isAdjusting = true;
	}

	/*
	 * conversation parts
	 */

	private function convoFirst():void {
	    add(player);

	    var moveToCenterAndSpeak:Function = function():void {
	    	setupSpeechBubble("What a fun party.", player, playerTextBubble,
	    			  false, 200);
	    	adjustPlayer();
	    }

	    setTimeout(moveToCenterAndSpeak, 300);
	}

	private function convoSecond():void {
	    add(sO);
	    playerTextBubble.visible = false;
	    
	    var moveToCenterAndSpeak:Function = function():void {
		adjustSO();
		setupSpeechBubble("Hey, wait!", sO, sOTextBubble, false, 60);
	    }
	    setTimeout(moveToCenterAndSpeak, 300);
	}

	private function convoThird():void {
	    adjustSO();
	    setupSpeechBubble("You forgot your keys.", sO, sOTextBubble, false, 115);
	    adjustPlayer();
	    setupSpeechBubble("", player, playerTextBubble, false, 245);
	}

	private function convoFourth():void {
	    setupSpeechBubble("Wow, thanks!", player, playerTextBubble, true);
	    sOTextBubble.visible = false;
	}

	private function convoFifth():void {
	    setupSpeechBubble("Follow me...", sO, sOTextBubble, true);
	    playerTextBubble.visible = false;
	}

	private function convoSixth():void {
	    adjustingPositions = true;
	    setupSpeechBubble("I want to show you something", sO, sOTextBubble, true);

	    // player movement
	    {
		playerTextBubble.visible = false;
	    }
	}

	private function convoSeventh():void {
	    adjustingPositions = true;
	    var offscreenX:Number = level.width + 10;

	    // move sO off screen first
	    sO.isAdjusting = true;
	    sOTextBubble.x = offscreenX;
	    sOTextBubble.y = textBubbleHeight;
	    sOTextBubble.visible = false;

	    // player follows shortly afterward
	    var movePlayerOffScreen:Function = function():void {
		player.isAdjusting = true;
		playerTextBubble.x = offscreenX;
		playerTextBubble.visible = false;
	    }
	    setTimeout(movePlayerOffScreen, 500);
	}

    }
}