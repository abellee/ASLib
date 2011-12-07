package com.kge.core {
	import com.kge.delegates.IUIViewController;
	/**
	 * UIView视图的控制类
	 * @author Abel
	 */
	public class UIViewController {
		/**
		 * @private
		 * 视图
		 */
		protected var _view : UIView;
		/**
		 * @private
		 */
		protected var _data : Data;
		
		/**
		 * 委托
		 */
		 public var delegate:IUIViewController;

		/**
		 * 创建一个新的UIViewController实例
		 */
		public function UIViewController() {
		}

		/**
		 * 获取视图
		 * @return 当前视图实例
		 */
		public function get view() : UIView {
			return _view;
		}

		/**
		 * 设置当前视图
		 * @param view 一个新的视图实例
		 */
		public function set view(view : UIView) : void {
			if (_view) {
				if (_view != view) {
					_view.dealloc();
				} else {
					return;
				}
			}
			_view = view;
		}

		/**
		 * 获取当前数据模型
		 * @return 当前数据模型
		 */
		public function get data() : Data {
			return _data;
		}

		/**
		 * 设置当前数据模型
		 * @param data 一个新的数据模型
		 */
		public function set data(data : Data) : void {
			if (_data) {
				if (_data != data) {
					_data.dealloc();
				} else {
					return;
				}
			}
			_data = data;
		}

		/**
		 * 用于重构当前实例
		 * 如果需要完全清楚该对象，以等待垃圾回收，请调用dealloc()。
		 * @see #dealloc()
		 */
		public function rebuild() : void {
			_view.rebuild();
			_data.rebuild();
			delegate = null;
		}

		/**
		 * 清除自身内部所有可能影响垃圾回收的数据、引入、事件监听等。
		 * 如果只是想对类内部数据进行重构，不需要重新创建实例，请调用rebuild()，并重新设置相关数据。
		 * @see #rebuild()
		 */
		public function dealloc() : void {
			_view.dealloc();
			_data.dealloc();
			_view = null;
			_data = null;
			delegate = null;
		}
	}
}
