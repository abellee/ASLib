package {
	import fl.controls.DataGrid;
	import fl.controls.CheckBox;
	import fl.controls.Button;
	import com.kge.containers.Group;
	import com.kge.containers.LayoutForm;
	import com.kge.controls.Alert;
	import com.kge.controls.AlertOption;
	import flash.display.Sprite;
	import flash.events.Event;

	
	public class UILib extends Sprite
	{
		/**
		* 所有可视图形的基类
		* <code>
		* var uilb:UILib = new UILib();
		* </code>
		* @param num 传入数字
		* @see someOtherMethod
		*/
		public function UILib()
		{
			var alert:Alert = Alert.instance;
			addChild(alert);
			alert.option = AlertOption.YES | AlertOption.NO;
			var button:Button = new Button();
			button.mouseChildren = false;
			addChild(button);
			var checkbox:CheckBox = new CheckBox();
			checkbox.mouseChildren = false;
			checkbox.setStyle("downSkin", getSprite());
			addChild(checkbox);
			checkbox.x = 200;
			var dg:DataGrid = new DataGrid();
			dg.setStyle("skin", getSprite());
			addChild(dg);
		}
		
		private function getSprite():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(Math.random() * 0xFFFFFF);
			sp.graphics.drawRect(0, 0, 100, 30);
			sp.graphics.endFill();
			return sp;
		}

		private function onRemoved(event : Event) : void {
			trace("removed");
		}

		private function onRemovedFromStage(event : Event) : void {
			trace("removed from stage");
		}
	}
}