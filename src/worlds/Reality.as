package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.utils.Ease;
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

	private static const
	    SO_CAM_BUFF:Number = 40,
	    CLOUD_Y:Number = 40;

	public var
	    pickingUp:Boolean;

        private var
	    player:RunningPlayer,
	    SO:RunningSO,
	    level:Level,
	    skyBackground:SkyBackground,
	    cameraMinX:Number = 64;

        public function Reality():void {
            super();
        }

        override public function begin():void {
            super.begin();

            level = new Level(MAP_DATA);
            add(level);

            // should only have one couple, but with this code, 
            // only the last one will get added
            var levelData:XML = level.getLevelData();
            var dataList:XMLList = levelData.objects.player;
            var dataElement:XML;
            for each(dataElement in dataList) {	    
                player = new RunningPlayer(int(dataElement.@x), int(dataElement.@y));
                add(player);
            }

            dataList = levelData.objects.so;
            for each(dataElement in dataList) {	    
                SO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
                add(SO);
            }
	    SO.running = true;
	    SO.spawningMonsters = true;

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

        }

        override public function update():void {
            super.update();
            
	    updateCamera();
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
		    panBackTween.tween(FP.camera, "x", camPannedX, 2, Ease.sineInOut);
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
