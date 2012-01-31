package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    public class WindTunnel extends Entity {
	[Embed(source="../../assets/images/png/wind_tunnel.png")]
	    private const WIND_TUNNEL_IMG:Class;

	public function WindTunnel(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    var img:Image = new Image(WIND_TUNNEL_IMG);
	    this.graphic = img;
	    setHitbox(img.width, img.height);
	    type="windTunnel";
	}
    }

}