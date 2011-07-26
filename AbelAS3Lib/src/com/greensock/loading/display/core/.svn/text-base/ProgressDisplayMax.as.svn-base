/**
 * VERSION: 0.5
 * DATE: 2010-05-20
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/loadermax/
 **/
package com.greensock.loading.display.core {
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
/**
 * This class is not finalized yet and is only intended for use in GreenSock demos. <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class ProgressDisplayMax extends ProgressDisplayLite {
		protected static var _point:Point = new Point(0, 0);
		
		protected var _preloader:ProgressDisplayLite;
		protected var _autoPosition:Boolean;
		protected var _root:DisplayObjectContainer;
		protected var _stageBounds:Rectangle = new Rectangle();
		protected var _matrix:Matrix;
		protected var _bd:BitmapData;
		protected var _bitmap:Bitmap;
		protected var _autoUpdate:Boolean;
		protected var _bgColor:uint;
		
		protected var _transparent:Boolean;
		
		public function ProgressDisplayMax(vars:Object=null) {
			super(vars);
			_transparent = true;
			_autoUpdate = Boolean(this.vars.autoUpdate != false);
			this.mouseEnabled = Boolean(this.vars.mouseEnabled != false);
		}
		
		override protected function _init(event:Event):void {
			super._init(event);
			
			_root = this.root as DisplayObjectContainer;
			while (_root.parent != this.stage) {
				_root = _root.parent;
			}
			this.autoPosition = Boolean(this.vars.autoPosition != false);
			
			if (this.parent != _root) {
				_root.addChild(this);
			} else {
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
			}
			
			_bgColor = ("bgColor" in this.vars) ? uint(this.vars.bgColor) : 0x00FFFFFF;
			_matrix = new Matrix();
			_bitmap = new Bitmap();
			this.addChild(_bitmap);
			_createBitmap(null);
		}
		
		protected function _createBitmap(event:Event=null):void {
			if (_bd) {
				_bd.dispose();
			}
			_bd = _bitmap.bitmapData = new BitmapData(_stageBounds.width, _stageBounds.height, _transparent, _bgColor);
			_updateBitmap(null);
		}
		
		protected function _updateBitmap(event:Event=null):void {
			_bd.fillRect(_bd.rect, _bgColor);
			_bitmap.x = -this.x + _stageBounds.x;
			_bitmap.y = -this.y + _stageBounds.y;
		}
		
		protected function _addStandardListeners():void {
			this.parent.addEventListener(Event.ADDED, _bringToFront, false, 0, true);
		}
		
		protected function _removeStandardListeners():void {
			this.removeEventListener(Event.ADDED, _bringToFront);
		}
		
		public function updatePosition(event:Event=null):void {
			if (_autoPosition && _stage) {
				_stageBounds.width = _stage.stageWidth;
				_stageBounds.height = _stage.stageHeight;
				_stageBounds.x = _stageBounds.y = 0;
				
				this.x = _stageBounds.width / 2 - _root.x;
				this.y = _stageBounds.height / 2 - _root.y;
				
				var align:String = _stage.align;
				var w:Number, h:Number;
				try {
					w = _root.loaderInfo.width;
					h = _root.loaderInfo.height;
				} catch (error:Error) {
					this.addEventListener(Event.ENTER_FRAME, _checkLoaderInfo, false, 0, true);
					w = _stageBounds.width;
					h = _stageBounds.height;
				}
				
				if (align == "") { //centered 
					_stageBounds.x = (w - _stageBounds.width) / 2;
					_stageBounds.y = (h - _stageBounds.height) / 2;
				} else if (align == "R" || align == "TR" || align == "BR") {
					_stageBounds.x = (w - _stageBounds.width);
				} 
				if (align == "B" || align == "BL" || align == "BR") {
					_stageBounds.y = (h - _stageBounds.height);
				}
				
				this.x += _stageBounds.x;
				this.y += _stageBounds.y;
				
				if (_bitmap) {
					_createBitmap(null);
				}
			}
		}
		
		override public function transitionIn():void {
			if (_mode < 1 && _bitmap != null) {
				super.transitionIn();
				_bitmap.alpha = 0;
				TweenLite.to(_bitmap, 0.4, {alpha:1, onComplete:_onTransitionInComplete, overwrite:true});
				_addStandardListeners();
				_preloader.transitionIn();
			}
		}
		
		override public function transitionOut():void {
			if (_mode > 0 && _bitmap != null) {
				super.transitionOut();
				_preloader.transitionOut();
				TweenLite.to(_bitmap, 0.5, {alpha:0, onComplete:_onTransitionOutComplete, overwrite:true});
			}
		}
		
		override protected function _onTransitionOutComplete():void {
			_removeStandardListeners();
			super._onTransitionOutComplete();
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		protected function _checkLoaderInfo(event:Event):void {
			var ok:Boolean;
			try {
				var w:Number = _root.loaderInfo.width;
			} catch (error:Error) {
				ok = false;
			}
			if (ok) {
				this.removeEventListener(Event.ENTER_FRAME, _checkLoaderInfo);
				updatePosition(null);
			}
		}
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		override public function set progress(value:Number):void {
			_progress = value;
			if (_preloader != null) {
				TweenLite.to(_preloader, 0.5, {progress:_progress, overwrite:true});
			}
		}
		
		public function get autoPosition():Boolean {
			return _autoPosition;
		}
		public function set autoPosition(value:Boolean):void {
			if (value != _autoPosition) {
				_autoPosition = value;
				if (_stage) {
					if (_autoPosition) {
						_stage.addEventListener(Event.RESIZE, updatePosition, false, 0, true);
						updatePosition(null);
					} else {
						_stage.removeEventListener(Event.RESIZE, updatePosition);
					}
				}
			}
		}
		
	}
}