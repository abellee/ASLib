package com.iabel.system
{
	import flash.net.LocalConnection;

	public class GC
	{
		public function GC()
		{
		}
		public static function gc():void
		{
			try{
				var conn1:LocalConnection = new LocalConnection();
				conn1.connect("foo");
				var conn2:LocalConnection = new LocalConnection();
				conn2.connect("foo");
			}catch(e :*){}
		}
	}
}