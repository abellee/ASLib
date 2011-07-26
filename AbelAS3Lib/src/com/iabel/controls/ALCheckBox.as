package com.iabel.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ALCheckBox extends ALButton
	{
		protected var _selected:Boolean = false;
		protected var _checkPos:Point;
		public function ALCheckBox(outSkin:DisplayObject, overSkin:DisplayObject, downSkin:DisplayObject, disabledSkin:DisplayObject, selectedSkin:DisplayObject)
		{
			super(outSkin, overSkin, downSkin, disabledSkin, selectedSkin);
			
			init();
		}
		
		private function init():void
		{
			this.width = 150;
			this.height = 24;
		}
		
		override protected function onMouseDown(event:MouseEvent):void
		{
			_selected = !_selected;
			callLater(resetCurrentState);
		}
		
		override protected function resetCurrentState():void
		{
			super.resetCurrentState();
			if(!_checkPos) _checkPos = new Point(0, 0);
			if(_selected){
				if(_selectedSkin) this.addChild(_selectedSkin);
				_selectedSkin.visible = true;
				_selectedSkin.x = _checkPos.x;
				_selectedSkin.y = _checkPos.y;
			}else{
				if(_selectedSkin && !this.contains(_selectedSkin)) this.removeChild(_selectedSkin);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			_alLabel.width = 50;
			_alLabel.height = 24;
			_alLabel.x = this.width - _alLabel.width;
			_alLabel.y = (this.height - _alLabel.height) / 2;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			_checkPos = null;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function get checkPos():Point
		{
			return _checkPos;
		}

		public function set checkPos(value:Point):void
		{
			_checkPos = value;
			callLater(resetCurrentState);
		}

	}
}