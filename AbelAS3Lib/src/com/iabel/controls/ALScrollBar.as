package com.iabel.controls
{
	import com.iabel.core.ALSprite;
	import com.iabel.core.InvalidationType;
	import com.iabel.core.UIComponent;
	import com.iabel.utils.MathUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ALScrollBar extends UIComponent
	{
		protected var _scrollBar:ALButton;
		
		protected var _view:DisplayObject;
		
		protected var _viewContainer:ALSprite;
		
		protected var _minScrollPosition:Number = 0;
		protected var _maxScrollPosition:Number = 0;
		protected var _lineScrollSize:Number = 50;
		protected var _scrollPosition:Number = 0;
		protected var _pageScrollSize:Number = 0;
		protected var _gap:uint = 0;
		protected var _scrollCoefficient:int = 5;
		
		protected var _trackSkin:DisplayObject;
		protected var _thumbOverSkin:DisplayObject;
		protected var _thumbUpSkin:DisplayObject;
		protected var _thumbDownSkin:DisplayObject;
		
		protected var _scrollRect:Rectangle;
//		protected var _smoothing:Boolean = true;
		
		private var targetPos:int;
		private var dragging:Boolean = false;
		
		private var removeEnterFrameDelay:uint = 30;     //多少秒后移除滚动的enterframe事件
		private var removeEnterFrameCurCount:uint = 0;
		
		public function ALScrollBar()
		{
			super();
		}
		
		override protected function resize():void
		{
			this.width = (this.width + _gap) > this.width ? (this.width + _gap) : this.width;
			if(_viewContainer && _scrollBar){
				if(_thumbUpSkin){
					_scrollBar.width = _thumbUpSkin.width;
				}
				if(_trackSkin){
					_trackSkin.x = this.width - _trackSkin.width;
					_scrollBar.x = (_trackSkin.width - _scrollBar.width) / 2 + _trackSkin.x;
				}else{
					_scrollBar.x = this.width - _scrollBar.width;
				}
				var scrollableHeight:Number = _view.height - this.height;
				var per:Number = scrollableHeight / this.height;
				_scrollBar.height = this.height * per;
				if(_scrollBar.height < 10) _scrollBar.height = 10;
				_pageScrollSize = scrollableHeight / (this.height - _scrollBar.height);
			}
		}
		
		override protected function drawStyle():void
		{
			if(_scrollBar){
				_scrollBar.outSkin = _thumbUpSkin;
				_scrollBar.overSkin = _thumbOverSkin;
				_scrollBar.downSkin = _thumbDownSkin;
			}
			if(_view){
				if(!_viewContainer) _viewContainer = new ALSprite();
				if(_scrollRect) _viewContainer.scrollRect = _scrollRect;
				else _viewContainer.scrollRect = new Rectangle(0, 0, _view.width, this.height);
				if(!_viewContainer.contains(_view)){
					_viewContainer.addChild(_view);
					_viewContainer.width = _view.width;
					_viewContainer.height = _view.height;
				}
				if(!this.contains(_viewContainer)) addChild(_viewContainer);
			}
			if(_trackSkin && !this.contains(_trackSkin)) addChildAt(_trackSkin, 0);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.ALL)){
				this.width = (this.width + _gap) > this.width ? (this.width + _gap) : this.width;
				if(!_scrollBar) _scrollBar = new ALButton(_thumbUpSkin, _thumbOverSkin, _thumbDownSkin, null, null);
				_scrollBar.label = "";
				addChild(_scrollBar);
				addListener();
				super.draw();
			}
			if(isInvalid(InvalidationType.STYLE)) drawStyle();
			if(isInvalid(InvalidationType.SIZE)) resize();
			if(isInvalid(InvalidationType.SCROLL)) scrollContent();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(stage.hasEventListener(MouseEvent.MOUSE_UP)) stage.removeEventListener(MouseEvent.MOUSE_UP, scrollBar_mouseUpHandler);
			if(this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, smoothingScrollHandler);
			_trackSkin = null;
			_thumbOverSkin = null;
			_thumbUpSkin = null;
			_thumbDownSkin = null;
			_scrollRect = null;
			_viewContainer = null;
			_view = null;
			_scrollBar = null;
		}
		
		override public function get scrollRect():Rectangle
		{
			return _scrollRect;
		}
		
		override public function set scrollRect(value:Rectangle):void
		{
			if(_scrollRect.equals(value)) return;
			value.x = 0;
			value.y = 0;
			_scrollRect = value;
			invalidation(InvalidationType.SIZE, resize);
		}
		
		public function setStyle(name:String, value:DisplayObject):void
		{
			if(!value || !name) throw new ArgumentError("name or value can not be null!");
			if(this[name] == value) return;
			this[name] = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get view():DisplayObject
		{
			return _view;
		}

		public function set view(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("value can not be null!");
			if(_view == value) return;
			_view = value;
			invalidation(InvalidationType.SIZE, resize);
		}

		public function get maxScrollPosition():Number
		{
			return _maxScrollPosition;
		}

		public function set maxScrollPosition(value:Number):void
		{
			if(_maxScrollPosition == value) return;
			_maxScrollPosition = value;
		}

		public function get lineScrollSize():Number
		{
			return _lineScrollSize;
		}

		public function set lineScrollSize(value:Number):void
		{
			if(_lineScrollSize == value) return;
			_lineScrollSize = value;
		}

		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}

		public function set scrollPosition(value:Number):void
		{
			if(_scrollPosition == value) return;
			_scrollPosition = value;
		}

		public function get minScrollPosition():Number
		{
			return _minScrollPosition;
		}

		public function set minScrollPosition(value:Number):void
		{
			if(_minScrollPosition == value) return;
			_minScrollPosition = value;
		}

		public function get trackSkin():DisplayObject
		{
			return _trackSkin;
		}

		public function set trackSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("trackSkin can not be null!");
			if(_trackSkin == value) return;
			_trackSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get thumbOverSkin():DisplayObject
		{
			return _thumbOverSkin;
		}

		public function set thumbOverSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("thumbOverSkin can not be null!");
			if(_thumbOverSkin == value) return;
			_thumbOverSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get thumbUpSkin():DisplayObject
		{
			return _thumbUpSkin;
		}

		public function set thumbUpSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("thumbUpSkin can not be null!");
			if(_thumbUpSkin == value) return;
			_thumbUpSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get thumbDownSkin():DisplayObject
		{
			return _thumbDownSkin;
		}

		public function set thumbDownSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("thumbDownSkin can not be null!");
			if(_thumbDownSkin == value) return;
			_thumbDownSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get gap():uint
		{
			return _gap;
		}

		public function set gap(value:uint):void
		{
			if(_gap == value) return;
			_gap = value;
			invalidation(InvalidationType.SIZE, resize);
		}
		
		private function addListener():void
		{
			if(_scrollBar){
				if(!_scrollBar.hasEventListener(MouseEvent.MOUSE_DOWN)) _scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, scrollBar_mouseDownHandler);
				if(stage && !stage.hasEventListener(MouseEvent.MOUSE_UP)) stage.addEventListener(MouseEvent.MOUSE_UP, scrollBar_mouseUpHandler);
				if(!this.hasEventListener(MouseEvent.MOUSE_WHEEL)) this.addEventListener(MouseEvent.MOUSE_WHEEL, scrollBar_mouseWheelHandler);
			}
		}
		
		private function scrollBar_mouseDownHandler(event:MouseEvent):void
		{
			scrollContent();
			var xpos:uint = _view.width + _gap;
			var h:uint = this.height - _scrollBar.height;
			if(_scrollBar){
				removeEnterFrameCurCount = 0;
				dragging = true;
				_scrollBar.startDrag(false, new Rectangle(xpos, 0, 0, h));
			}
		}
		
		private function scrollBar_mouseUpHandler(event:MouseEvent):void
		{
			if(_scrollBar){
				this._scrollPosition = _scrollBar.y;
				dragging = false;
				_scrollBar.stopDrag();
			}
		}
		
		protected function scrollContent():void
		{
			if(!this.hasEventListener(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME, smoothingScrollHandler);
		}
		
		private function scrollBar_mouseWheelHandler(event:MouseEvent):void
		{
			if(_scrollBar){
				removeEnterFrameCurCount = 0;
				dragging = false;
				var h:int = this.height - _scrollBar.height;
				var _dis:int = 0;
				if (event.delta < 0){
					if(Math.round(_scrollBar.y) <= 0) return;
					_dis = 1;
				} else if (event.delta == 0){
					return;
				} else {
					if(Math.round(_scrollBar.y) >= h) return;
					_dis = -1;
				}
				targetPos = this._scrollPosition - _dis * _lineScrollSize;
				if(targetPos <= 0){
					targetPos = 0;
				}else if(targetPos >= h){
					targetPos = h;
				}
//				trace("targetPos:" + targetPos + ">>>>>" + this._scrollPosition + ">>>>>>" + _scrollBar.y + ">>>>>>" + h);
				invalidation(InvalidationType.SCROLL, scrollContent);
			}
		}
		
		private function smoothingScrollHandler(event:Event):void
		{
//			trace((targetPos - _scrollBar.y) / 5 + ">>>>>>");
			removeEnterFrameCurCount ++;
//			trace(removeEnterFrameCurCount);
			if(this.stage && uint(removeEnterFrameCurCount / this.stage.frameRate) >= this.removeEnterFrameDelay)
			{
//				trace("remove:" + removeEnterFrameCurCount + ":" + this.stage.frameRate);
				if(this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, smoothingScrollHandler);
				return;
			}
			if(dragging){
				removeEnterFrameCurCount = 0;
				targetPos = _scrollBar.y;
				this._scrollPosition = targetPos;
				this._view.y += ((- this._scrollPosition * _pageScrollSize) - this._view.y) / _scrollCoefficient;
			}else{
				_scrollBar.y += (targetPos - _scrollBar.y) / _scrollCoefficient;
				this._scrollPosition = _scrollBar.y;
				this._view.y = - this._scrollPosition * _pageScrollSize;
			}
			removeInvisibleObject();
		}
		
		private function removeInvisibleObject():void
		{
			if(!MathUtils.containsRect(this._viewContainer.scrollRect, new Rectangle(_view.x, _view.y, _view.width, _view.height)))
			{
				this._viewContainer.removeAllChildren();
			}
		}

		public function get scrollCoefficient():int
		{
			return _scrollCoefficient;
		}

		public function set scrollCoefficient(value:int):void
		{
			_scrollCoefficient = value;
		}


		/*public function get smoothing():Boolean
		{
			return _smoothing;
		}

		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}*/


	}
}