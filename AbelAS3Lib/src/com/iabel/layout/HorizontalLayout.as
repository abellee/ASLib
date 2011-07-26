package com.iabel.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class HorizontalLayout extends AbstractLayout
	{
		public function HorizontalLayout()
		{
			super();
		}
		public function test():void
		{
			trace("test function in horizontal layout class!");
		}
		override public function layout(view:DisplayObjectContainer):void
		{
			trace("i'm horizontal layout!");
		}
	}
}