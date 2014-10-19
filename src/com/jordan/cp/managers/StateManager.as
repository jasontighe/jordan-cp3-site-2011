package com.jordan.cp.managers {

	/**
	 * @author jason.tighe
	 */
	public class StateManager 
	extends AbstractManager 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _state							: String;
		
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function StateManager() 
		{
			trace( "STATEMANAGER : Constr" );
			super();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function updateState() : void
		{
			trace( "STATEMANAGER : updateState()" );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get state() : String
		{
			return _state;
		}
		
		public function set state( value : String ) : void
		{
//			trace( "STATEMANAGER : STATE = " + value + ",	 OLD STATE = " + _state);
//			if( _state != value)
//			{
//				_state = value;
//				updateState();
//			}
		}
	}
}
