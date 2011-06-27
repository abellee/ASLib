package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ColorBox extends Sprite
	{
		private var _color:String;
		private var _pantone:String;
		private var _w:Number;
		private var _h:Number;
		
		private var hexTxt:TextField;
		private var panTxt:TextField;
		private var txtFormat:TextFormat;
		
		private var colorBox:Sprite;
		
		public function ColorBox(color:String, pantone:String, w:Number, h:Number)
		{
			super();
			
			_color = color;
			_pantone = pantone;
			_w = w;
			_h = h;
			
			draw();
		}
		
		private function draw():void
		{
			colorBox = new Sprite();
			colorBox.graphics.beginFill(Number(_color), 1.0);
			colorBox.graphics.lineStyle(2, 0x000000, .3);
			colorBox.graphics.drawRoundRect(0, 0, _w, _h, 5, 5);
			colorBox.graphics.endFill();
			colorBox.mouseChildren = false;
			addChild(colorBox);
			colorBox.addEventListener(MouseEvent.MOUSE_OVER, colorBox_mouseOverHandler);
			colorBox.addEventListener(MouseEvent.MOUSE_OUT, colorBox_mouseOutHandler);
			colorBox.addEventListener(MouseEvent.CLICK, colorBox_mouseClickHandler);
			
			txtFormat = new TextFormat();
			txtFormat.size = 12;
			
			hexTxt = new TextField();
			hexTxt.defaultTextFormat = txtFormat;
			hexTxt.autoSize = TextFieldAutoSize.LEFT;
			hexTxt.htmlText = "<b>Hex值:</b>  " + _color;
			
			addChild(hexTxt);
			hexTxt.x = (_w - hexTxt.textWidth) / 2;
			hexTxt.y = _h + 10;
			
			panTxt = new TextField();
			panTxt.defaultTextFormat = txtFormat;
			panTxt.autoSize = TextFieldAutoSize.LEFT;
			panTxt.htmlText = "<b>Pantone值:</b>  " + _pantone;
			
			addChild(panTxt);
			panTxt.x = (_w - hexTxt.textWidth) / 2;
			panTxt.y = hexTxt.y + hexTxt.textHeight + 10;
		}
		
		private function colorBox_mouseOverHandler(event:MouseEvent):void
		{
			TweenLite.to(colorBox, .2, {transformAroundCenter:{scaleX:1.1, scaleY: 1.1}, ease:Cubic.easeOut});
		}
		
		private function colorBox_mouseOutHandler(event:MouseEvent):void
		{
			TweenLite.to(colorBox, .2, {transformAroundCenter:{scaleX:1, scaleY: 1}, ease:Cubic.easeOut});
		}
		
		private function colorBox_mouseClickHandler(event:MouseEvent):void
		{
			if(ExternalInterface.available){
				
				ExternalInterface.call("setColor", _color, _pantone);
				
			}
		}

		/**
		 * 色块高度
		 */
		public function get h():Number
		{
			return _h;
		}

		/**
		 * @private
		 */
		public function set h(value:Number):void
		{
			_h = value;
		}

		/**
		 * 色块宽度
		 */
		public function get w():Number
		{
			return _w;
		}

		/**
		 * @private
		 */
		public function set w(value:Number):void
		{
			_w = value;
		}

		/**
		 * 当前显示的颜色的pantone值
		 */
		public function get pantone():String
		{
			return _pantone;
		}

		/**
		 * @private
		 */
		public function set pantone(value:String):void
		{
			_pantone = value;
		}

		/**
		 * 当前显示的颜色的16进制值
		 */
		public function get color():String
		{
			return _color;
		}

		/**
		 * @private
		 */
		public function set color(value:String):void
		{
			_color = value;
		}

		/**
		 * shadow filter
		 */
		private function getBitmapFilter():BitmapFilter {
			var color:Number = 0x000000;
			var alpha:Number = 0.8;
			var blurX:Number = 10;
			var blurY:Number = 10;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			return new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		/**
		 * gc
		 */
		public function dealloc():void
		{
			_pantone = null;
			txtFormat = null;
			this.filters = null;
			this.removeChild(hexTxt);
			this.removeChild(panTxt);
			hexTxt = null;
			panTxt = null;
		}
	}
}