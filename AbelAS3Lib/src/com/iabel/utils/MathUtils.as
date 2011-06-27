package com.iabel.utils
{
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
	}
}