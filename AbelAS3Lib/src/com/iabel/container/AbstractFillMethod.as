package com.iabel.container
{
	import com.iabel.data.Collections.Size;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class AbstractFillMethod implements IFillMethod
	{
		public function AbstractFillMethod()
		{
		}
		
		public function fillBackground(container:Sprite, size:Size, item:DisplayObject, fillMode:String):void
		{
			switch(fillMode){
				
				case BackgroundImageFillMode.CLIP:
					if(container.numChildren) return;
				case BackgroundImageFillMode.REPEAT:
					fill(container, size, item);
					break;
				case BackgroundImageFillMode.SCALE:
					item.width = size.width;
					item.height = size.height;
					break;
				
			}
		}
		
		protected function fill(container:Sprite, size:Size, item:DisplayObject):void
		{
			return;
		}
	}
}