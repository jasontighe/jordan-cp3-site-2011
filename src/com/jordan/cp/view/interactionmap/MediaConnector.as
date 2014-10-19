package com.jordan.cp.view.interactionmap 
{
	import com.adobe.serialization.json.JSON;
	import com.jordan.cp.constants.Tokens;
	import com.jordan.cp.managers.ConnectionErrorManager;
	import com.jordan.cp.model.VideoModel;
	import com.plode.framework.events.ParamEvent;

	import mx.collections.ArrayCollection;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;

	/**
	 * @author nelson.shin
	 */
	public class MediaConnector extends EventDispatcher 
	{
		private var _nc : NetConnection;
		private var _m : VideoModel;
		private var _hdCollection : ArrayCollection;
		private var _ldCollection : ArrayCollection;
//		private var _t : Timer;
		
//		private static const TIMER_DELAY : uint = 10000;
		public static const CONNECTION_ESTABLISHED : String = "CONNECTION_ESTABLISHED";


		
		//-------------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//-------------------------------------------------------------------------
		public function authenticate() : void 
		{	
			// SAMPLE URL
			// http://api.brightcove.com/services/library?command=find_playlist_by_id&playlist_id={PLAYLIST_ID}&token={TOKEN}

			_m = new VideoModel();

			// HD
			var variables : URLVariables = new URLVariables();
			variables.token = Tokens.BLAST_READ_URL_ACCESS;
			variables.command = Tokens.PARAM_PLAYLIST_BY_ID;
			variables.playlist_id = Tokens.BLAST_ID_HD;

			var request : URLRequest = new URLRequest(Tokens.SERVICE_URL);
			request.method = URLRequestMethod.GET;
			request.data = variables;

			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onHdVideoDataLoaded);
			loader.load(request);


			// LD
			var variablesLD : URLVariables = new URLVariables();
			variablesLD.token = Tokens.BLAST_READ_URL_ACCESS;
			variablesLD.command = Tokens.PARAM_PLAYLIST_BY_ID;
			variablesLD.playlist_id = Tokens.BLAST_ID_LD;

			var requestLD : URLRequest = new URLRequest(Tokens.SERVICE_URL);
			requestLD.method = URLRequestMethod.GET;
			requestLD.data = variablesLD;

			var loaderLD : URLLoader = new URLLoader();
			loaderLD.dataFormat = URLLoaderDataFormat.TEXT;
			loaderLD.addEventListener(Event.COMPLETE, onLdVideoDataLoaded);
			loaderLD.load(requestLD);
		}
		
		
		//-------------------------------------------------------------------------
		//
		// PRIVATE METHODS
		//
		//-------------------------------------------------------------------------
		private function connect() : void 
		{
			// CHOP UP FLVURL INTO NETCONNECTION AUTH STRING & VIDEO ASSET NAME
			var url : String = _m.sampleDTO.flvUrl;
			url = url.substring(0, url.indexOf('&'));

			// SETUP SHARED NETCONNECTION INSTANCE
			if(!_nc)
			{
				_nc = new NetConnection();
				_nc.client = this;
				_nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
				_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);

//				trace('\n\n\n\n\n\n----------------------------------------------------------');
//				trace("MediaConnector.connect() : _nc.maxPeerConnections:", _nc.maxPeerConnections);
//				trace('----------------------------------------------------------\n\n\n\n\n\n');
			}

			_nc.connect(url);
//			startTimer();
		}
		
//		private function startTimer() : void
//		{
//			if(!_t) _t = new Timer(TIMER_DELAY);
//			if(!_t.hasEventListener(TimerEvent.TIMER)) _t.addEventListener(TimerEvent.TIMER, onTimer);
//			
//			_t.start();
//		}
//		
//		private function stopTimer() : void
//		{
//			if(_t)
//			{
//				_t.stop();
//				_t.removeEventListener(TimerEvent.TIMER, onTimer);
//			}
//		}
//		
//		private function onTimer(e : TimerEvent) : void
//		{
//			stopTimer();
////			reset(true);
//			
//			// DISPLAY ERROR MESSAGE
//			trace('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n----------------------------------------------------------');
//			trace("MediaConnector.onTimer(e) : NETCONNECTION ATTEMPT TIMED OUT");
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
//			
////			ConnectionErrorManager.gi.showError();
//		}				


		
		//-------------------------------------------------------------------------
		//
		// HANDLERS
		//
		//-------------------------------------------------------------------------
		private function onHdVideoDataLoaded(e : Event) : void 
		{
			//Get the returned JSON data string
			var response : String = e.target.data as String;
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("MediaConnector.onVideoDataLoaded(e) : response:", this, (response));
						
			var container : Object = (JSON.decode(response) as Object);
			//create a new ArrayCollection passing the de-serialized Array
			//ArrayCollections work better as DataProviders, as they can
			//be watched for changes.
			_hdCollection = new ArrayCollection(container.videos);
			_m.addToArray(_hdCollection);

			checkLoads();
		}

		private function onLdVideoDataLoaded(e : Event) : void 
		{
			var response : String = e.target.data as String;
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("MediaConnector.onLdVideoDataLoaded(e) : response:", this, (response));
						
			var container : Object = (JSON.decode(response) as Object);
			_ldCollection = new ArrayCollection(container.videos);
			_m.addToArray(_ldCollection);
			
			checkLoads();
		}

		private function checkLoads() : void 
		{
			if(_hdCollection && _ldCollection)
			{
				_m.organize();
				connect();
			}
		}
		
		private function onStatus(e : NetStatusEvent) : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("MediaConnector.onStatus(e)", e.info.code, e.target);
			var code : String = e.info.code;
            
            // JUST HERE TO TRACE TO TEXTFIELD IN CHILD
//            dispatchEvent(new ParamEvent('mc_status', {code : code}));
            
			switch(code)
			{			
				case "NetConnection.Connect.Success":
//					trace("MediaConnector.NetConnection.connection", e.info);
//					_nc.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
//					_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
					_m.nc = _nc;
					
					// BANDWIDTH DETECTION
					_nc.call('checkBandwidth', null);
					
//					stopTimer();
					dispatchEvent(new Event(CONNECTION_ESTABLISHED));
					break;
			}
		} 	
		
		private function asyncErrorHandler(e : AsyncErrorEvent) : void 
		{
			trace("asyncErrorHandler: " + e);
		}		



		//-------------------------------------------------------------------------
		//
		// FMS CALLBACK EVENTS
		//
		//-------------------------------------------------------------------------
		public function onBWCheck( ... rest ) : Number 
		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("MediaConnector.onBWCheck(rest)", rest);
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
			return 0;
		}
		
		public function onBWDone( ... rest ) : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("MediaConnector.onBWDone(rest)", rest.length);

			// Create a local bandwidth variable
			var bitrate : Number;
			
			// Get the bandwidth value from the rest array
			bitrate = rest[0];
			trace('rest: ' + (rest));
			trace('bitrate: ' + (bitrate));
			
			// Dispatch an event and pass the bandwidth value 
			dispatchEvent(new ParamEvent('bandwdithReceived', {rate: bitrate}));
		}

		public function close() : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("MediaConnector.close()");
			trace('WHY IS NET CONNECTION CALLING "CLOSE"?');
		}
		
		public function reset(hard : Boolean = false) : void
		{
			if(hard)
			{
				// DISPOSE OF NC INSTANCE FIRST
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
				_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_nc.close();
				_nc = null;
			}
		}


					
		//-------------------------------------------------------------------------
		//
		// GETTERS / SETTERS
		//
		//-------------------------------------------------------------------------
		public function get videoModel() : VideoModel 
		{
			return _m;
		}
	
	
	
	}
}
