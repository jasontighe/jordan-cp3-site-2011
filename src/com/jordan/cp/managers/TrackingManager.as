package com.jordan.cp.managers
{
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.tracking.TrackingObject;
	import com.omniture.ActionSource;

	import flash.display.Sprite;
	import flash.system.Capabilities;

	/**
	 * @author jsuntai
	 * http://issuu.com/carismarie/docs/omniture_flash_documentation
	 */
	public class TrackingManager 
	extends Sprite
	{
		protected static var _instance : TrackingManager;
		private var _metricsComp:ActionSource;
		private var _conf : TrackingObject;
		public var lastPageName:String;



		public function TrackingManager( se : SingletonEnforcer )
		{
			se;
			
			// THIS IS JUST CALLED WHEN NOT EXTERNALLY CONFIGURED
			initialize();
		}

		public static function get gi() : TrackingManager
		{
			if ( _instance == null ) _instance = new TrackingManager( new SingletonEnforcer( ) );
			return _instance;
		}

		public function initialize() : void
		{
			// CONFIG OBJECT - CURRENTLY HOLDS CONSTANTS FOR THIS PROJECT
			_conf = new TrackingObject();

			this._metricsComp = new ActionSource();
			/* Specify the Report Suite ID(s) to track here */
			this._metricsComp.account = _conf.suiteID;
			
			/* You may add or alter any code config here */
			this._metricsComp.pageName = "";
			this._metricsComp.pageURL = "";
			
			this._metricsComp.campaign = _conf.campaign;
			
			this._metricsComp.prop2 = Capabilities.version.replace(/[A-Z]*\s/,"").split(",").join("."); // flash version
			this._metricsComp.prop12 = "j23"; // category
			this._metricsComp.prop13 = _conf.region; // region
			this._metricsComp.prop14 = _conf.country; // country/sub-region
			this._metricsComp.prop15 = _conf.language; // Language
			this._metricsComp.prop21 = "brand"; // division
			this._metricsComp.prop23 = "";
			this._metricsComp.prop27 = _conf.region + "|" + _conf.country + "|" + _conf.language; //locale
			this._metricsComp.prop28 = this._metricsComp.campaign;
			
			this._metricsComp.eVar4 = 'no action';//MetricsSubmissionVO.LS_NO_ACTION; // logged in status		
			this._metricsComp.eVar6 = _conf.siteSrc; // referral source
			this._metricsComp.eVar8 = this._metricsComp.prop27; // locale
			
			this._metricsComp.charSet = "UTF-8";
			this._metricsComp.currencyCode = "USD";
			
			/* Turn on and configure ClickMap tracking here */
//			this._metricsComp.trackClickMap = true;
//			this._metricsComp.movieID = "";
//			
//			
//			this._metricsComp.Media.autoTrack=false;
//			this._metricsComp.Media.trackWhilePlaying=true;
//			/*This will send an additional server call at 25, 50, and 75% complete. */
//			this._metricsComp.Media.trackMilestones="25,50,75";//Use ONLY trackSeconds OR trackMilestons. Never both	
			
			/* Turn on and configure debugging here */
			this._metricsComp.debugTracking = false;
			this._metricsComp.trackLocal = true;
			
			/* WARNING: Changing any of the below variables will cause drastic changes
			to how your visitor data is collected.  Changes should only be made
			when instructed to do so by your account manager.*/
			this._metricsComp.trackingServer = TrackingConstants.TRACKING_SERVER;
		}
		
		public function trackPage(s : String):void
		{
			trace( "TRACKINGMANAGER : trackPage() : " + s );

			this._metricsComp.pageName = TrackingConstants.PREPEND + s; // s?
			this._metricsComp.pageURL = ""; // blank?

			var trackingObject : Object = getTrackingObject(s);

			// check profile model for logged in state //
			this._metricsComp.track(trackingObject);
			this._metricsComp.campaign = null;
			this.lastPageName = trackingObject.pageName;
		}

		public function trackCustom(s : String):void
		{
			trace( "TRACKINGMANAGER : trackCustom() : " + s );

			this._metricsComp.pageURL = ""; // blank?

			// check profile model for logged in state //
			this._metricsComp.trackLink(_metricsComp.pageURL, 'o', s);
			this._metricsComp.campaign = null;
		}

		private function getTrackingObject(s : String) : Object 
		{
			var objToSend:Object = _conf.getObject();
			objToSend.pageName = s; //this._metricsComp.prop13 + "J23:" + objToSend.pageName;
			objToSend.prop2 = this._metricsComp.prop2;
			objToSend.prop12 = this._metricsComp.prop12;
			objToSend.prop13 = this._metricsComp.prop13;
			objToSend.prop14 = this._metricsComp.prop14;
			objToSend.prop15 = this._metricsComp.prop15;
			objToSend.prop21 = this._metricsComp.prop21;
			objToSend.prop27 = this._metricsComp.prop27;
			
			objToSend.eVar4 = this._metricsComp.eVar4;
			objToSend.eVar6 = this._metricsComp.eVar6;
			objToSend.eVar8 = this._metricsComp.eVar8;
			
			return objToSend;
		}
		
//		public function trackUpmRegisterEvent():void 
//		{
//			this._metricsComp.eVar21 = this.lastPageName;	
//			this._metricsComp.events = 'event1';
//			this._metricsComp.eVar4 = MetricsSubmissionVO.LS_LOGGED_IN;
//			this._metricsComp.trackLink('', 'o', /*this._metricsComp.prop13 + "J23:" + */this.lastPageName);	
//			this._metricsComp.events = '';				
//		}
//		
//		public function trackUpmLoginEvent():void 
//		{
//			this._metricsComp.events = 'event5';
//			this._metricsComp.eVar4 = MetricsSubmissionVO.LS_LOGGED_IN;
//			this._metricsComp.trackLink('', 'o', /*this._metricsComp.prop13 + "J23:" + */this.lastPageName);	
//			this._metricsComp.events = '';		
//		}
//		
//		public function trackCustomLink(type:String,name:String,urlOverride:String = null):void
//		{
//			var url:String = urlOverride;
//			if(ExternalInterface.available && urlOverride == null)
//			{
//				url = ExternalInterface.call("function(){return document.location.href}");
//			}
//			this._metricsComp.trackLink(url,type,name);
//		}
//		
//		public function trackVideoLoad(vidID:String,playerID:String,vidLength:Number,vidOffset:Number):void
//		{
//			this._metricsComp.Media.open(vidID,vidLength,playerID);
//			this._metricsComp.Media.play(vidID,vidOffset);
//		}
//		
//		public function trackVideoPause(vidID:String,vidOffset:Number):void
//		{
//			this._metricsComp.Media.stop(vidID,vidOffset);
//		}
//		
//		public function trackVideoResume(vidID:String,vidOffset:Number):void
//		{
//			this._metricsComp.Media.play(vidID,vidOffset);
//		}
//		
//		public function trackVideoEnd(vidID:String,vidOffset:Number):void
//		{
//			this._metricsComp.Media.stop(vidID,vidOffset);
//			this._metricsComp.Media.close(vidID);
//		}

		
		public function get metricsComp() : ActionSource
		{
			return this._metricsComp;
		}

	}
}

class SingletonEnforcer 
{
}