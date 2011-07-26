package com.iabel.utils
{
	import flash.display.BitmapData;
	
	public class DashLine extends BitmapData
	{
		public function DashLine(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
		public function drawDashLine(dashLineWidth:uint=1, dashLineColor:Number = 0xFF000000, steps:uint = 1):void
		{
			for(var h:uint = 0; h<this.height; h++)
			{
				for(var i:uint = 0; i<this.width; i+=steps)
				{
					for(var j:uint = 0; j<dashLineWidth; j++)
					{
						this.setPixel32(i, h, dashLineColor);
						i++;
					}
				}
			}
		}
	}
}