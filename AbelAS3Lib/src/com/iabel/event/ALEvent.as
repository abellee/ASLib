package com.iabel.event
{
	import flash.events.Event;
	
	public class ALEvent extends Event
	{
		public static const CREATION_COMPLETE:String = "creation_complete";
		public function ALEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}