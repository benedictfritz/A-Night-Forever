package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    import entities.*;

    public class Star extends Entity {
	[Embed(source="../../assets/images/png/star.png")]
	    private const STAR_IMG:Class;

	public function Star(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    
	    var img:Image = new Image(STAR_IMG);
	    this.graphic = img;
	    setHitbox(img.width, img.height);
	    type="star";
	}

	override public function update():void {
	    var couple:Couple = collide("couple", x, y) as Couple;
	    if(couple) {
		couple.starBoost();
		var starBurst:StarBurst = new StarBurst(x, y);
		FP.world.add(starBurst);
		FP.world.recycle(this);
	    }
	}
    }
}


