package com.iabel.system {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class FPS extends Sprite {
		private var currentY:int;
		private var diagramTimer:int;
		private var tfTimer:int;
		private var diagram:BitmapData;
		private var mem:TextField;
		private var fps:TextField;
		private var tfDelay:int = 0;
		static private const maxMemory:uint = 4.1943e+007;
		static private const diagramWidth:uint = 60;
		static private const tfDelayMax:int = 10;
		static private var instance:FPS;
		static private const diagramHeight:uint = 40;
		public function FPS():void {
			this.addEventListener(Event.ADDED_TO_STAGE,run);
		}
		
		private function run(e:Event):void {
			if (instance == null) {
				instance=this;
				fps = new TextField();
				mem = new TextField();
				this.mouseEnabled = false;
				this.mouseChildren = false;
				fps.defaultTextFormat = new TextFormat("Tahoma", 10, 13421772);
				fps.autoSize = TextFieldAutoSize.LEFT;
				fps.text = "FPS: " + Number(stage.frameRate).toFixed(2);
				fps.selectable = false;
				fps.x = -diagramWidth - 2;
				addChild(fps);
				mem.defaultTextFormat = new TextFormat("Tahoma", 10, 13421568);
				mem.autoSize = TextFieldAutoSize.LEFT;
				mem.text = "MEM: " + bytesToString(System.totalMemory);
				mem.selectable = false;
				mem.x = -diagramWidth - 2;
				mem.y = 10;
				addChild(mem);
				currentY = 20;
				diagram = new BitmapData(diagramWidth, diagramHeight, true, 0x20ffff00);
				var _loc_2:Bitmap = new Bitmap(diagram);
				_loc_2.y = currentY + 4;
				_loc_2.x = -diagramWidth;
				addChildAt(_loc_2, 0);
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.stage.addEventListener(Event.RESIZE, onResize);
				onResize();
				diagramTimer = getTimer();
				tfTimer = getTimer();
			}
		}
		private function bytesToString(memory:uint):String {
			var _str:String;
			if (memory < 1024) {
				_str = String(memory) + "b";
			} else if (memory < 10240) {
				_str = Number(memory / 1024).toFixed(2) + "kb";
			} else if (memory < 102400) {
				_str = Number(memory / 1024).toFixed(1) + "kb";
			} else if (memory < 1048576) {
				_str =int(memory / 1024) + "kb";
			} else if (memory < 10485760) {
				_str = Number(memory / 1048576).toFixed(2) + "mb";
			} else if (memory < 104857600) {
				_str = Number(memory / 1048576).toFixed(1) + "mb";
			} else {
				_str = int(memory / 1048576) + "mb";
			}
			return _str;
		}
		
		private function onEnterFrame(e:Event):void {
			tfDelay++;
			if (tfDelay >= tfDelayMax) {
				tfDelay = 0;
				fps.text = "FPS: " + Number(1000 * tfDelayMax / (getTimer() - tfTimer)).toFixed(2);
				tfTimer = getTimer();
			}
			var _loc_2:* = 1000 / (getTimer() - diagramTimer);
			var _loc_3:* = _loc_2 > stage.frameRate ? (1) : (_loc_2 / stage.frameRate);
			diagramTimer = getTimer();
			diagram.scroll(1, 0);
			diagram.fillRect(new Rectangle(0, 0, 1, diagramHeight), 0x20ffff00);
			diagram.setPixel32(0, diagramHeight * (1 - _loc_3), 0xffcccccc);
			mem.text = "MEM: " + bytesToString(System.totalMemory);
			var _loc_5:Number = System.totalMemory / maxMemory;
			diagram.setPixel32(0, diagramHeight * (1 - _loc_5), 0xffff6600);
		}
		private function onResize(e:Event = null):void {
			var _point:Point = parent.globalToLocal(new Point(80, 90));//stage.stageWidth 
			this.x = _point.x;
			this.y = _point.y;
		}
	}
}