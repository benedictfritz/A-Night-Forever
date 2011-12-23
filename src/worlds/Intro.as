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
	    playerTextBubble:Entity,
	    soTextBubble:Entity,
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

	    soTextBubble = new Entity();
	    add(soTextBubble);
	    soTextBubble.visible = false;
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
	    }

	    initConversation();
	}

	override public function update():void {
	    super.update();
	    
	    FP.console.log("updating and visible is" + this.visible);

	    if (adjustingPositions) {
		if (player.isAdjusting) { adjustActor(player, playerTextBubble); }
		if (sO.isAdjusting) { adjustActor(sO, soTextBubble); }
	    }
	    
	    if (Input.pressed(Key.X) && !adjustingPositions) {
		player.setControllable(false);
		FP.console.log("pop");
		// normally I would pop off function references every time the player
		// hits X
		conversation.pop()();
	    }

	    if (player.x > FP.width / FP.screen.scale) {
		FP.world = new Falling();
	    }
	}

	override public function render():void {
	    FP.console.log("rendering");
	    super.render();
	}

	private function initConversation():void {
	    conversation = new Array(convoFirst, convoSecond);
	    conversation.reverse();
	}

	private function adjustActor(actor:Actor, endEntity:Entity):void {
	    var adjustingX:Number = actor.centerX;
	    var endX:Number = endEntity.centerX;
	    if (adjustingX < endX) { actor.moveRight(endX); }
	    else if (adjustingX > endX) { actor.moveLeft(endX);}
	    if (endX == adjustingX) { 
	    	endEntity.visible = true;
	    	adjustingPositions = false; 
	    	player.setControllable(true);
	    }
	}

	private function convoFirst():void {
	    add(player);
	}

	private function convoSecond():void {
	    adjustingPositions = true;
	    player.isAdjusting = true;
	    playerTextBubble.x = 60;
	    playerTextBubble.y = 20;
	    
	    var words:Text = new Text("What a fun party.");
	    words.color = 0xFFFFFF;
	    playerTextBubble.graphic = words;
	    playerTextBubble.setHitbox(words.width, words.height);
	}

	private function convoThird():void {
	    add(player);
	}

    }
}