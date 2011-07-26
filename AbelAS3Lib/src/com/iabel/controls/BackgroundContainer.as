package com.iabel.controls
{
	import com.iabel.data.Collections.Size;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class BackgroundContainer extends Sprite
	{
		private var _backgroundImage:DisplayObject = null;
		public function BackgroundContainer()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}

		public function get backgroundImage():DisplayObject
		{
			return _backgroundImage;
		}

		public function set backgroundImage(value:DisplayObject):void
		{
			_backgroundImage = value;
		}

		public function fillBackground(size:Size, fillMode:String = BackgroundImageFillMode.CLIP):void
		{
			if(!_backgroundImage) throw new IllegalOperationError("backgroundImage is null!");
			var ifillMethod:IFillMethod = BackgroundImageFillMode.getBackgroundImageFillMethod(_backgroundImage);
			ifillMethod.fillBackground(this, size, _backgroundImage, fillMode);
		}
		protected function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			while(this.numChildren){
				
				var child:DisplayObject = this.getChildAt(0);
				this.removeChild(child);
				if(child){
					
					if(child is Bitmap){
						
						(child as Bitmap).bitmapData.dispose();
						child = null;
						
					}
					
				}
				
			}
			if(_backgroundImage is Bitmap) (_backgroundImage as Bitmap).bitmapData.dispose();
			_backgroundImage = null;
		}
	}
}