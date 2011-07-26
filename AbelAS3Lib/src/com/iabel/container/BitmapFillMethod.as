package com.iabel.container
{
	import com.iabel.data.Collections.Size;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class BitmapFillMethod extends AbstractFillMethod
	{
		public function BitmapFillMethod()
		{
			super();
		}
		protected override function fill(container:Sprite, size:Size, item:DisplayObject):void
		{
			if(!(item is Bitmap)) throw new ArgumentError("argument error! \"item\" must be an instance of Bitmap!");
			
			var pw:Number = size.width;
			var ph:Number = size.height;
			
			var iw:Number = item.width;
			var ih:Number = item.height;
			
			var curColumn:uint = container.width <= 0 ? 0 : uint(container.width / iw) + 1;
			var curRow:uint = container.height <= 0 ? 0 : uint(container.height / ih) + 1;
			
			var column:uint = uint(pw / iw) + 1;
			var row:uint = uint(ph / ih) + 1;
			
			for(var i:uint = curColumn; i < column; i++){
				
				for(var j:uint = curRow; j < row; j++){
					
					var oo:Bitmap = new Bitmap((item as Bitmap).bitmapData);
					container.addChild(oo);
					oo.x = i * oo.width;
					oo.y = j * oo.height;
					container.dispatchEvent(new Event(Event.RENDER));
					
				}
				
			}
		}
	}
}