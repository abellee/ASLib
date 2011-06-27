package com.iabel.utils
{
	import com.iabel.colors.HSB;
	import com.iabel.colors.HSL;
	import com.iabel.colors.RGB;

	public class ColorUtils
	{
		/**
		 * class for colors conversion
		 * by Abel Lee
		 */
		public function ColorUtils()
		{
		}
		/**
		 * rgb to hsl conversion
		 * hsl存在问题
		 */
		public static function rgbToHSL(rgb:RGB):HSL
		{
			var r:Number = rgb.r / 0xff;
			var g:Number = rgb.g / 0xff;
			var b:Number = rgb.b / 0xff;
			var hsl:HSL = new HSL();
			var max:Number, min:Number;
			max = Math.max(r, g, b);
			min = Math.min(r, g, b);
			if(max == min){
				
				hsl.h = 0;
				
			}else if(max == r && g >= b){
				
				hsl.h = 60 * ((g - b) / (max - min));
				
			}else if(max == r && g < b){
				
				hsl.h = 60 * ((g - b) / (max - min)) + 360;
				
			}else if(max == g){
				
				hsl.h = 60 * ((b - r) / (max - min)) + 120;
				
			} else if (max == b) {
				
				hsl.h = 60 * ((r - g) / (max - min)) + 240;
				
			}
			
			hsl.l = (max + min) / 2;
			
			if (hsl.l == 0 || max == min) {
				
				hsl.s = 0;
				
			} else if (hsl.l > 0 && hsl.l <= 0.5) {
				
				hsl.s = (max - min) / (max + min);
				
			} else if (hsl.l > 0.5) {
				
				hsl.s = (max - min) / (2 - (max + min));
				
			}
			hsl.h = Number(hsl.h.toFixed(2));
			hsl.s = Number(hsl.s.toFixed(2));
			hsl.l = Number(hsl.l.toFixed(2));
			return hsl;
		}
		
		/**
		 * hsl to rgb conversion
		 */
		public static function hslToRGB(hsl:HSL):RGB
		{
			var rgb:RGB = new RGB();
			if(hsl.l == 0){
				
				return new RGB(0, 0, 0);
				
			}
			if (hsl.s == 0) {
				
				rgb.r = hsl.l;
				rgb.g = hsl.l;
				rgb.b = hsl.l;
				
			} else {
				
				var q:Number, p:Number, TR:Number, TG:Number, TB:Number;
				if (hsl.l < 0.5) {
					
					q = hsl.l * (1 + hsl.s);
					
				} else {
					
					q = hsl.l + hsl.s - (hsl.l * hsl.s);
					
				}
				p = 2 * hsl.l - q;
				TR = hsl.h + (1 / 3);
				TG = hsl.h;
				TB = hsl.h - (1 / 3);
				rgb.r = toRGB(TR, q, p);
				rgb.g = toRGB(TG, q, p);
				rgb.b = toRGB(TB, q, p);
			}
			
			rgb.r = uint(rgb.r * 0xff);
			rgb.g = uint(rgb.g * 0xff);
			rgb.b = uint(rgb.b * 0xff);
			
			return rgb;
		}
		/**
		 * rgb to hsb conversion
		 */
		public static function rgbToHSB(rgb:RGB):HSB
		{
			var r:Number = rgb.r / 0xff;
			var g:Number = rgb.g / 0xff;
			var b:Number = rgb.b / 0xff;
			var max:Number, min:Number;
			max = Math.max(r, g, b);
			min = Math.min(r, g, b);
			var h:Number = 0;
			var s:Number = max ? 1 - min / max : 0;
			var br:Number = Number(max.toFixed(2));
			
			if(max == min){
				
				return new HSB(Number(h.toFixed(2)), Number(s.toFixed(2)), br);
				
			}
			switch(max){
				
				case r:
					h = 60 * (g - b) / (max - min);
					h = h < 0 ? h + 360 : h;
					break;
				case g:
					h = 60 * (b - r) / (max - min) + 120;
					break;
				case b:
					h = 60 * (r - g) / (max - min) + 240;
					break;
				
			}
			return new HSB(Number(h.toFixed(2)), Number(s.toFixed(2)), br);
		}
		/**
		 * hsb to rgb conversion
		 */
		public static function hsbToRGB(hsb:HSB):RGB
		{
			var h:Number = (hsb.h / 60) % 6;
			var f:Number = hsb.h / 60 - h;
			var p:Number = hsb.b * (1 - hsb.s);
			var q:Number = hsb.b * (1 - f * hsb.s);
			var t:Number = hsb.b * (1 - (1 - f) * hsb.s);
			var rgb:RGB = new RGB();
			if(h >=0 && h < 1){
				
				rgb.r = hsb.b;
				rgb.g = t;
				rgb.b = p;
				
			}else if(h >= 1 && h < 2){
				
				rgb.r = q;
				rgb.g = t;
				rgb.b = p;
				
			}else if(h >= 2 && h < 3){
				
				rgb.r = p;
				rgb.g = hsb.b;
				rgb.b = t;
				
			}else if(h >= 3 && h < 4){
				
				rgb.r = p;
				rgb.g = q;
				rgb.b = hsb.b;
				
			}else if(h >= 4 && h < 5){
				
				rgb.r = t;
				rgb.g = p;
				rgb.b = hsb.b;
				
			}else if(h >= 5 && h < 6){
				
				rgb.r = hsb.b;
				rgb.g = p;
				rgb.b = q;
				
			}
			rgb.r = uint(rgb.r * 0xff);
			rgb.g = uint(rgb.g * 0xff);
			rgb.b = uint(rgb.b * 0xff);
			
			return rgb;
		}
		
		/**
		 * hex to rgb conversion
		 * just like 0xff00ff
		 * not include alpha
		 */
		public static function hexToRGB(hex:Number = 0xffffff):RGB
		{
			var r:Number = hex >> 16;
			var g:Number = hex >> 8 & 0xff;
			var b:Number = hex & 0xff;
			return new RGB(r, g, b);
		}
		
		/**
		 * calculate to rgb
		 */
		private static function toRGB(TColor:Number, q:Number, p:Number):Number {
			
			if (TColor < 0) {
				
				TColor += 1;
				
			}
			
			if (TColor > 1) {
				
				TColor -= 1;
				
			}
			if (TColor < (1 / 6)) {
				
				return p + (q - p) * 6 * TColor;
				
			} else if (TColor < (1 / 2)) {
				
				return q;
				
			} else if (TColor < (2 / 3)) {
				
				return (p + (q - p)) * (6 * (2 / 3 - TColor));
				
			} else {
				
				return p;
				
			}
		}
	}
}