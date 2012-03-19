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
	    sprStar:Spritemap,
	    spriteTimer:Number = 0,
	    spriteLength:Number;

	public function Star(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;
	    
	    sprStar = new Spritemap(STAR_SPRITE, 32, 32);
	    sprStar.add("explode", [8, 6, 7, 5], 2, false);
	    this.graphic = sprStar;
	    setHitbox(sprStar.width, sprStar.height);
	    type="star";
	    
	    // randomize the speed with which the star changes its frame
	    spriteLength = FP.random / 5 + 0.1;
	}

	override public function update():void {
	    // randomize so all the stars don't look the same
	    randomizeStarSpriteFrame();

	    if (type != "deadStar") {
		var couple:Couple = collide("couple", x, y) as Couple;
		if(couple) {
		    couple.starBoost();
		    type="deadStar";
		    sprStar.play("explode");
		}
	    }
	}

	private function randomizeStarSpriteFrame():void {
	    spriteTimer += FP.elapsed;
	    if (spriteTimer > spriteLength) {
		spriteTimer = 0;
		sprStar.frame = (type=="deadStar") ? FP.random*4+4: FP.random * 4;
	    }
	}
    }
}


