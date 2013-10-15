package
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.StageDisplayState;
	
	import fish.collection.entry.mock.MockEntryDelegate;

	[SWF(width="900",height="700",frameRate="24",backgroundColor="#999999")]
	public class mock_fishcollection extends fishcollection
	{
		public function mock_fishcollection()
		{
			var rate:Number = 700/900;
			var height:int = 500;
			this.scaleX = this.scaleY = height/900;
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			g.beginFill(0xff0000);
			g.drawRect(0, 0, height/rate, height);
			g.endFill();
			mask = shape;
			LogConfig.enabled = true;
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		override protected function initApp():void
		{
			container.register(MockEntryDelegate);
			super.initApp();
		}
	}
}