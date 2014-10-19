package com.jordan.cp.model.dto {

	/**
	 * @author jason.tighe
	 */
	public class FontDTO 
	implements IDTO 
	{
		protected var _name						: String;
		protected var _id						: uint;
		protected var _country					: String;
		protected var _url						: String;
		
		
		public function FontDTO( data : * )
		{
			var data : Object = Object( data );
			
			if ( data.@name )		_name = data.@name;
			if ( data.@country )	_country = data.@country;
			if ( data.@url )		_url = data.@url;
			
//			trace( " " );
//			trace( "FONTDTO : Constr" );
//			trace( "FONTDTO : _name is "+_name );
//			trace( "FONTDTO : _country is "+_country );
//			trace( "FONTDTO : _url is "+_url );
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
		
		public function get country( ) : String
		{
			return _country;	
		}
		
		public function get url( ) : String
		{
			return _url;	
		}
	}
}
