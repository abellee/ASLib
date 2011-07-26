package com.iabel.controls
{
	import com.iabel.core.InvalidationType;
	
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
		}
		
		override protected function onMouseDown(event:MouseEvent):void
		{
			_selected = !_selected;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		override protected function drawStyle():void
		{
			super.drawStyle();
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
		
		override protected function resize():void
		{
			_alLabel.x = this.getChildAt(0).width;
			trace(this.height, _alLabel.height, ">>>>>>", _alLabel.width);
		}
		
		override protected function initLabel():void
		{
			super.initLabel();
			_alLabel.width = 0;
			
		}
		
		override protected function draw():void
		{
			super.draw();
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
			if(_checkPos == value) return;
			_checkPos = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

	}
}