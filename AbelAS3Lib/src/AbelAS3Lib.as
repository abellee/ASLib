package
{
	import com.iabel.Iterator.IIterator;
	import com.iabel.colors.HSB;
	import com.iabel.colors.HSL;
	import com.iabel.colors.RGB;
	import com.iabel.data.Collections.ArrayCollection;
	import com.iabel.utils.ColorUtils;
	
	import flash.display.Sprite;
	
	import test.Test;
	
	public class AbelAS3Lib extends Sprite
	{
		public function AbelAS3Lib()
		{
			var t:Test = new Test();
			t.setFunc(hey);
			t.test();
		}
		private function hey(str:String):void
		{
			trace(">>>>" + str);
		}
	}
}