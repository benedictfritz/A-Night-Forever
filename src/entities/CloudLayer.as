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

	public function CloudLayer(x:int, y:int, cloudLayer:Number=1) {
	    this.x = x;
	    this.y = y;

	    var cloudImg:Image;
	    if (cloudLayer == 1) { 
		cloudImg = new Image(CLOUD_IMAGE_1); 
		cloudImg.scrollX = 1;
		layer = -1;
	    }
	    if (cloudLayer == 2) { 
		cloudImg = new Image(CLOUD_IMAGE_2); 
		cloudImg.scrollX = 0.6;
		layer = 1;
	    }
	    if (cloudLayer == 3) { 
		cloudImg = new Image(CLOUD_IMAGE_3); 
		cloudImg.scrollX = 0.3;
		layer = 2;
	    }
	    graphic = cloudImg;
	    type = "cloudLayer";
	}

    }
}
