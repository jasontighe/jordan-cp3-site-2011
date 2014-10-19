package com.jordan.cp.model.dto {

	/**
	 * @author jason.tighe
	 */
	public class DTO 
	implements IDTO 
	{
		protected var _name						: String;
		protected var _id						: uint;
		protected var _duration					: Number;
		
		
		public function DTO( data : * )
		{
			var xml : XML = XML( data );
			
			if ( xml.@name )		_name = xml.@name;
			if ( xml.@id )			_id = xml.@id;
			if ( xml.@duration )	_duration = xml.@duration;
			
//			trace( " " );
//			trace( "DTO : Constr" );
//			trace( "DTO : _name is "+_name );
//			trace( "DTO : _id is "+_id );
//			trace( "DTO : _duration is "+_duration );
		}
		
		
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public function get name( ) : String
		{
			return _name;	
		}
		
		public function get id( ) : uint
		{
			return _id;	
		}
		
		public function get duration( ) : Number
		{
			return _duration;	
		}
	}
}
