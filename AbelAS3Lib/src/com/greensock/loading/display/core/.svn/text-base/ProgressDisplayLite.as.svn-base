/**
 * VERSION: 0.51
 * DATE: 2010-06-02
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/loadermax/
 **/
package com.greensock.loading.display.core {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.core.LoaderCore;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
/**
 * This class is not finalized yet and is only intended for use in GreenSock demos. <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class ProgressDisplayLite extends Sprite {
		protected var _loaders:Array;
		protected var _progress:Number;
		protected var _stage:Stage;
		protected var _mode:int; //0 = hidden, 1 = transitioning in, 2 = visible/showing, -1 = transitioning out
		protected var _initted:Boolean;
		
		public var autoTransition:Boolean;
		public var smoothProgress:Number;
		public var vars:Object;
		
		public function ProgressDisplayLite(vars:Object=null) {
			super();
			this.vars = (vars != null) ? vars : {};
			this.autoTransition = Boolean(this.vars.autoTransition != false);
			this.smoothProgress = ("smoothProgress" in this.vars) ? Number(this.vars.smoothProgress) : 0.5;
			_loaders = [];
			_progress = 0;
			_mode = (this.autoTransition) ? 0 : 2;
			if (_mode == 0) {
				this.visible = false;
			}
			this.addEventListener(Event.ADDED_TO_STAGE, _init, false, 0, true);
		}
	
		//only called when object is added to the stage initially.
		protected function _init(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, _init);
			_stage = this.stage;
			_initted = true;
		}
		
		public function addLoader(loader:LoaderCore):LoaderCore {
			loader.addEventListener(LoaderEvent.OPEN, _openHandler, false, 0, true);
			loader.addEventListener(LoaderEvent.COMPLETE, _completeHandler, false, 0, true);
			loader.addEventListener(LoaderEvent.PROGRESS, _progressHandler, false, 0, true);
			loader.addEventListener(LoaderEvent.ERROR, _errorHandler, false, 0, true);
			loader.addEventListener("dispose", _disposeHandler, false, 0, true);
			_loaders.push(loader);
			if (loader.status == LoaderStatus.LOADING) {
				transitionIn();
			}
			return loader;
		}
		
		public function removeLoader(loader:LoaderCore):LoaderCore {
			loader.removeEventListener(LoaderEvent.OPEN, _openHandler);
			loader.removeEventListener(LoaderEvent.COMPLETE, _completeHandler);
			loader.removeEventListener(LoaderEvent.PROGRESS, _progressHandler);
			loader.removeEventListener(LoaderEvent.ERROR, _errorHandler);
			loader.removeEventListener("dispose", _disposeHandler);
			_loaders.splice(_getLoaderIndex(loader), 1);
			if (_mode > 0 && _calculateProgress() == 1) {
				transitionOut();
			}
			return loader;
		}
		
		protected function _getLoaderIndex(loader:LoaderCore):uint {
			var i:int = _loaders.length;
			while (--i > -1) {
				if (_loaders[i] == loader) {
					return i;
				}
			}
			return 999999999;
		}
		
		protected function _bringToFront(event:Event=null):void {
			if (this.parent != null) {
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
			}
		}
		
		protected function _calculateProgress():Number {
			var bl:uint = 0;
			var bt:uint = 0;
			var i:int = _loaders.length;
			var loader:LoaderCore;
			var hasComplete:Boolean;
			while (--i > -1) {
				loader = _loaders[i];
				if (loader.status <= LoaderStatus.LOADING || loader.status == LoaderStatus.PAUSED) {
					bl += loader.bytesLoaded;
					bt += loader.bytesTotal;
				} else if (loader.status == LoaderStatus.COMPLETED) {
					hasComplete = true;
				}
			}
			return (bt > 0) ? bl / bt : hasComplete ? 1 : 0;
		}
		
		public function transitionIn():void {
			_bringToFront(null);
			this.visible = true;
			_mode = 1;
		}
		
		protected function _onTransitionInComplete():void {
			_mode = 2;
		}
		
		public function transitionOut():void {
			_mode = -1;
		}
		
		protected function _onTransitionOutComplete():void {
			this.visible = false;
			_mode = 0;
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		protected function _openHandler(event:Event):void {
			if (this.autoTransition) {
				transitionIn();
			}
		}
		
		protected function _progressHandler(event:LoaderEvent):void {
			this.progress = (_loaders.length == 1) ? LoaderCore(event.target).progress : _calculateProgress();
		}
		
		protected function _completeHandler(event:Event):void {
			if (this.autoTransition && _calculateProgress() == 1) {
				transitionOut();
			}
		}
		
		protected function _errorHandler(event:LoaderEvent):void {
			if (this.autoTransition) {
				transitionOut();
			}
		}
		
		protected function _disposeHandler(event:Event):void {
			removeLoader(event.target as LoaderCore);
		}
		
//---- STATIC METHODS ----------------------------------------------------------------------------
		
		
		
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		public function get loaders():Array {
			return _loaders.slice();
		}
		
		public function get progress():Number {
			return _progress;
		}
		public function set progress(value:Number):void {
			_progress = value;
		}
		
	}
}