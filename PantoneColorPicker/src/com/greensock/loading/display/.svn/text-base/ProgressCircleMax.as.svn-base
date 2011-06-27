/**
 * VERSION: 0.5
 * DATE: 2010-05-20
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/loadermax/
 **/
package com.greensock.loading.display {
	import com.greensock.loading.display.core.ProgressDisplayMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
/**
 * This class is not finalized yet and is only intended for use in GreenSock demos. <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class ProgressCircleMax extends ProgressDisplayMax {
		protected var _ct:ColorTransform;
		protected var _blur:BlurFilter;
		
		public function ProgressCircleMax(vars:Object=null) {
			super(vars);
			_preloader = new ProgressCircleLite(this.vars);
			this.addChild(_preloader);
			_autoUpdate = Boolean(this.vars.autoUpdate != false);
			var blur:Number = ("bgBlur" in this.vars) ? Number(this.vars.bgBlur) : 10;
			_blur = new BlurFilter(blur, blur, 2);
			_transparent = Boolean(blur == 0);
			var brightness:Number = ("bgBrightness" in this.vars) ? Number(this.vars.bgBrightness) : 0.8;
			_ct = new ColorTransform(brightness, brightness, brightness, 1, 0, 0, 0, 0);
		}
		
		override protected function _updateBitmap(event:Event=null):void {
			if (_blur.blurX == 0) {
				super._updateBitmap(event);
			} else {
				this.visible = false;
				_matrix.tx = -_stageBounds.x;
				_matrix.ty = -_stageBounds.y;
				_bd.fillRect(_bd.rect, _bgColor);
				_bd.draw(_stage, _matrix);
				_bd.applyFilter(_bd, _bd.rect, _point, _blur);
				_bd.colorTransform(_bd.rect, _ct);
				_bitmap.x = -this.x + _stageBounds.x;
				_bitmap.y = -this.y + _stageBounds.y;
				this.visible = true;
			}
		}
		
		override protected function _addStandardListeners():void {
			if (_autoUpdate) {
				this.addEventListener(Event.ENTER_FRAME, _updateBitmap, false, -10, true);
			}
			super._addStandardListeners();
		}
		
		override protected function _removeStandardListeners():void {
			this.removeEventListener(Event.ENTER_FRAME, _updateBitmap);
			super._removeStandardListeners();
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		override public function updatePosition(event:Event=null):void {
			super.updatePosition(event);
			if (_bitmap) {
				_createBitmap(null);
			}
		}
		
		override protected function _completeHandler(event:Event):void {
			if (_bitmap) {
				_createBitmap();
			}
			super._completeHandler(event);
		}
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		
	}
}