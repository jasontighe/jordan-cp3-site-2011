package com.jordan.cp.model.dto {

	/**
	 * @author jason.tighe
	 */
	public class ImagesDTO 
	implements IDTO 
	{
		protected var _name						: String;
		protected var _type						: String;
		protected var _id						: uint;
		protected var _url						: String;
		
		
		public function ImagesDTO( data : * )
		{
			var data : Object = Object( data );
			
			if ( data.@name )		_name = data.@name;
			if ( data.@type )		_type = data.@type;
			if ( data.@id	 )		_id = data.@id;
			if ( data.@url )		_url = data.@url;
			
//			trace( " " );
//			trace( "IMAGESDTO : Constr" );
//			trace( "IMAGESDTO : _name is "+_name );
//			trace( "IMAGESDTO : _type is "+_type );
//			trace( "IMAGESDTO : _id is "+_id );
//			trace( "IMAGESDTO : _url is "+_url );
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
