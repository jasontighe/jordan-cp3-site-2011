package com.jordan.cp.managers.tracking 
{
	import com.jordan.cp.constants.TrackingConstants;

	/**
	 * @author nelson.shin
	 */

	public class TrackingObject
	{
//		public static const PT_PRODUCT_FEATURE:String = "product feature";
//		public static const PT_ATHLETE_FEATURE:String = "athlete feature";
//		public static const PT_CONTENT_FEATURE:String = "content feature";
//		public static const PT_VIDEO:String = "video";
//		public static const PT_PDP:String = "pdp";
//		
//		public static const PTA_PRODUCT:String = "product";
//		public static const PTA_CONTENT:String = "content";
//		public static const PTA_TOOLS:String = "tools";
//		public static const PTA_ACCOUNT:String = "account";
//		
//		public static const LS_NO_ACTION:String = "no action";
//		public static const LS_LOGGED_IN:String = "logged in";
//		public static const LS_LOGGED_OUT:String = "logged out";
		
//		public var registrationStart:Boolean; // jsut a flag used to determine whether to set evar 21
		
		// events
//		public var registrationComplete:Boolean; //event1
//		public var onSiteSearch:Boolean; //event2
//		public var login:Boolean; //event5
//		public var storeLocator:Boolean; //event7
		
		public var channel:String = ''; // channel
		
		public var pageName:String;
		
//		public var failedSearchTerm:String; //prop10
//		public var searchTerm:String; //prop11
		
		public var pageType:String = ''; //prop17
		public var siteSection:String = ''; //prop18
//		public var pageTypeAggregated: String;

		public var suiteID : String = 'nikejordan';
		public var campaign : String = 'cp3v';
		public var region : String = 'us';
		public var country : String = 'us';
		public var language : String = 'en_US';
		public var siteSrc : String = 'siteSrc';

		//prop23

//		public var loggedInStatus:String; //eVar4
		
		
		public function TrackingObject()
		{
		}
		
		public function getObject():Object
		{
			var retObj:Object = new Object();
//			switch(true)
//			{
//				case this.registrationComplete:
//					retObj.events = "event1";
//					break;
//				case this.onSiteSearch:
//					retObj.events = "event2";
//					break;
//				case this.login:
//					retObj.events = "event5";
//					break;
//				case this.storeLocator:
//					retObj.events = "event7";
//					break;
//			}

			retObj.channel = this.channel;
//			retObj.pageName = this.pageName;
//			retObj.prop10 = this.failedSearchTerm;
//			retObj.prop11 = this.searchTerm;
			retObj.prop17 = this.pageType;
			retObj.prop18 = this.siteSection;
//			retObj.prop23 = this.pageTypeAggregated;
//			if(this.loggedInStatus != null) retObj.eVar4 = this.loggedInStatus;
//			retObj.eVar11 = this.searchTerm;
//			if(this.registrationStart) retObj.eVar21 = this.pageName;
			
			return retObj;
		}
		
	}
}