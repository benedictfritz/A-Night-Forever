package entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.graphics.Spritemap;

    public class MonsterFish extends Monster {
	[Embed(source = '../../assets/images/monsterfish.png')]
	    private const MONSTER_SPRITE:Class;

	private var
	    monsterSprite:Spritemap = new Spritemap(MONSTER_SPRITE, 64, 64);

	public function MonsterFish(x:int=0, y:int=0):void {
	    monsterSprite.add("spawn", [0, 1, 2, 3, 4], 6, false);
	    monsterSprite.add("biting", [3, 4], 5, true);
	    monsterSprite.play("biting");

	    super(x, y, monsterSprite);

	}
    }
}