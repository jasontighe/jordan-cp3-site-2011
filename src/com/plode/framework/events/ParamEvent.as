package com.plode.framework.events
{
	import flash.events.Event;
	
	public class ParamEvent extends Event
	{
		private var _selectedType : String;
		private var _params : Object;
		
		public function ParamEvent(type : String, params : Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( type, bubbles, cancelable);
			_selectedType = type;
			_params = params;
		}
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		override public function clone():Event
		{
			return new ParamEvent(selectedType, this.params, bubbles, cancelable);
		}
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		public function get selectedType() : String
		{
			return _selectedType;
		}
		
		public function get params() : Object
		{
			return _params;
		}
	}
}
