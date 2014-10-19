package com.plode.framework.managers
{
	public class StringManager
	{
		private static var _instance : StringManager;

		public function StringManager(e : Enforcer)
		{
		}
		
		//----------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// PROTECTED METHODS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// EVENT HANDLERS
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------
		public static function get gi() : StringManager
		{
			if(!_instance) _instance = new StringManager(new Enforcer());
			return _instance;
		}
	}
}
class Enforcer{}