package entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;

    public class Monster extends Entity {
	public function Monster(x:int=0, y:int=0, graphic:Graphic=null):void {
	    super(x, y, graphic);
	}
    }
}