package entities
{
    import flash.display.BitmapData;

    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Emitter;

    public class StarBurst extends Entity
    {
	private static const
	    BMP_WIDTH:Number = 2,
	    BMP_HEIGHT:Number = 2;

	private var 
	    emitter:Emitter,
	    hasExploded:Boolean = false,
	    lifeTime:Number = 0;

	public function StarBurst(x:int=0, y:int=0)
	{
	    this.x = x;
	    this.y = y;

	    var bmp:BitmapData = 
		new BitmapData(BMP_WIDTH, BMP_HEIGHT, false, 0xfefa51);
	    emitter = new Emitter(bmp);
	    emitter.newType("1", [0]);
	    emitter.setMotion("1", 0, 20, 0, 360, 40, 0.2);
	    graphic = emitter;
	}
	
	override public function update():void
	{
	    if (!hasExploded) {
		for (var i:int = 0; i < 200; ++i) {
		    emitter.emit("1", 0, 0);
		}
		hasExploded = true;
	    }
	    else {
		if (emitter.particleCount == 0) {
		    FP.world.recycle(this);
		}
	    }
	}
    }
}