package com.jordan.cp.view.summary.events {
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummaryEvent 
	extends Event 
	{
		public static const SCENE_CLICK : String = new String( "sceneClick" );
		public static const CONTENT_CLICK : String = new String( "contentClick" );

		public function SummaryEvent ( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}	
	}
}