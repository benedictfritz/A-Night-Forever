package entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.graphics.Spritemap;

    public class MonsterMouth extends Monster {
	[Embed(source = '../../assets/images/monstermouth.png')]
	    private const MONSTER_SPRITE:Class;

	private static var
	    HITBOX_BUFF:Number=26;

	private var
	    monsterSprite:Spritemap = new Spritemap(MONSTER_SPRITE, 64, 64);

	public function MonsterMouth(x:int=0, y:int=0):void {
	    monsterSprite.add("spawn", [0, 1, 2, 3, 4, 5], 12, false);
	    monsterSprite.add("biting", [4, 5], 5, true);
	    monsterSprite.play("spawn");

	    setHitbox(monsterSprite.width-HITBOX_BUFF, monsterSprite.height-HITBOX_BUFF,
		      -HITBOX_BUFF/2, -HITBOX_BUFF/2);

	    super(x, y, monsterSprite);
	}

	override public function update():void {
	    super.update();

	    // the only time the anim will be complete is after spawning
	    if (monsterSprite.complete) {
		monsterSprite.play("biting");
	    }
	}
    }
}