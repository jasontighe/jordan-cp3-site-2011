package com.plode.framework.utils
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenu;
	/**
	 * @author agorskiy
	 */
	public class RightClickVersion
	{
		private var version_menu:ContextMenu;
		private var version_menu_item:ContextMenuItem;
		
		public function RightClickVersion(theThis:MovieClip, str:String)
		{
			version_menu = new ContextMenu();
			version_menu_item = new ContextMenuItem(""+str);
			
			version_menu.hideBuiltInItems();
			version_menu.customItems.push(version_menu_item);
			
			theThis.contextMenu = version_menu;
		}
		
	}
}
