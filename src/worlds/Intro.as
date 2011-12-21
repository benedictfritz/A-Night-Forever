package worlds
{
    import flash.geom.Point;
    
    import net.flashpunk.FP;
    import net.flashpunk.World;
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
	    textBubble:Text,
	    currSpeech:Object,
	    player:Player,
	    sO:SO,
	    conversation:Array;

	public function Intro():void {
	    conversation = new Array();
	    adjustingPositions = false;
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
	    dataList = levelData.objects.player;

	    // should only have one player, but with this code, 
	    // only the last one will get added
	    for each(dataElement in dataList) 
	    {	    
		player = new Player(int(dataElement.@x), int(dataElement.@y));
		add(player);
	    }

	    initConversation();
	}

	override public function update():void {
	    super.update();

	    if (adjustingPositions) {
		var currActor:Actor;
		if (currSpeech["char"] == PLAYER_VAL) { currActor = player; }
		else if (currSpeech["char"] == SO_VAL) { currActor = sO; }

		var textBubbleCenterX:Number =
		    textBubble.originX + textBubble.width/2;
		if (textBubbleCenterX < currActor.x) {
		    currActor.moveLeft(textBubbleCenterX);
		}
		else if (textBubbleCenterX > currActor.x) {
		    currActor.moveRight(textBubbleCenterX);
		}
		
		if (currActor.x == textBubbleCenterX) {
		    adjustingPositions = false;
		}

		return;
	    }
	    
	    // if (Input.pressed(Key.X)) {
	    // 	displaySpeech(conversation.pop());
	    // }

	    if (player.x > FP.width / FP.screen.scale) {
		FP.world = new Falling();
	    }
	}

	private function displaySpeech(speech:Object):void {
	    currSpeech = speech;
	    if (textBubble) { textBubble.visible = false; }
	    var wordsPoint:Point = speech["location"];
	    textBubble = new Text(speech["words"], wordsPoint.x, wordsPoint.y);
	    textBubble.color = 0xFFFFFF;
	    adjustingPositions = true;
	    addGraphic(textBubble);
	    textBubble.visible = true;
	}

	private function initConversation():void {
	    var newSpeech:Object = new Object();

	    newSpeech["words"] = "What a fun party.";
	    newSpeech["char"] = PLAYER_VAL;
	    newSpeech["location"] = new Point(0, 20);
	    conversation.push(newSpeech);

	    newSpeech = new Object();
	    newSpeech["words"] = "I'm talking to myself.";
	    newSpeech["char"] = PLAYER_VAL;
	    newSpeech["location"] = new Point(40, 20);
	    conversation.push(newSpeech);

	    // reverse the array so that we can simply pop things off
	    conversation.reverse();
	}
    }
}