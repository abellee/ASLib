package com.iabel.controls
{
	import com.iabel.data.Collections.Size;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public class BackgroundImageFillMode
	{
		public static const CLIP:String = "clip";
		public static const REPEAT:String = "repeat";
		public static const SCALE:String = "scale";
		public function BackgroundImageFillMode()
		{
		}
		public static function getBackgroundImageFillMethod(item:DisplayObject):IFillMethod
		{
			var fillMethod:IFillMethod;
			if(item is Bitmap){
				
				fillMethod = new BitmapFillMethod();
				return fillMethod;
				
			}
			if(item is DisplayObject){
				
				fillMethod = new DisplayObjectFillMethod();
				return fillMethod;
				
			}
		}
	}
}