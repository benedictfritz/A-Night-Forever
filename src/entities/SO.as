package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    public class SO extends Actor {
	[Embed(source = '../../assets/images/png/player_anim.png')]
	    private const SO_SPRITE:Class;

	private var
	    sprSO:Spritemap = new Spritemap(SO_SPRITE, 32, 32);

	public function SO(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    sprSO.add("stand", [0], 1, true);
	    sprSO.add("jump", [4], 1, true);
	    sprSO.add("right", [1, 2, 3, 4, 5, 6, 7, 6], 8, true);
	    sprSO.color = 0xEE0000;
	    this.graphic = sprSO;
	    setHitbox(sprSO.width, sprSO.height);
	    type = "player";
	}
    }
}