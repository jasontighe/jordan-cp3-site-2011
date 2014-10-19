package com.jordan.cp.model.dto {

	/**
	 * @author jason.tighe
	 */
	public class ConfigDTO 
	implements IDTO 
	{
		protected var _name						: String;
		protected var _type						: String;
		protected var _id						: uint;
		protected var _url						: String;
		
		
		public function ConfigDTO( data : * )
		{
			var data : Object = Object( data );
			
			if ( data.@name )		_name = data.@name;
			if ( data.@type )		_type = data.@type;
			if ( data.@id	 )		_id = data.@id;
			if ( data.@url )		_url = data.@url;
			
//			trace( " " );
//			trace( "CONFIGDTO : Constr" );
//			trace( "CONFIGDTO : _name is "+_name );
//			trace( "CONFIGDTO : _type is "+_type );
//			trace( "CONFIGDTO : _id is "+_id );
//			trace( "CONFIGDTO : _url is "+_url );
		}
		
		
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public function get name( ) : String
		{
			return _name;	
		}
		
		public function get type( ) : String
		{
			return _type;	
		}
		
		public function get id( ) : uint
		{
			return _id;	
		}
		
		public function get url( ) : String
		{
			return _url;	
		}
	}
}
