package com.jordan.cp.view.menu_lower.events {
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class NavEvent 
	extends Event 
	{
		public static const INTERACTING : String = new String( "interacting" );

		public function NavEvent ( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}	
	}
}