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
	    adjustingPositions:Boolean,
	    playerTextBubble:Entity,
	    sOTextBubble:Entity,
	    currSpeech:Object,
	    player:Player,
	    sO:SO,
	    conversation:Array,
	    textOptions:Object,
	    textBubbleHeight:Number = 230;

	public function Intro():void {
	    player = new Player();
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

	    var level:Level = new Level(MAP_DATA);
	    add(level);

	    // should only have one player and so, but with this code
	    // only the last one will get added
	    var levelData:XML = level.getLevelData();
	    var dataList:XMLList = levelData.objects.player;
	    for each(var dataElement:XML in dataList) {	    
		player = new Player(int(dataElement.@x), int(dataElement.@y));
		add(player);
	    }
	    player.setControllable(false);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		sO = new SO(int(dataElement.@x), int(dataElement.@y));
	    }

	    initConversation();
	}

	override public function update():void {
	    super.update();
	    
	    if (adjustingPositions) {
		if (player.isAdjusting) { adjustActor(player, playerTextBubble); }
		if (sO.isAdjusting) { adjustActor(sO, sOTextBubble); }

		if (!player.isAdjusting && !sO.isAdjusting) {
		    adjustingPositions = false;
		}
	    }
	    
	    if (Input.pressed(Key.X) && !adjustingPositions) {
		// normally I would pop off function references every time the player
		// hits X
		conversation.pop()();
	    }

	    if (player.x > FP.width) {
		FP.world = new Falling();
	    }
	}

	private function initConversation():void {
	    conversation = new Array(convoFirst, convoSecond, convoThird, 
				     convoFourth, convoFifth, convoSixth,
				     convoSeventh);
	    conversation.reverse();
	}

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

	// not sure how to do compile-time constants, but speechY's default value
	// should always match textBubbleHeight
	private function setupSpeechBubble(text:String, actor:Actor, 
					   speechBubble:Entity, speechX:Number,
					   speechY:Number=230):void {
	    textOptions = new Object();
	    textOptions["size"] = 8;
	    textOptions["color"] = actor.color;
	    
	    var words:Text = new Text(text, 0, 0, textOptions);
	    speechBubble.graphic = words;
	    speechBubble.visible = false;
	    speechBubble.x = speechX;
	    speechBubble.y = speechY;
	    speechBubble.setHitbox(words.width, words.height);
	}

	private function adjustPlayer():void {
	    adjustingPositions = true;
	    player.isAdjusting = true;
	}

	private function adjustSO():void {
	    adjustingPositions = true;
	    sO.isAdjusting = true;
	}

	private function convoFirst():void {
	    add(player);

	    var moveToCenterAndSpeak:Function = function():void {
		setupSpeechBubble("What a fun party.", player, playerTextBubble,
				  200);
		adjustPlayer();
	    }

	    setTimeout(moveToCenterAndSpeak, 300);
	}

	private function convoSecond():void {
	    add(sO);
	    playerTextBubble.visible = false;
	    
	    var moveToCenterAndSpeak:Function = function():void {
		adjustSO();
		setupSpeechBubble("Hey, wait!", sO, sOTextBubble, 100, 
				  textBubbleHeight);
	    }
	    setTimeout(moveToCenterAndSpeak, 300);
	}

	private function convoThird():void {
	    adjustSO();
	    setupSpeechBubble("You forgot your keys.", sO, sOTextBubble, 165);
	    adjustPlayer();
	    setupSpeechBubble("", player, playerTextBubble, playerTextBubble.y);
	}

	private function convoFourth():void {
	    sOTextBubble.visible = false;

	    setupSpeechBubble("Wow, thanks!", player, playerTextBubble, player.x);
	    // by default the speech bubble is set to invisible for moving
	    playerTextBubble.visible = true;
	}

	private function convoFifth():void {
	    setupSpeechBubble("Follow me...", sO, sOTextBubble, 
			      sO.centerX - sOTextBubble.halfWidth);
	    sOTextBubble.visible = true;

	    playerTextBubble.visible = false;
	}

	private function convoSixth():void {
	    adjustingPositions = true;

	    sO movement
	    {
	    	var sOWords:Text = 
	    	    new Text("I want to show you something");
	    	sOWords.size = 8;
	    	sOWords.color = sO.color;
	    	sOTextBubble.graphic = sOWords;
	    	sOTextBubble.setHitbox(sOWords.width, sOWords.height);
	    	sOTextBubble.x = sO.centerX - sOTextBubble.halfWidth;
	    	sOTextBubble.visible = true;
	    }

	    // player movement
	    {
		playerTextBubble.visible = false;
	    }
	}

	private function convoSeventh():void {
	    adjustingPositions = true;

	    var offscreenX:Number = FP.width + 10;

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