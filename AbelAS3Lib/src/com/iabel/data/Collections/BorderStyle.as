package com.iabel.data.Collections
{
	import com.iabel.core.AbstractObject;

	public class BorderStyle extends AbstractObject
	{
		protected var _borderVisible:Boolean = false;
		protected var _borderAlpha:Number = 0;
		protected var _borderWidth:Number = 1;
		protected var _borderColor:Number = 0x000000;
		public function BorderStyle(bv:Boolean = false, ba:Number = 0, bw:Number = 1, bc:Number = 0x000000)
		{
			_borderVisible = bv;
			_borderAlpha = ba;
			_borderWidth = bw;
			_borderColor = bc;
		}
		
		public function equals(obj:BorderStyle):Boolean
		{
			return obj && (obj == this || (obj.borderVisible == _borderVisible && obj.borderAlpha == _borderAlpha && obj.borderWidth == _borderWidth && obj._borderColor == _borderColor));
		}

		public function get borderVisible():Boolean
		{
			return _borderVisible;
		}

		public function set borderVisible(value:Boolean):void
		{
			_borderVisible = value;
		}

		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}

		public function set borderAlpha(value:Number):void
		{
			_borderAlpha = value;
		}

		public function get borderWidth():Number
		{
			return _borderWidth;
		}

		public function set borderWidth(value:Number):void
		{
			_borderWidth = value;
		}

		public function get borderColor():Number
		{
			return _borderColor;
		}

		public function set borderColor(value:Number):void
		{
			_borderColor = value;
		}


	}
}