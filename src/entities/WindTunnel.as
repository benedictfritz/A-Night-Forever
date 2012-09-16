package entities
{
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class WindTunnel extends Entity {
	[Embed(source="../../assets/images/wind_tunnel.png")]
	    private const WIND_TUNNEL_SPRITE:Class;
	[Embed(source = '../../assets/sounds/music.swf', symbol = 'wind_boost')]
	    static public const WIND_BOOST:Class;

	private var 
	    sprWindTunnel:Spritemap,
	    sound:Sfx = new Sfx(WIND_BOOST);

	public function WindTunnel(x:int=0, y:int=0) {
	    this.x = x;
	    this.y = y;

	    sprWindTunnel = new Spritemap(WIND_TUNNEL_SPRITE, 64, 64);
	    sprWindTunnel.add("blow", [0, 1, 2, 3, 4], 10, true);
	    sprWindTunnel.play("blow");
	    this.graphic = sprWindTunnel;
	    setHitbox(sprWindTunnel.width, sprWindTunnel.height);
	    type="windTunnel";
	}

	public function playSound():void {
	    if (!sound.playing) {
		sound.play(0.2);
	    }
	}
    }

}