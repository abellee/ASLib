package com.iabel.core
{
	import com.iabel.system.CoreSystem;
	import com.iabel.utils.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class ALSprite extends Sprite
	{
		protected var _listenerList:Object = null;
		protected var _callLaterList:Dictionary = null;
		protected var invalidList:Vector.<String>;
		protected var changed:Boolean = false;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _percentWidth:Number = NaN;
		protected var _percentHeight:Number = NaN;
		public function ALSprite()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			invalidation(InvalidationType.ALL, draw);
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			CoreSystem.objectDestroied();
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			CoreSystem.objectDestroied();
			return super.removeChildAt(index);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			if(!CoreSystem.application) throw new IllegalOperationError("CoreSystem.application can't be null!" +
				" You must specify the current application when the main application has initialized!");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addResizeEvent();
			stage.addEventListener(Event.ENTER_FRAME, callLaterDispatcher);
			stage.addEventListener(Event.RENDER, callLaterDispatcher);
			if(changed) stage.invalidate();
		}
		
		protected function addResizeEvent():void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			if(this.stage["nativeWindow"]){
				this.stage["nativeWindow"].addEventListener(Event.RESIZE, stageResize_handler);
				this.stage["nativeWindow"].dispatchEvent(new Event(Event.RESIZE));
			}else{
				this.stage.addEventListener(Event.RESIZE, stageResize_handler);
				this.stage.dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		protected function stageResize_handler(event:Event):void
		{
			if(this.parent){
				if(this.parent == CoreSystem.application)
				{
					if(!isNaN(this.percentWidth)) this.width = this.percentWidth / 100 * this.stage.stageWidth;
					if(!isNaN(this.percentHeight)) this.height = this.percentHeight / 100 * this.stage.stageHeight;
				}else{
					if(!isNaN(this.percentWidth)) this.width = this.percentWidth / 100 * this.parent.width;
					if(!isNaN(this.percentHeight)) this.height = this.percentHeight / 100 * this.parent.height;
				}
			}
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
			invalidation(InvalidationType.SIZE, resize);
		}
		
		override public function set height(value:Number):void
		{
			if(_height == value) return;
			_height = value;
			invalidation(InvalidationType.SIZE, resize);
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if(_width == w && _height == h) return;
			
			_width = w;
			_height = h;
			invalidation(InvalidationType.SIZE, resize);
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
		
		/**
		 * 如果子显示物件不属于本人编写的UIComponent
		 * 需要在调用此方法前取消所有子显示物件的所有事件监听以及相关的会影响垃圾回收的引用等
		 */
		public function removeAllChildren():void
		{
			while(this.numChildren)
			{
				var child:DisplayObject = this.getChildAt(0);
				if(child){
					
					if(child is ScaleBitmap){
						(child as ScaleBitmap).dealloc();
					}else if(child is Bitmap){
						(child as Bitmap).bitmapData.dispose();
					}
					child = null;
				}
				this.removeChildAt(0);
			}
		}
		
		protected function drawStyle():void
		{
			return;
		}
		
		protected function resize():void
		{
			return;
		}
		
		protected function draw():void
		{
			drawStyle();
			resize();
		}
		
		protected function invalidation(type:String, func:Function):void
		{
			if(!invalidList) invalidList = new Vector.<String>();
			if(invalidList.indexOf(InvalidationType.ALL) != -1 || invalidList.indexOf(type) != -1){
				callLater(draw);
				return;
			}else if(type == InvalidationType.ALL){
				invalidList.length = 0;
				this._callLaterList = new Dictionary();
			}
			invalidList.push(type);
			callLater(draw);
		}
		
		protected function isInvalid(type:String):Boolean
		{
			if(invalidList.indexOf(type) != -1) return true;
			else return false;
		}
		
		protected function callLater(func:Function):void
		{
			changed = true;
			if(!this._callLaterList) this._callLaterList = new Dictionary();
			
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
			if(this.invalidList) this.invalidList.length = 0;
		}
		
		protected function dealloc(event:Event):void
		{
			if(this.stage["nativeWindow"]){
				this.stage["nativeWindow"].removeEventListener(Event.RESIZE, stageResize_handler);
			}else{
				this.stage.removeEventListener(Event.RESIZE, stageResize_handler);
			}
			stage.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
			stage.removeEventListener(Event.RENDER, callLaterDispatcher);
			removeAllChildren();
			for (var key:String in _listenerList){
				
				this.removeEventListener(key, _listenerList[key]);
				
			}
			if(invalidList) invalidList = null;
			if(_listenerList )_listenerList = null;
			if(_callLaterList) _callLaterList = null;
		}

		public function get percentWidth():Number
		{
			return _percentWidth;
		}

		public function set percentWidth(value:Number):void
		{
			if(value < 1 && !isNaN(value)) throw new ArgumentError("percentWidth must be in 1~100!");
			_percentWidth = value;
		}

		public function get percentHeight():Number
		{
			return _percentHeight;
		}

		public function set percentHeight(value:Number):void
		{
			if(value < 1 && !isNaN(value)) throw new ArgumentError("percentHeight must be in 1~100!");
			_percentHeight = value;
		}


	}
}