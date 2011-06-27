package com.iabel.colors
{
	public class HSL
	{
		private var _h:Number;
		
		private var _s:Number;
		
		private var _l:Number;
		
		public function HSL(hnum:Number = 0, snum:Number = 0, lnum:Number = 0)
		{
			_h = hnum;
			_s = snum;
			_l = lnum;
		}

		/**
		 * lightness 亮度
		 */
		public function get l():Number
		{
			return _l;
		}

		/**
		 * @private
		 */
		public function set l(value:Number):void
		{
			_l = value;
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