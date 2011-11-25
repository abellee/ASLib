package com.kge.controls {
	import flash.display.Shape;

	import fl.controls.Button;

	import com.kge.core.UIView;
	import com.kge.delegates.IAlert;

	import flash.errors.IllegalOperationError;

	/**
	 * 提示/确认框类。
	 * 使用单例模式取得实例。
	 * @author Abel
	 */
	public class Alert extends UIView {
		/**
		 * 实例
		 */
		private static var _instance : Alert = new Alert();
		/**
		 * 代理
		 */
		public var alertDelegate : IAlert;
		/**
		 * 按钮选项
		 */
		private var _option : int = 1;
		/**
		 * 确定按钮
		 */
		private var _yesButton : Button = null;
		/**
		 * 取消按钮
		 */
		private var _noButton : Button = null;
		/**
		 * 确定按钮的label
		 */
		private var _yesLabel : String = "确定";
		/**
		 * 取消按钮的label
		 */
		private var _noLabel : String = "取消";
		/**
		 * 标题label
		 */
		private var _title : String = "";
		/**
		 * 提示文字
		 */
		private var _text : String = "";
		/**
		 * 是否显示暗色背景
		 */
		private var _model : Boolean = false;
		/**
		 * 遮罩背景
		 */
		private var _background : Shape = null;

		/**
		 * 请使用instance取得实例。
		 */
		public function Alert() {
			super();
			if (Object(this).constructor == Alert) {
				throw new IllegalOperationError("You can't instance this class directly!");
				return;
			}
			_changed = true;
		}

		/**
		 * 取得一个Alert实例。
		 */
		public static function get instance() : Alert {
			return _instance;
		}

		override protected function doChange() : void {
			init();
			super.doChange();
		}

		/**
		 * 初始化界面
		 */
		private function init() : void {
			// initialize user interface
			trace("init");
		}

		override public function rebuild() : void {
			super.rebuild();
		}

		override public function dealloc() : void {
			super.dealloc();
		}

		/**
		 * 取得当前按钮选项
		 */
		public function get option() : int {
			return _option;
		}

		/**
		 * 设置当前按钮选项
		 * AlertOption.YES: 只显示确定按钮
		 * AlertOption.NO: 只显示取消按钮
		 * AlertOption.YES | AlertOption.NO: 同时显示确定与取消按钮
		 */
		public function set option(option : int) : void {
			if (_option != option) {
				trace("set option");
				_option = option;
				hasChanged();
			}
		}

		/**
		 * 取得当前确定按钮的label
		 */
		public function get yesLabel() : String {
			return _yesLabel;
		}

		/**
		 * 设置当前确定按钮的label
		 */
		public function set yesLabel(yesLabel : String) : void {
			if (_yesLabel != yesLabel) {
				trace("set yesLabel");
				_yesLabel = yesLabel;
				hasChanged();
			}
		}

		/**
		 * 取得当前取消按钮的label
		 */
		public function get noLabel() : String {
			return _noLabel;
		}

		/**
		 * 设置当前取消按钮的label
		 */
		public function set noLabel(noLabel : String) : void {
			if (_noLabel != noLabel) {
				trace("set noLabel");
				_noLabel = noLabel;
				hasChanged();
			}
		}

		/**
		 * 取得当前标题的内容
		 */
		public function get title() : String {
			return _title;
		}

		/**
		 * 设置当前标题的内容
		 */
		public function set title(title : String) : void {
			if (_title != title) {
				trace("set title");
				_title = title;
				hasChanged();
			}
		}

		/**
		 * 取得当前的提示内容
		 */
		public function get text() : String {
			return _text;
		}

		/**
		 * 设置当前的提示内容
		 */
		public function set text(text : String) : void {
			if (_text != text) {
				trace("set text");
				_text = text;
				hasChanged();
			}
		}

		/**
		 * 取得当前是否拥有背景
		 */
		public function get model() : Boolean {
			return _model;
		}

		/**
		 * 设置当前是否拥有背景
		 */
		public function set model(model : Boolean) : void {
			if (_model != model) {
				trace("set model");
				_model = model;
				hasChanged();
			}
		}
	}
}
