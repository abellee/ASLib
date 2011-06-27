package test
{
	public class Test
	{
		private var func:Function;
		public function Test()
		{
		}
		public function setFunc(f:Function):void
		{
			func = f;
		}
		public function test():void
		{
			func("shit!!!");
		}
	}
}