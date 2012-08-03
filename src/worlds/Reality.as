package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Key;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.tweens.misc.VarTween;



    import entities.*;
    import worlds.*;
    import util.Util;

    public class Reality extends World
    {
        [Embed(source="../../assets/levels/Reality.oel", 
           mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	[Embed(source = '../../assets/levels/images/stump.png')] 
	    private static const STUMP:Class;
	[Embed(source = '../../assets/levels/images/dead_tree.png')] 
	    private static const DEAD_TREE:Class;
	[Embed(source = '../../assets/levels/images/three_rocks.png')] 
	    private static const THREE_ROCKS:Class;
	[Embed(source = '../../assets/levels/images/big_rock.png')] 
	    private static const BIG_ROCK:Class;
	[Embed(source = '../../assets/levels/images/pointy_rock.png')] 
	    private static const POINTY_ROCK:Class;
	[Embed(source = '../../assets/levels/images/tiny_rocks.png')] 
	    private static const TINY_ROCKS:Class;

	private static const
	    SO_CAM_BUFF:Number = 40,
	    CLOUD_Y:Number = 40;

	public var
	    pickingUp:Boolean,
	    sitting:Boolean,
	    inEndSequence:Boolean;

        private var
	    transitionIn:TransitionIn,
	    player:RunningPlayer,
	    SO:RunningSO,
	    level:Level,
	    skyBackground:SkyBackground;

	private var
	    cameraMinX:Number = 64,
	    cameraEndOfLevelX:Number,
	    soEndOfLevelX:Number;

        public function Reality():void {
            super();
        }

        override public function begin():void {
            super.begin();

            level = new Level(MAP_DATA);
            add(level);

	    var endOfLevelBlocksWidth:Number = 3*64;
	    var beginningOfLevelBlocksWidth:Number = 64;
	    cameraEndOfLevelX = level.width - endOfLevelBlocksWidth -
		beginningOfLevelBlocksWidth - FP.width;
	    soEndOfLevelX = cameraEndOfLevelX + FP.width - 120;

            // should only have one couple, but with this code, 
            // only the last one will get added
            var levelData:XML = level.getLevelData();
            var dataList:XMLList = levelData.objects.player;
            var dataElement:XML;
            for each(dataElement in dataList) {	    
                player = new RunningPlayer(int(dataElement.@x),
					   int(dataElement.@y));
                add(player);
            }
	    player.setControllable(false);

            dataList = levelData.objects.so;
            for each(dataElement in dataList) {	    
                SO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
                add(SO);
            }
	    SO.running = false;
	    SO.spawningMonsters = false;

	    dataList = levelData.objects.stump;
	    for each(dataElement in dataList) {
		var stump:Image = new Image(STUMP);
		addGraphic(stump, 1, int(dataElement.@x), int(dataElement.@y));
	    }

	    dataList = levelData.objects.deadTree;
	    for each(dataElement in dataList) {
		var deadTree:Image = new Image(DEAD_TREE);
		addGraphic(deadTree, 1, int(dataElement.@x), int(dataElement.@y));
	    }

	    dataList = levelData.objects.threeRocks;
	    for each(dataElement in dataList) {
		var threeRocks:Image = new Image(THREE_ROCKS);
		addGraphic(threeRocks, 1, int(dataElement.@x),
			   int(dataElement.@y));
	    }

	    dataList = levelData.objects.bigRock;
	    for each(dataElement in dataList) {
		var bigRock:Image = new Image(BIG_ROCK);
		addGraphic(bigRock, 1, int(dataElement.@x), int(dataElement.@y));
	    }

	    dataList = levelData.objects.pointyRock;
	    for each(dataElement in dataList) {
		var pointyRock:Image = new Image(POINTY_ROCK);
		addGraphic(pointyRock, 1, int(dataElement.@x),
			   int(dataElement.@y));
	    }

	    dataList = levelData.objects.tinyRocks;
	    for each(dataElement in dataList) {
		var tinyRocks:Image = new Image(TINY_ROCKS);
		addGraphic(tinyRocks, 1, int(dataElement.@x), int(dataElement.@y));
	    }

	    skyBackground = new SkyBackground(0, FP.height, 5, 1);
	    add(skyBackground);

	    for (var i:Number=-FP.width; i < level.width; i+=256) {
		var newCloudLayer3:CloudLayer = new CloudLayer(i, CLOUD_Y, 3);
		add(newCloudLayer3);
		var newCloudLayer2:CloudLayer = new CloudLayer(i, CLOUD_Y-32, 2);
		add(newCloudLayer2);
		var newCloudLayer1:CloudLayer = new CloudLayer(i, CLOUD_Y-64, 1);
		add(newCloudLayer1);
	    }

	    transitionIn = new TransitionIn(0.02, 0x000000);
	    add(transitionIn);

	    sitting = true;
        }

        override public function update():void {
            super.update();

	    if (inEndSequence) { 
		endSequenceUpdate();
		return;
	    }

	    if (SO.x >= soEndOfLevelX) {
		SO.running = false;
		SO.spawningMonsters = false;
		SO.playFaceLeft();

		player.goingFast = false;

		var panToEndSequence:VarTween = new VarTween();
		panToEndSequence.tween(FP.camera, "x",
				       cameraEndOfLevelX, 2, Ease.sineInOut);
		addTween(panToEndSequence);

		inEndSequence = true;
	    }
	    else {
		if (sitting) {
		    player.playSitRight();
		    SO.playFaceLeft();

		    if (Input.check(Key.RIGHT)) {
			sitting = false;
			player.setControllable(true);
			SO.playFaceRight();
			SO.running = true;
			SO.spawningMonsters = true;
		    }
		}
		updateCamera();
	    }

        }

	private function endSequenceUpdate():void {
	    if (player.x < FP.camera.x) { player.x = FP.camera.x; }
	}
	
	private function updateCamera():void {
	    if (!pickingUp) {
		var soCamX:Number = SO.right + SO_CAM_BUFF - FP.width;
		if (soCamX <= cameraMinX) {
		    FP.camera.x = cameraMinX;
		}
		else {
		    FP.camera.x = soCamX;
		}

		if (player.right < FP.camera.x) {
		    pickingUp = true;

		    player.fallen = true;
		    player.setControllable(false);

		    SO.running = false;
		    SO.playFaceLeft();
		    SO.spawningMonsters = false;

		    // remove all monsters when picking up
		    var allMonsters:Array = new Array();
		    getType("monster", allMonsters);
		    for each (var monster:Monster in allMonsters) {
			    monster.despawn();
			}

		    var panBackTween:VarTween = new VarTween();
		    var camPannedX:Number = FP.camera.x - 100;
		    panBackTween.tween(FP.camera, "x",
				       camPannedX, 2, Ease.sineInOut);
		    addTween(panBackTween);
		    cameraMinX = camPannedX;

		    SO.pickUpPlayer(player);
		}
	    }
	}

	public function firstSolidGroundY(xLoc:Number):Number {
	    var solidY:Number = -1;

	    for (var i:Number = 0; i < FP.height/64; i++) {
		if (level.grid.getTile(xLoc/64, i)) {
		    solidY = i * 64;
		    break;
		}
	    }
	    return solidY;
	}
    }
}
