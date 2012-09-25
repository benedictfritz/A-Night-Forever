package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.graphics.Spritemap;

    public class MonsterHand extends Monster {
	[Embed(source = '../../assets/images/monsterhand.png')]
	    private const MONSTER_SPRITE:Class;

	private var
	    monsterSprite:Spritemap = new Spritemap(MONSTER_SPRITE, 64, 64);

	public function MonsterHand(x:int=0, y:int=0):void {
	    monsterSprite.add("spawn", [0, 1, 2, 3], 8, false);
	    monsterSprite.add("despawn", [3, 2, 1, 0], 12, false);
	    monsterSprite.add("grabbing", [4, 3, 2, 3], 6, true);
	    monsterSprite.play("spawn");

	    setHitbox(30, 30, -10, -15);

	    super(x, y, monsterSprite);
	}

	override public function update():void {
	    super.update();
	    
	    if (monsterSprite.currentAnim == "spawn" && monsterSprite.complete) {
		monsterSprite.play("grabbing");
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