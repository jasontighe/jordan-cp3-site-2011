package com.plode.framework.players 
{
	import flash.events.EventDispatcher;

	/**
	 * @author nelson.shin
	 */

	public class VideoClient extends EventDispatcher
	{

		public var infoObject : Object;

		public function onMetaData(info : Object) : void 
		{
			infoObject = info;

			//			for( var key : Object in o)
			//			{
			//				trace('key: ' + (key));
			//			}

			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
		}

		public function onSeekPoint(info : Object) : void 
		{
			//			for( var key : Object in o)
			//			{
			//				trace('key: ' + (key));
			//			}

			trace("seekpoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}

		public function onPlayStatus(info : Object) : void 
		{
			//			for( var key : Object in o)
			//			{
			//				trace('key: ' + (key));
			//			}

			trace("onplaystatus: time=");
		}

		public function onCuePoint(info : Object) : void 
		{
			//			for( var key : Object in o)
			//			{
			//				trace('key: ' + (key));
			//			}

			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
	}
}
