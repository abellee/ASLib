package com.iabel.colors
{
	public class HSB
	{
		private var _h:Number;
		
		private var _s:Number;
		
		private var _b:Number;
		
		public function HSB(hnum:Number = 0, snum:Number = 0, bnum:Number = 0)
		{
			_h = hnum;
			_s = snum;
			_b = bnum;
		}

		/**
		 * brightness 明度
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
		 * saturation 饱和度
		 */
		public function get s():Number
		{
			return _s;
		}

		/**
		 * @private
		 */
		public function set s(value:Number):void
		{
			_s = value;
		}

		/**
		 * hue 色相
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

	}
}