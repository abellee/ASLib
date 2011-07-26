package com.iabel.container
{
	import com.iabel.data.Collections.GradientData;
	import com.iabel.data.Collections.RectRoundRaduis;
	import com.iabel.data.Collections.Size;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import com.iabel.core.UIComponent;
	
	public class BorderContainer extends UIComponent
	{
		
		protected var _backgroundImage:BackgroundContainer = null;
		
		protected var _backgroundColor:Number = 0xFFFFFF;
		protected var _backgroundAlpha:Number = 1.0;
		
		protected var _borderWidth:Number = 0;
		protected var _borderColor:Number = 0;
		
		protected var _borderVisible:Boolean = false;
		protected var _clipContent:Boolean = false;
		
		protected var _backgroundFillMode:String = null;
		
		protected var _rectRoundRadius:RectRoundRaduis = null;
		protected var _gradientData:GradientData = null;
		
		protected static const INVALIDATION_TYPE_BACKGROUND_IMAGE:String = "invalidation_type_background_image";
		protected static const INVALIDATION_TYPE_GRADIENT:String = "invalidation_type_gradient";
		protected static const INVALIDATION_TYPE_CLIPCONTENT:String = "invalidation_type_clipcontent";
		
		public function BorderContainer()
		{
			super();
		}
		
		public function get gradientData():GradientData
		{
			return _gradientData;
		}

		public function set gradientData(value:GradientData):void
		{
			_gradientData = value;
			
			callLater(INVALIDATION_TYPE_GRADIENT, drawGradienBackground);
		}

		public function get rectRoundRadius():RectRoundRaduis
		{
			return _rectRoundRadius;
		}

		public function set rectRoundRadius(value:RectRoundRaduis):void
		{
			_rectRoundRadius = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}

		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}

		public function get borderVisible():Boolean
		{
			return _borderVisible;
		}

		public function set borderVisible(value:Boolean):void
		{
			_borderVisible = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}

		public function get borderColor():Number
		{
			return _borderColor;
		}

		public function set borderColor(value:Number):void
		{
			_borderColor = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}

		public function get borderWidth():Number
		{
			return _borderWidth;
		}

		public function set borderWidth(value:Number):void
		{
			_borderWidth = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}

		public function get cornerRadius():Number
		{
			if(!_rectRoundRadius) return 0;
			return _rectRoundRadius.topLeftRadius;
		}

		public function set cornerRadius(value:Number):void
		{
			_rectRoundRadius = new RectRoundRaduis();
			_rectRoundRadius.topLeftRadius = value;
			_rectRoundRadius.topRightRadius = value;
			_rectRoundRadius.bottomLeftRadius = value;
			_rectRoundRadius.bottomRightRadius = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}

		public function get backgroundFillMode():String
		{
			return _backgroundFillMode;
		}

		public function set backgroundFillMode(value:String):void
		{
			_backgroundFillMode = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND_IMAGE, drawBackgroundImage);
		}

		public function set clipContent(bool:Boolean):void
		{
			if(!_clipContent && _clipContent == bool) return;
			
			_clipContent = bool;
			
			callLater(INVALIDATION_TYPE_CLIPCONTENT, contentClip);
		}
		
		public function get clipContent():Boolean
		{
			return _clipContent;
		}
		
		public function set backgroundColor(value:Number):void
		{
			this._backgroundColor = value;
			
			callLater(INVALIDATION_TYPE_BACKGROUND, drawBackground);
		}
		
		public function get backgroundColor():Number
		{
			return this._backgroundColor;
		}
		
		public function set backgroundImage(o:DisplayObject):void
		{
			this._backgroundAlpha = 0;
			
			if(!this._backgroundImage) this._backgroundImage = new BackgroundContainer();
			this._backgroundImage.backgroundImage = o;
			
			callLater(INVALIDATION_TYPE_BACKGROUND_IMAGE, drawBackgroundImage);
		}
		
		public function get backgroundImage():DisplayObject
		{
			if(!this._backgroundImage) return null;
			return this._backgroundImage.backgroundImage;
		}
		
		/******************************************************************************************************/
		/******************************************************************************************************/
		
		/************************************** all protected functions ***************************************/
		
		/******************************************************************************************************/
		/******************************************************************************************************/
		
		protected function drawBackgroundImage():void
		{
			if(!this._backgroundImage) throw new IllegalOperationError("IllegalOperationError: backgroundImage is null!\n at function: drawBackgroundImage");
			if(!_backgroundFillMode) _backgroundFillMode = BackgroundImageFillMode.REPEAT;
			this._backgroundImage.fillBackground(new Size(this.explicitWidth, this.explicitHeight), _backgroundFillMode);
			addChildAt(this._backgroundImage, 0);
		}
		
		protected function drawGradienBackground():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(this.borderWidth, this.borderColor, uint(this.borderVisible));
			this.graphics.beginGradientFill(gradientData.type, gradientData.colors, gradientData.alphas, gradientData.ratios, gradientData.matrix,
				gradientData.spreadMethod, gradientData.interpolationMethod, gradientData.focalPointRatio);
			
			drawRoundRectBackground();
		}
		
		override protected function drawBackground():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(this.borderWidth, this.borderColor, uint(this.borderVisible));
			this.graphics.beginFill(this._backgroundColor, this._backgroundAlpha);
			
			drawRoundRectBackground();
		}
		
		protected function drawRoundRectBackground():void
		{
			if(!rectRoundRadius) return;
			this.graphics.drawRoundRectComplex(0, 0, this.explicitWidth, this.explicitHeight, rectRoundRadius.topLeftRadius, rectRoundRadius.topRightRadius,
				rectRoundRadius.bottomLeftRadius, rectRoundRadius.bottomRightRadius);
			this.graphics.endFill();
		}
		
		protected function contentClip():void
		{
			if(this._clipContent) this.scrollRect = new Rectangle(0, 0, this.explicitWidth, this.explicitHeight);	
			else this.scrollRect = null;
		}
		
		override protected function callLater(type:String, func:Function):void
		{
			super.callLater(type, func);
			
			if(type == INVALIDATION_TYPE_BACKGROUND_IMAGE && _callLaterList[INVALIDATION_TYPE_GRADIENT]) delete _callLaterList[INVALIDATION_TYPE_GRADIENT];
			if((type == INVALIDATION_TYPE_GRADIENT && _callLaterList[INVALIDATION_TYPE_BACKGROUND])
				|| (type == INVALIDATION_TYPE_BACKGROUND && _callLaterList[INVALIDATION_TYPE_GRADIENT])) delete _callLaterList[INVALIDATION_TYPE_BACKGROUND];
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(this.contains(_backgroundImage)){
				
				this.removeChild(_backgroundImage);
				_backgroundImage = null;
				
			}
			_backgroundFillMode = null;
			_rectRoundRadius = null;
			if(_gradientData){
				
				_gradientData.dealloc();
				_gradientData = null;
				
			}
		}
	}
}