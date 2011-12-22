package worlds
{
    import flash.geom.Point;
    
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
	    textBubble:Entity,
	    currSpeech:Object,
	    player:Player,
	    sO:SO,
	    conversation:Array;

	public function Intro():void {
	    conversation = new Array();
	    adjustingPositions = false;
	    textBubble = new Entity();
	    add(textBubble);
	    textBubble.visible = false;
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

		var adjustingX:Number = currActor.centerX;
		var endX:Number = textBubble.centerX;
		if (adjustingX < endX) { currActor.moveRight(endX); }
		else if (adjustingX > endX) { currActor.moveLeft(endX);}
		if (endX == adjustingX) { 
		    textBubble.visible = true;
		    adjustingPositions = false; 
		    player.setControllable(true);
		}

		return;
	    }
	    
	    if (Input.pressed(Key.X)) {
		player.setControllable(false);
	    	displaySpeech(conversation.pop());
	    }

	    if (player.x > FP.width / FP.screen.scale) {
		FP.world = new Falling();
	    }
	}

	private function displaySpeech(speech:Object):void {
	    currSpeech = speech;
	    if (textBubble) { textBubble.visible = false; }
	    var wordsPoint:Point = speech["location"];
	    textBubble.x = wordsPoint.x;
	    textBubble.y = wordsPoint.y;

	    var newWords:Text = new Text(speech["words"]);
	    newWords.color = 0xFFFFFF;
	    textBubble.graphic = newWords;
	    textBubble.setHitbox(newWords.width, newWords.height);
	    adjustingPositions = true;
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
	    newSpeech["location"] = new Point(200, 20);
	    conversation.push(newSpeech);

	    // reverse the array so that we can simply pop things off
	    conversation.reverse();
	}
    }
}