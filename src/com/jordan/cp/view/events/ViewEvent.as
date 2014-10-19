package com.jordan.cp.view.events {
	import flash.events.Event;

	/**
	 * @author jsuntai
	 */
	public class ViewEvent 
	extends Event 
	{
		public static const BANDWIDTH_SELECTED			: String = new String( 'bandwidthSelected' );
		public static const ICONS_FINISHED				: String = new String( 'iconsFinished' );
		public static const START_EXPLORING				: String = new String( 'startExploring' );
		
		public function ViewEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
	}
}