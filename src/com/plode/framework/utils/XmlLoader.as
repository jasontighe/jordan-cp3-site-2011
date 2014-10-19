package com.plode.framework.utils
{
	/**
	 * @author ns
	 */

	import com.plode.framework.constants.StaticConstants;
	import com.plode.framework.events.ParamEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XmlLoader extends EventDispatcher
	{
		private var _showTrace : Boolean;
		
		public function XmlLoader(showTrace : Boolean = true)
		{
			_showTrace = showTrace;
		}
		
		public function loadXml( path : String ) : void
		{
			var loader : URLLoader = new URLLoader();
			var urlRequest : URLRequest = new URLRequest(path);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
			loader.addEventListener( Event.COMPLETE, onXMLLoaded, false, 0, true );
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			
			try {
				loader.load( urlRequest );
			}
			catch (error:SecurityError)
			{
				trace("XmlLoader.loadXml(path)");
				trace("A SecurityError has occurred.", error.getStackTrace());
			}

//			trace('xml path:', path);
		}
		
		protected function loaderErrorHandler(e : IOErrorEvent):void 
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			new Error( 'XmlLoader : loadErrorHandler : ', e );
		}

		private function openHandler(event:Event):void {
			if(_showTrace) trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			if(_showTrace) trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			if(_showTrace) trace("securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			if(_showTrace) trace("httpStatusHandler: " + event);
		}
		
		private function onXMLLoaded(event : Event) : void
		{
			if(_showTrace) trace("XML LOADED");
			event.stopPropagation();
			var loader : URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onXMLLoaded);
			
			var xml : XML;
			try
			{
				xml = XML( event.target.data );
			}
			catch(e:Error)
			{
				xml = null;
				trace("XmlLoader.onXMLLoaded(event)");
				trace("INVALID XML LOADED", e.getStackTrace());
			}
			
//			trace(xml);
			dispatchEvent( new ParamEvent(StaticConstants.XML_LOADED, {xml: xml}) );
		}
				
	}
}
