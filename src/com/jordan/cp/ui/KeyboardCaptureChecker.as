package com.jordan.cp.ui 
{
	import com.jordan.cp.constants.SiteConstants;

	import flash.events.EventDispatcher;
	import flash.ui.Keyboard;

	/**
	 * @author nelson.shin
	 */
	public class KeyboardCaptureChecker extends EventDispatcher 
	{
		private var _konami : Array;
//		private var _vo : Array;

		public function KeyboardCaptureChecker()
		{
			setup();
		}

		private function setup() : void 
		{
			_konami = new Array();
			_konami.length = 10;
			
//			_vo = new Array();
//			_vo.length = 3;
		}

		public function checkCodes(keyCode : String) : String
		{
			var s : String = '';
			
			// UPDATE KONAMI ARRAY
			// - if you don't know the contra code...
			var konami : Array = [
				Keyboard.UP
				, Keyboard.UP
				, Keyboard.DOWN
				, Keyboard.DOWN
				, Keyboard.LEFT
				, Keyboard.RIGHT
				, Keyboard.LEFT
				, Keyboard.RIGHT
				, 66
				, 65];
			_konami.shift();
			_konami.push(keyCode);

			// UPDATE VO ARRAY
			// - 'CP3'
//			var vo : Array = [ 67, 80, 51 ];
//			_vo.shift();
//			_vo.push(keyCode);

			// CHECK AGAINST CODE ARRAYS
			if(_konami.toString() == konami.toString())
			{
				s = SiteConstants.EGG_KONAMI;
			}
//			else if(_vo.toString() == vo.toString())
//			{
//				s = SiteConstants.EGG_VO;
//			}
			

//			trace("___________________________________________");
//			trace('KONAMI');
//			trace("User Input:", _konami);
//			trace("Comared To:", konami);
//			trace("Is a match:", _konami.toString() == konami.toString());
//			trace('\nVO');
//			trace("User Input:", _vo);
//			trace("Comared To:", vo);
//			trace("Is a match:", _vo.toString() == vo.toString());
//			trace("___________________________________________");


			return s;
		}
	}
}
