package com.jordan.cp.media.events {
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SimpleStreamingEvent 
	extends Event 
	{
		public static const VIDEO_COMPLETE : String = new String( "videoComplete" );
		public static const VIDEO_READY : String = new String( "videoReady" );
		public static const VIDEO_PLAY_PAUSE : String = new String( "videoPlayPause" );
		public static const VIDEO_SCRUB_START : String = new String( "videoScrubStart" );
		public static const VIDEO_SCRUB_END : String = new String( "videoScrubEnd" );

		public function SimpleStreamingEvent ( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}	
	}
}