package com.jordan.cp.view.interactionmap 
{
	import flash.display.Sprite;

	/**
	 * @author nelson.shin
	 */
	public class GridBox extends Sprite 
	{
		public var id : String;
		private var _box : Sprite;
		private var _stroke : Sprite;
		private var _w : uint;
		private var _h : uint;

		public function GridBox(w : uint, h : uint) 
		{
			_w = w;
			_h = Math.round(_w * ratio);
			setup();
		}

		public function showOver() : void
		{
			_box.alpha = 1;
			_stroke.visible = true;
		}

		public function showOut() : void
		{
			_box.alpha = .5;
			_stroke.visible = false;
		}

		private function setup() : void 
		{
			_box = new Sprite();
			_box.graphics.beginFill(Math.round(Math.random() * 0xFFFFFF), Math.random());
			_box.graphics.drawRect(0, 0, _w, _h);

			_stroke = new Sprite();
			_stroke.graphics.lineStyle(4, 0x000000);
			_stroke.graphics.drawRect(4, 4, _w-8, _h-8);

			addChild(_box);
			addChild(_stroke);
			showOut();
		}


		public static function get ratio() : Number
		{
			// h/w of video
			return 462 / 922;
		}



	}
}
