package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;

    public class Monster extends Entity {
	[Embed(source = '../../assets/sounds/music.swf', symbol='monster_spawn1')]
	    static public const MONSTER_SPAWN1:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='monster_spawn2')]
	    static public const MONSTER_SPAWN2:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='monster_spawn3')]
	    static public const MONSTER_SPAWN3:Class;

	[Embed(source = '../../assets/sounds/music.swf', symbol='monster_hit1')]
	    static public const MONSTER_HIT1:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='monster_hit2')]
	    static public const MONSTER_HIT2:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol='monster_hit3')]
	    static public const MONSTER_HIT3:Class;

	private var
	    monsterSpawnSounds:Array = new Array(new Sfx(MONSTER_SPAWN1),
						 new Sfx(MONSTER_SPAWN2),
						 new Sfx(MONSTER_SPAWN3));

	private var
	    monsterHitSounds:Array = new Array(new Sfx(MONSTER_HIT1),
					       new Sfx(MONSTER_HIT2),
					       new Sfx(MONSTER_HIT3));

	private static const
	    MONSTER_SOUND_VOL:Number = 0.8;

	private var 
	    xSpeed:Number = 100;

	public function Monster(x:int=0, y:int=0, graphic:Graphic=null):void {
	    type = "monster";

	    monsterSpawnSounds[int(FP.random*3)].play(MONSTER_SOUND_VOL);
	    super(x, y, graphic);
	}

	override public function update():void {
	    super.update();
	    x -= FP.elapsed * xSpeed;
	}

	public function despawn():void {
	    monsterHitSounds[int(FP.random*3)].play(MONSTER_SOUND_VOL);
	}
    }
}