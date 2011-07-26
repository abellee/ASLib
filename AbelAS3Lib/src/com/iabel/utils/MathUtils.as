package com.iabel.utils
{
	import flash.geom.Rectangle;

	public class MathUtils
	{
		public function MathUtils()
		{
		}
		public static function radiusToDegree(radius:Number):Number
		{
			return radius * 180 / Math.PI;
		}
		public static function degreeToRadius(degree:Number):Number
		{
			return degree * Math.PI / 180;
		}
		public static function containsRect(prect:Rectangle, rect:Rectangle):Boolean
		{
			var bottomPos:Number = rect.y + rect.height;
			var pBottomPos:Number = prect.y + prect.height;
			if(bottomPos < prect.y || rect.y > pBottomPos) return false;
			if((bottomPos >= prect.y && bottomPos <= pBottomPos) || (rect.y >= prect.y && rect.y <= pBottomPos) || rect.height >= prect.height) return true;
			return false;
		}
	}
}