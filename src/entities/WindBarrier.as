package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.utils.Draw;

    public class WindBarrier extends Entity {
	public var
	    a:Number = 1,
	    b:Number = 1,
	    c:Number = 0;
	
	public function WindBarrier(x:Number, y:Number) {
	    this.x = x;
	    this.y = y;

	    this.c = -(y + x);
	}

	public function distanceToLocation(x:Number, y:Number):Number {
	    return Math.abs((a*x) + (b*y) + c) / Math.sqrt(Math.pow(a, 2) + 
							   Math.pow(b, 2));
	}
	
	override public function render():void {
	    Draw.line(0, -c, 10000, -c - 10000);
	}
    }
}