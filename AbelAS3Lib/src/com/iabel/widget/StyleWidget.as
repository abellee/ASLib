package com.iabel.widget
{
	import com.iabel.data.Collections.BackgroundStyle;
	import com.iabel.data.Collections.BorderStyle;
	import com.iabel.data.Collections.RectRoundRaduis;
	import com.iabel.data.Collections.Size;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class StyleWidget
	{
		public function StyleWidget()
		{
		}
		public static function drawRect(sprite:Sprite, point:Point, size:Size, borderStyle:BorderStyle, backgroundStyle:BackgroundStyle):void
		{
			sprite.graphics.clear();
			if(borderStyle.borderVisible) sprite.graphics.lineStyle(borderStyle.borderWidth, borderStyle.borderColor, borderStyle.borderAlpha);
			sprite.graphics.beginFill(backgroundStyle.backgroundColor, backgroundStyle.backgroundAlpha);
			sprite.graphics.drawRect(point.x, point.y, size.width, size.height);
			sprite.graphics.endFill();
		}
		public static function drawRoundRectComplex(sprite:Sprite, point:Point, size:Size, borderStyle:BorderStyle, backgroundStyle:BackgroundStyle, rectRoundRadius:RectRoundRaduis):void
		{
			sprite.graphics.clear();
			if(borderStyle.borderVisible) sprite.graphics.lineStyle(borderStyle.borderWidth, borderStyle.borderColor, borderStyle.borderAlpha);
			sprite.graphics.beginFill(backgroundStyle.backgroundColor, backgroundStyle.backgroundAlpha);
			sprite.graphics.drawRoundRectComplex(point.x, point.y, size.width, size.height,
				rectRoundRadius.topLeftRadius, rectRoundRadius.topRightRadius, rectRoundRadius.bottomLeftRadius, rectRoundRadius.bottomRightRadius);
			sprite.graphics.endFill();
		}
	}
}