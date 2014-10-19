package com.plode.framework.managers
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.utils.Dictionary;

	/*
	 * 
	 * USAGE: LOAD FONT SWFS SO THEY ARE ACCESSIBLE IN THE APPLICATION DOMAIN VIA CSS
	 * 
	 */
	public class FontManager extends EventDispatcher
	{
		private static var _instance : FontManager;
		private var _fonts : Dictionary;
		
		
		public function FontManager(e : FontManagerEnforcer)
		{
		}
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function add(id : String, font : MovieClip) : void
		{
			if(!_fonts) _fonts = new Dictionary();
			if(_fonts[id] == null)
			{
				_fonts[id] = font;
			}
			else new Error('THIS FONT HAS ALREADY BEEN ADDED');

			traceLoadedFonts();
		}
		
		private function traceLoadedFonts() : void
		{
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			for (var i:String in embeddedFonts)
			{
				trace('FontManager:', embeddedFonts[i].fontName);
			}		
		}
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		public static function get gi() : FontManager
		{
			if(!_instance) _instance = new FontManager(new FontManagerEnforcer());
			return _instance;
		}
	

	}
}

class FontManagerEnforcer{}