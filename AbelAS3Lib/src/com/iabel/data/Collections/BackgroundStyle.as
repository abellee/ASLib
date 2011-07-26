package com.iabel.data.Collections
{
	import com.iabel.core.AbstractObject;

	public class BackgroundStyle extends AbstractObject
	{
		protected var _backgroundColor:Number = 0xffffff;
		protected var _backgroundAlpha:Number = 1.0;
		public function BackgroundStyle(bc:Number = 0xffffff, ba:Number = 1.0)
		{
			_backgroundColor = bc;
			_backgroundAlpha = ba;
		}
		
		public function equals(obj:BackgroundStyle):Boolean
		{
			return obj && (obj == this || (obj.backgroundAlpha == _backgroundAlpha && obj.backgroundColor == _backgroundColor));
		}
		
		override public function dealloc():void
		{
			super.dealloc();
		}

		public function get backgroundColor():Number
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:Number):void
		{
			_backgroundColor = value;
		}

		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
		}


	}
}