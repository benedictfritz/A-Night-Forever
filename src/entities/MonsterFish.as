package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.graphics.Spritemap;

    public class MonsterFish extends Monster {
	[Embed(source = '../../assets/images/monsterfish.png')]
	    private const MONSTER_SPRITE:Class;

	private static var
	    HITBOX_BUFF:Number=26;

	private var
	    monsterSprite:Spritemap = new Spritemap(MONSTER_SPRITE, 64, 64);

	public function MonsterFish(x:int=0, y:int=0):void {
	    monsterSprite.add("spawn", [0, 1, 2, 3, 4], 12, false);
	    monsterSprite.add("despawn", [4, 3, 2, 1, 0], 12, false);
	    monsterSprite.add("biting", [3, 4], 5, true);
	    monsterSprite.play("spawn");

	    setHitbox(30, 64, 0, 0);

	    super(x, y, monsterSprite);
	}

	override public function update():void {
	    super.update();
	    
	    // the only time the anim will be complete is after spawning
	    if (monsterSprite.currentAnim == "spawn" && monsterSprite.complete) {
		monsterSprite.play("biting");
	    }
	    if (monsterSprite.currentAnim == "despawn" && monsterSprite.complete) {
		FP.world.recycle(this);
	    }
	}

	override public function despawn():void {
	    super.despawn();
	    monsterSprite.play("despawn");
	    this.setHitbox(0, 0, 0, 0);
	}
    }
}