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
	    conversation:Array;

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

	    FP.screen.scale = 2;
	    
	    var level:Level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML;
	    var dataList:XMLList;
	    var dataElement:XML;

	    levelData = level.getLevelData();


	    // should only have one player and so, but with this code
	    // only the last one will get added

	    dataList = levelData.objects.player;
	    for each(dataElement in dataList) {	    
		player = new Player(int(dataElement.@x), int(dataElement.@y));
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
		FP.console.log("pop");
		// normally I would pop off function references every time the player
		// hits X
		conversation.pop()();
	    }

	    if (player.x > FP.width / FP.screen.scale) {
		FP.world = new Falling();
	    }
	}

	private function initConversation():void {
	    conversation = new Array(convoFirst, convoSecond, convoThird);
	    conversation.reverse();
	}

	private function adjustActor(actor:Actor, endEntity:Entity):void {
	    FP.console.log("adjusting " + FP.elapsed);
	    var adjustingX:Number = actor.centerX;
	    var endX:Number = endEntity.centerX;
	    if (adjustingX < endX) { actor.moveRight(endX); }
	    else if (adjustingX > endX) { actor.moveLeft(endX);}
	    if (endX == adjustingX) { 
	    	endEntity.visible = true;
		actor.isAdjusting = false;
		FP.console.log("done adjusting");
	    }
	}

	private function convoFirst():void {
	    add(player);
	    
	    var moveToCenterAndSpeak:Function = function():void {
		adjustingPositions = true;
		player.isAdjusting = true;
		playerTextBubble.x = 200;
		playerTextBubble.y = 230;
	    
		var words:Text = new Text("What a fun party.");
		words.size = 8;
		words.color = player.color;
		playerTextBubble.graphic = words;
		playerTextBubble.setHitbox(words.width, words.height);
		playerTextBubble.visible = false;
	    }
	    setTimeout(moveToCenterAndSpeak, 300);
	}

	private function convoSecond():void {
	    add(sO);

	    var moveToCenterAndSpeak:Function = function():void {
		adjustingPositions = true;
		sO.isAdjusting = true;
		sOTextBubble.x = 100;
		sOTextBubble.y = 230;
	    
		var words:Text = new Text("Hey, wait!");
		words.size = 8;
		words.color = sO.color;
		sOTextBubble.graphic = words;
		sOTextBubble.setHitbox(words.width, words.height)
		sOTextBubble.visible = false;
	    }
	    setTimeout(moveToCenterAndSpeak, 300);
	}

	private function convoThird():void {
	    adjustingPositions = true;

	    // sO movement
	    {
		sO.isAdjusting = true;

		var sOWords:Text = new Text("You forgot your keys.");
		sOWords.size = 8;
		sOWords.color = sO.color;
		sOTextBubble.graphic = sOWords;
		sOTextBubble.setHitbox(sOWords.width, sOWords.height);
		sOTextBubble.x = 165;
		sOTextBubble.visible = false;
	    }

	    // player movement
	    {
		player.isAdjusting = true;;

		var playerWords:Text = new Text("");
		playerTextBubble.graphic = playerWords;
		playerTextBubble.setHitbox(playerWords.width, playerWords.height);
		playerTextBubble.x = 235;
		playerTextBubble.visible = false;
	    }
	}
    }
}