package com.plode.framework.models
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class AbstractMainModel extends EventDispatcher
	{
		protected var _locale : String;
		protected var _assetBasePath : String;
		protected var _trackingBase : String;
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		public function AbstractMainModel()
		{
		}
		
		
		//----------------------------------------------------------------------
		//
		// PROTECTED METHODS
		//
		//----------------------------------------------------------------------
		protected function parseXml(xml : XML) : void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		

		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		public function get locale() : String
		{
			return _locale;
		}

		public function set locale(value : String) : void
		{
			_locale = value;
		}

		public function get assetBasePath() : String
		{
			return _assetBasePath;
		}

		public function set assetBasePath(value : String) : void
		{
			_assetBasePath = value;
		}

		public function get trackingBase() : String
		{
			return _trackingBase;
		}

	}
}