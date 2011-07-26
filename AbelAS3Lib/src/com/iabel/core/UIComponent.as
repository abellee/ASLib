package com.iabel.core
{
	import com.iabel.controls.ALLabel;
	import com.iabel.utils.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class UIComponent extends ALSprite
	{
		
		protected var _txtFormat:TextFormat;
		
		public function UIComponent()
		{
			super();
		}
		
		public function get txtFormat():TextFormat
		{
			return _txtFormat;
		}
		
		public function set txtFormat(value:TextFormat):void
		{
			if(_txtFormat == value) return;
			_txtFormat = value;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(_txtFormat) _txtFormat = null;
		}
		
	}
}