package com.iabel.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class TileLayout extends AbstractLayout
	{
		public function TileLayout()
		{
			super();
		}
		override public function layout(view:DisplayObjectContainer):void
		{
			trace("i'm tilelayout!");	
		}
	}
}