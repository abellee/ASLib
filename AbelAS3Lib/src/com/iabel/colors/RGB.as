package com.iabel.colors
{
	public class RGB
	{
		private var _r:Number;
		
		private var _g:Number;
		
		private var _b:Number;
		
		public function RGB(rnum:Number = 0, gnum:Number = 0, bnum:Number = 0)
		{
			_r = rnum;
			_g = gnum;
			_b = bnum;
		}

		/**
		 * blue 蓝色值
		 */
		public function get b():Number
		{
			return _b;
		}

		/**
		 * @private
		 */
		public function set b(value:Number):void
		{
			_b = value;
		}

		/**
		 * green 绿色值
		 */
		public function get g():Number
		{
			return _g;
		}

		/**
		 * @private
		 */
		public function set g(value:Number):void
		{
			_g = value;
		}

		/**
		 * red 红色值
		 */
		public function get r():Number
		{
			return _r;
		}

		/**
		 * @private
		 */
		public function set r(value:Number):void
		{
			_r = value;
		}
		
		/**
		 * rgb to hex conversion
		 */
		public function get toHex():String
		{
			return "0x" + (r << 16 | g << 8 | b).toString(16);
		}

	}
}