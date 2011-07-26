package com.iabel.data.Collections
{
	import flash.geom.Matrix;

	public class GradientData
	{
		protected var _type:String;
		protected var _colors:Array;
		protected var _alphas:Array;
		protected var _ratios:Array;
		protected var _matrix:Matrix = null;
		protected var _spreadMethod:String = "pad";
		protected var _interpolationMethod:String = "rgb";
		protected var _focalPointRatio:Number = 0;
		public function GradientData()
		{
		}

		public function get focalPointRatio():Number
		{
			return _focalPointRatio;
		}

		public function set focalPointRatio(value:Number):void
		{
			_focalPointRatio = value;
		}

		public function get interpolationMethod():String
		{
			return _interpolationMethod;
		}

		public function set interpolationMethod(value:String):void
		{
			_interpolationMethod = value;
		}

		public function get spreadMethod():String
		{
			return _spreadMethod;
		}

		public function set spreadMethod(value:String):void
		{
			_spreadMethod = value;
		}

		public function get matrix():Matrix
		{
			return _matrix;
		}

		public function set matrix(value:Matrix):void
		{
			_matrix = value;
		}

		public function get ratios():Array
		{
			return _ratios;
		}

		public function set ratios(value:Array):void
		{
			_ratios = value;
		}

		public function get alphas():Array
		{
			return _alphas;
		}

		public function set alphas(value:Array):void
		{
			_alphas = value;
		}

		public function get colors():Array
		{
			return _colors;
		}

		public function set colors(value:Array):void
		{
			_colors = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function dealloc():void
		{
			_type = null;
			_colors = null;
			_alphas = null;
			_ratios = null;
			_matrix = null;
			_spreadMethod = null;
			_interpolationMethod = null;
		}

	}
}