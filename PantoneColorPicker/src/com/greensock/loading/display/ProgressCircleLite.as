/**
 * VERSION: 0.5
 * DATE: 2010-05-20
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/loadermax/
 **/
package com.greensock.loading.display {
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Quad;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.core.ProgressDisplayLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	
/**
 * This class is not finalized yet and is only intended for use in GreenSock demos. <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class ProgressCircleLite extends ProgressDisplayLite {
		protected var _circle:CircleDisplay;
		protected var _pulse:TweenLite;
		
		public function ProgressCircleLite(vars:Object=null) {
			super(vars);
		}
		
		override protected function _init(event:Event):void {
			super._init(event);
			
			_circle = new CircleDisplay(this.vars);
			_circle.filters = [new GlowFilter(0x000000, 0.6, 12, 12, 1, 2)];
			addChild(_circle);
			
			_pulse = new TweenLite(_circle.progressRing, 0.8, {alpha:0.7, ease:Quad.easeInOut, onComplete:_invertTween, onReverseComplete:_invertTween});
			if (_mode != 2) {
				_pulse.pause();
			} else {
				_bringToFront(null);
			}
		}
		
		protected function _invertTween():void {
			_pulse.reversed = !_pulse.reversed;
			_pulse.resume();
		}
		
		override public function transitionIn():void {
			if (_mode < 1 && _initted) {
				super.transitionIn();
				_circle.circle.alpha = _circle.textField.alpha = 0;
				_circle.circle.scaleX = _circle.circle.scaleY = 3;
				_circle.textField.x = -99;
				_circle.textField.scaleX = _circle.textField.scaleY = 1;
				_circle.textField.width = 200;
				_circle.textField.y = _circle.yHome;
				TweenLite.to(_circle.circle, 0.5, {scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut, onComplete:_onTransitionInComplete, overwrite:true});
			}
		}
		
		override protected function _onTransitionInComplete():void {
			_pulse.resume();
			super._onTransitionInComplete();
		}
		
		override public function transitionOut():void {
			if (_mode > 0 && _initted) {
				_pulse.pause();
				super.transitionOut();
				TweenLite.to(_circle.textField, 0.35, {scaleX:0.01, scaleY:0.01, x:0, y:0, alpha:0, overwrite:true});
				TweenLite.to(_circle.circle, 0.35, {scaleX:0.01, scaleY:0.01, alpha:0, delay:0.1, onComplete:_onTransitionOutComplete, overwrite:true});
			}
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		override protected function _progressHandler(event:LoaderEvent):void {
			_progress = _calculateProgress();
			if (_circle != null) {
				TweenLite.to(_circle, this.smoothProgress, {progress:_progress, overwrite:true});
			}
		}
		
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		override public function set progress(value:Number):void {
			_progress = value;
			if (_circle != null) {
				_circle.progress = value;
			}
		}
		
	}
}
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

internal class CircleDisplay extends Sprite {
	protected static var _defaults:Object = {thickness:8, radius:38, color:0x91E600, trackColor:0x000000, trackAlpha:0.15, hideText:false, textColor:0xFFFFFF, textFormat:new TextFormat("Arial", 13, 0xFFFFFF, null, null, null, null, null, "center")};
	protected var _mask:Shape;
	protected var _config:Object;
	protected var _progress:Number = 0;
	
	public var yHome:Number;
	public var track:Shape;
	public var circle:Sprite;
	public var progressRing:Shape;
	public var textField:TextField;
	
	public function CircleDisplay(vars:Object) {
		super();
		_config = {};
		for (var p:String in _defaults) {
			_config[p] = (p in vars) ? vars[p] : _defaults[p];
		}
		_config.trackThickness = ("trackThickness" in vars) ? vars.trackThickness : _config.thickness + 4;
		this.textField = new TextField();
		this.textField.defaultTextFormat = _config.textFormat;
		this.textField.textColor = _config.textColor;
		this.textField.selectable = false;
		this.textField.width = 200;
		this.textField.x = -99;
		this.textField.y = yHome = int(_config.textFormat.size / -2) - 3;
		this.textField.autoSize = "center";
		if (_config.hideText != true) {
			this.addChild(this.textField);
		}
		this.mouseEnabled = false;
		this.mouseChildren = false;
		
		this.circle = new Sprite();
		this.addChild(this.circle);
		
		this.progressRing = new Shape();
		
		this.track = _createCircleShape(_config.radius, _config.trackColor, _config.trackAlpha, _config.trackThickness);
		this.circle.addChild(this.track);
		
		this.progressRing.blendMode = "layer";
		this.circle.addChild(this.progressRing);
		
		_mask = _createCircleShape(_config.radius, _config.color, 1, _config.thickness);
		_mask.cacheAsBitmap = this.progressRing.cacheAsBitmap = true;
		this.circle.addChild(_mask);
		this.progressRing.mask = _mask;
		
		this.progress = 0;
	}
	
	
	protected function _createCircleShape(radius:Number, color:uint, alpha:Number, thickness:Number):Shape {
		if (thickness < 0) {
			return new Shape();
		}
		var s:Shape = new Shape();
		s.graphics.lineStyle(thickness, color, alpha, true, "normal", CapsStyle.NONE);
		s.graphics.drawCircle(0, 0, radius);
		return s;
	}
	
	public function get progress():Number {
		return _progress;
	}
	
	public function set progress(value:Number):void {
		_progress = value;
		this.textField.text = int( _progress * 100 ) + "%";
		
		var angle:Number = (_progress * Math.PI * 2) - (Math.PI / 2);
		var r:Number = _config.radius + _config.thickness;
		var g:Graphics = this.progressRing.graphics;
		g.clear();
		g.beginFill(_config.color, 1);
		g.moveTo(0, 0);
		g.lineTo( Math.cos(angle) * r, Math.sin(angle) * r);
		if (angle > Math.PI) {
			g.lineTo(-r, -r);
		}
		if (angle > Math.PI / 2) {
			g.lineTo(-r, r);
		}
		if (angle > 0) {
			g.lineTo(r, r);
		}
		g.lineTo(r, -r);
		g.lineTo(0, -r);
		g.endFill();
	}
	
}
