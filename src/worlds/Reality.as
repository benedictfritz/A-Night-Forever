package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.Entity;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.graphics.Tilemap;

    import entities.*;
    import worlds.*;
    import util.Util;

    public class Reality extends World
    {
        [Embed(source="../../assets/levels/Reality.oel", 
           mimeType="application/octet-stream")]
        private static const MAP_DATA:Class;

	private static const
	    SO_CAM_BUFF:Number = 40;

        private var
	    player:RunningPlayer,
	    SO:RunningSO,
	    pickingUp:Boolean,
	    level:Level,
	    skyBackground:SkyBackground;

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
        }

        override public function update():void {
            super.update();
            
	    updateCamera();
        }
	
	private function updateCamera():void {
	    var soCamX:Number = SO.right + SO_CAM_BUFF - FP.width;
	    if (soCamX <= 64) {
		FP.camera.x = 64;
	    }
	    else {
		FP.camera.x = soCamX;
	    }

	    if (player.right < FP.camera.x) {
		SO.running = false;
		SO.playFaceLeft();
		SO.spawningMonsters = false;
		player.playSitRight();

		// remove all monsters when picking up
		var allMonsters:Array = new Array();
		getType("monster", allMonsters);
		for each (var monster:Monster in allMonsters) {
		    monster.despawn();
		}
	    }
	}
    }
}
