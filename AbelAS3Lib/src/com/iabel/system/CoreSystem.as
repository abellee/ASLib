package com.iabel.system
{
	import com.iabel.data.Collections.Padding;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class CoreSystem
	{
		public static var publicStyle:Object = {};
		public static var dataPool:Object = {};
		private static var curTime:int = 0;
		private static var totalTimes:int = 1000;
		
		public static var application:Object;
		
		public function CoreSystem()
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
		
		/**
		 * 建议在删除多少个可显示物件后进行强制垃圾回收
		 * 默认为 1000
		 * 设置为 0 可禁用建议强制垃圾回收记数
		 */
		public static function adviceGCTimes(times:int):void
		{
			totalTimes = times;
		}
		
		public static function objectDestroied():void
		{
			if(totalTimes == 0) return;
			curTime++;
			if(curTime >= totalTimes){
				trace("gc");
				GC.gc();
				curTime = 0;
			}
		}
	}
}