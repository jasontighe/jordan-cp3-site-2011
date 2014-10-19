package com.jordan.cp.media {
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author jason.tighe
	 */    
	
	public class NetConnectionExample 
	extends Sprite 
	{
        private var videoURL:String;
        private var connection:NetConnection;
        private var stream:NetStream;

        public function NetConnectionExample( url : String ) 
        {
			trace( "NETCONNECTION : Constr : url is "+url );
			
			videoURL = url;
            connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
        }

        private function netStatusHandler(event:NetStatusEvent):void 
        {
			trace( "NETCONNECTION : netStatusHandler() : event.info.code is "+event.info.code );
            switch (event.info.code) 
            {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + videoURL);
                    break;
            }
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void 
        {
            trace("NETCONNECTION : securityErrorHandler() : " + event);
        }

        private function connectStream():void 
        {
			trace( "NETCONNECTION : connectStream()" );
            var stream:NetStream = new NetStream(connection);
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.client = new CustomClient();
            var video:Video = new Video();
            video.attachNetStream(stream);
            stream.play(videoURL);
            addChild(video);
        }
    }
}
