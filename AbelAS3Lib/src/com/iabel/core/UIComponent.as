package com.iabel.core
{
	import com.iabel.controls.ALLabel;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class UIComponent extends Sprite
	{
		protected var _listenerList:Object = null;
		protected var _callLaterList:Dictionary = null;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var changed:Boolean = false;
		
		protected var _txtFormat:TextFormat;
		
		public function UIComponent()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.ENTER_FRAME, callLaterDispatcher);
			stage.addEventListener(Event.RENDER, callLaterDispatcher);
			if(changed) stage.invalidate();
		}
		
		protected function callLaterDispatcher(event:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
			stage.removeEventListener(Event.RENDER, callLaterDispatcher);
			if(changed){
				
				for(var func:Object in _callLaterList){
					
					func();
					delete _callLaterList[func];
					
				}
				validate();
				changed = false;
				
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set width(value:Number):void
		{
			if(_width == value) return;
			_width = value;
			callLater(draw);
		}
		
		override public function set height(value:Number):void
		{
			if(_height == value) return;
			_height = value;
			callLater(draw);
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if(_width == w && _height == h) return;
			
			_width = w;
			_height = h;
			callLater(draw);
		}

		public function removeAllChildren():void
		{
			while(this.numChildren)
			{
				var child:DisplayObject = this.getChildAt(0);
				if(child && (child is Bitmap)){
					
					(child as Bitmap).bitmapData.dispose();
					child = null;
					
				}
				this.removeChildAt(0);
			}
		}
		
		public function get txtFormat():TextFormat
		{
			return _txtFormat;
		}
		
		public function set txtFormat(value:TextFormat):void
		{
			_txtFormat = value;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(!_listenerList) _listenerList = {};
			if(_listenerList[type] && _listenerList[type] == listener) return;
			_listenerList[type] = listener;
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(_listenerList && _listenerList[type] && _listenerList[type] == listener) delete _listenerList[type];
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		protected function draw():void
		{
			return;
		}
		
		protected function callLater(func:Function):void
		{
			changed = true;
			if(!this._callLaterList) this._callLaterList = new Dictionary();
			if(_callLaterList[func]) return;
			
			_callLaterList[func] = true;
			
			if(stage){
				if(!stage.hasEventListener(Event.ENTER_FRAME)) stage.addEventListener(Event.ENTER_FRAME, callLaterDispatcher);
				if(!stage.hasEventListener(Event.RENDER)) stage.addEventListener(Event.RENDER, callLaterDispatcher);
				stage.invalidate();
			}else{
				if(!hasEventListener(Event.ADDED_TO_STAGE)) addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		protected function validate():void
		{
			this._callLaterList = null;
		}
		
		protected function dealloc(event:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
			stage.removeEventListener(Event.RENDER, callLaterDispatcher);
			removeAllChildren();
			for (var key:String in _listenerList){
				
				this.removeEventListener(key, _listenerList[key]);
				
			}
			_listenerList = null;
			if(_callLaterList) _callLaterList = null;
			_txtFormat = null;
		}

	}
}