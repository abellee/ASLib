package com.iabel.system
{
	public class System
	{
		public static var publicStyle:Object = {};
		public function System()
		{
		}
		public static function setStyle(style:String, value:Object):void
		{
			publicStyle[style] = value;
		}
		public static function getStyle(style:String):Object
		{
			return publicStyle[style];
		}
		public static function clearStyle(style:String):void
		{
			if(publicStyle[style]) delete publicStyle[style];
		}
	}
}