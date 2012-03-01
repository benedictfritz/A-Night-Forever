package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;

    import entities.*;

    public class Star extends Entity {
	[Embed(source="../../assets/images/star.png")]
	    private const STAR_SPRITE:Class;

	private var
	    sprStar:Spritemap;

	public function Star(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    
	    sprStar = new Spritemap(STAR_SPRITE, 32, 32);
	    sprStar.add("default", [0, 1, 2, 3], 6, true);
	    this.graphic = sprStar;
	    setHitbox(sprStar.width, sprStar.height);
	    type="star";
	}

	override public function update():void {
	    var couple:Couple = collide("couple", x, y) as Couple;
	    if(couple) {
		couple.starBoost();
		FP.world.recycle(this);
	    }
	}
    }
}


