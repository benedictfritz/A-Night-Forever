package worlds
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;

    import entities.*;

    public class Sector extends Entity {
	// the width and height are one screen width
	public static const
	    WIDTH:Number = FP.width / FP.screen.scale,
	    HEIGHT:Number = FP.height / FP.screen.scale;;

	public var
	    column:Number,
	    row:Number;

	private var
	    stars:Array;

	public function Sector(column:Number=0, row:Number=0) {
	    this.column = column;
	    this.row = row;
	    stars = new Array();
	}

	public function addStar(star:Star):void {
	    stars.push(star);
	}

	public function contains(x:Number, y:Number):Boolean {
	    if (x > minX() && x < maxX() && y > minY() && y < maxY()) {
		return true;
	    }
	    return false;
	}
	
	public function minX():Number {
	    return this.column * WIDTH;
	}
	
	public function maxX():Number {
	    return minX() + WIDTH;
	}

	public function minY():Number {
	    return row * HEIGHT;
	}

	public function maxY():Number {
	    return minY() + HEIGHT;
	}

    }
}