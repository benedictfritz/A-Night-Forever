package entities 
{
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    public class CloudLayer extends Entity {
	[Embed(source="../../assets/images/cloud_layer_1.png")]
	    private const CLOUD_IMAGE_1:Class;
	[Embed(source="../../assets/images/cloud_layer_2.png")]
	    private const CLOUD_IMAGE_2:Class;
	[Embed(source="../../assets/images/cloud_layer_3.png")]
	    private const CLOUD_IMAGE_3:Class;

	public function CloudLayer(x:int, y:int, layer:Number=1) {
	    this.x = x;
	    this.y = y;

	    var cloudImg:Image;
	    if (layer == 1) { cloudImg = new Image(CLOUD_IMAGE_1); }
	    if (layer == 2) { cloudImg = new Image(CLOUD_IMAGE_2); }
	    if (layer == 3) { cloudImg = new Image(CLOUD_IMAGE_3); }
	    graphic = cloudImg;
	    type = "cloudLayer";
	}

    }
}
