package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.tweens.misc.VarTween;
    import net.flashpunk.tweens.sound.SfxFader;

    import util.Util;
    import entities.*;
	
    public class Intro1 extends Intro {
	[Embed(source="../../assets/levels/Intro1.oel", 
	       mimeType="application/octet-stream")]
	    private static const MAP_DATA:Class;

	private static const
	    PAN_TIME:Number = 3,
	    CAMERA_START_Y:Number = 0,
	    NUM_TITLE_CLOUDS:Number = 10,
	    NUM_PLAYING_CLOUDS:Number = 10;

	private var
	    level:Level,
	    titleScreen:TitleScreen,
	    transitionOut:TransitionOut,
	    player:RunningPlayer,
	    SO:RunningSO,
	    skyBackground:SkyBackground;

	private var
	    storyTextArray:Array,
	    storyText:Text,
	    textAlphaTween:VarTween,
	    nextText:String;

	private static var
	    TEXT_FADE_TIME:Number = 1;

	private var
    	    inMenu:Boolean=true,
	    inText:Boolean=false,
	    playing:Boolean = false;

	private var
	    panToPlayingTween:VarTween,
	    panToTextTween:VarTween;

	override public function begin():void {
	    super.begin();
	    FP.camera.y = CAMERA_START_Y;
	    initStoryTextArray();
	    initLevel();
	}

	override public function update():void {
	    super.update();

	    if (inMenu) { inMenuUpdate(); }
	    else if (inText) { inTextUpdate(); }
	    else if (playing) { playingUpdate(); }
	}

	/*
	 * update methods
	 */
	private function inMenuUpdate():void {
	    if (Input.check(Key.DOWN)) {
		inMenu = false;

		panToTextTween = new VarTween(function():void { inText = true; });
		panToTextTween.tween(FP.camera, "y", FP.height, PAN_TIME);
		addTween(panToTextTween);
	    }
	}

	private function inTextUpdate():void {
	    if (!storyText) {
		storyText = new Text("", 100, 850, { size:30, align:"center",
						     width:600, height:100,
						     color:0x808080, wordWrap:true,
						     smooth:true, alpha:0 });
		addGraphic(storyText);
		fadeInNextText();
		nextText = storyTextArray.shift();
	    }

	    if (Input.pressed(Key.DOWN)) {
		var potentialNextText:String = storyTextArray.shift();
		if (potentialNextText) {
		    if (!textAlphaTween) {
			nextText = potentialNextText;
			fadeInNextText();
		    }
		    else {
			// if we aren't going to use the next text, put it back in
			// the story array
			storyTextArray.unshift(potentialNextText);
		    }
		}
		// check if we still have the tween so the tween finishes
		else if (!textAlphaTween) {
		    nextText = "";
		    fadeInNextText();

		    inText = false;

		    panToPlayingTween = new VarTween(function():void {
			    playing = true;
			    player.setControllable(true);
			});
		    panToPlayingTween.tween(FP.camera, "y", FP.height*2, PAN_TIME);
		    addTween(panToPlayingTween);
		}
	    }
	}

	private function playingUpdate():void {
	    if (!SO.running && Input.check(Key.RIGHT)) {
		SO.running = true;
	    }
	    if (player.x > FP.width && !transitionOut) {
		transitionOut = new TransitionOut(new Intro2());
		add(transitionOut);
	    }
	}

	/*
	 * level initialization
	 */

	private function initLevel():void {
	    titleScreen = new TitleScreen(0, CAMERA_START_Y);
	    add(titleScreen);

	    level = new Level(MAP_DATA);
	    add(level);

	    var levelData:XML = level.getLevelData();
	    var dataElement:XML;
	    var dataList:XMLList = levelData.objects.player;
	    for each(dataElement in dataList) {
		player = new RunningPlayer(int(dataElement.@x),
					   int(dataElement.@y));
		add(player);
	    }
	    player.goMedium();
	    player.setControllable(false);

	    dataList = levelData.objects.so;
	    for each(dataElement in dataList) {
		SO = new RunningSO(int(dataElement.@x), int(dataElement.@y));
		add(SO);
	    }

	    dataList = levelData.objects.smallCloud;
	    for each(dataElement in dataList) {
		add(new VisualCloud(int(dataElement.@x), int(dataElement.@y), 0));
	    }
	    dataList = levelData.objects.mediumCloud;
	    for each(dataElement in dataList) {
		add(new VisualCloud(int(dataElement.@x), int(dataElement.@y), 1));
	    }
	    dataList = levelData.objects.largeCloud;
	    for each(dataElement in dataList) {
		add(new VisualCloud(int(dataElement.@x), int(dataElement.@y), 2));
	    }

	    skyBackground = new SkyBackground(0, FP.height*3, 1, 3);
	    add(skyBackground);
	}


	/*
	 * story text
	 */

	private function initStoryTextArray():void {
	    storyTextArray =
		new Array(
			  "The night numbly prods at my nerve endings.",
			  "It has always been night; the warmth of the sun firmly tucked beyond the horizon.",
			  "But I know its warmth is there. It must be there.");
	}

	private function nullOutAlphaTween():void {
	    textAlphaTween = null;
	}

	private function fadeInNextText():void {
	    textAlphaTween = new VarTween(function():void {
		    storyText.text = nextText;
		    textAlphaTween = new VarTween(nullOutAlphaTween);
		    textAlphaTween.tween(storyText, "alpha", 1, TEXT_FADE_TIME);
		    addTween(textAlphaTween);
		});
	    if (storyText.alpha == 1) {
		textAlphaTween.tween(storyText, "alpha", 0, TEXT_FADE_TIME);
	    }
	    else {
		// skip the fade out if it's already faded out
		textAlphaTween.tween(storyText, "alpha", 0, 0.1);
	    }
	    addTween(textAlphaTween);	    
	}
    }
}