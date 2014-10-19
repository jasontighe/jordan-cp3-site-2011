package com.jordan.cp.model {
	import com.jordan.cp.model.dto.IDTO;

	/**
	 * @author jason.tighe
	 */
	public class MediaDTO 
	implements IDTO 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _id	 								: uint;
		protected var _thumbURL 							: String;
		protected var _imageURL 							: String;
		protected var _url		 							: String;
		protected var _title	 							: String;
		protected var _desc		 							: String;
		protected var _name		 							: String; // Not used
		//----------------------------------------------------------------------------
		// contructor
		//----------------------------------------------------------------------------
		public function MediaDTO( data : *, i : uint )
		{
			var data : Object = Object( data );
//			trace("MEDIADTO : data is " + data );
			
			_id = i;
			
			if ( data.title )			_title = data.title;
			if ( data.desc )			_desc = data.desc;
			if ( data.@name )			_name = data.@name;
			if ( data.@url )			_url = data.@url;
			if ( data.@thumbURL )		_thumbURL = data.@thumbURL;
			if ( data.@imageURL )		_imageURL = data.@imageURL;
			
//			preview();
		}

		public function preview() : void 
		{
//			trace("\n");
			trace("MEDIADTO : _id is " + _id );
			trace("MEDIADTO : _desc is " + _desc );
			trace("MEDIADTO : _name is " + _name );
			trace("MEDIADTO : _url is " + _url );
			trace("MEDIADTO : _thumbURL is " + _thumbURL );
			trace("MEDIADTO : _imageURL is " + _imageURL );
		}

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id() : uint 
		{
			return _id;
		}
		
		public function get url() : String 
		{
			return _url;
		}
		
		public function get thumbURL() : String 
		{
			return _thumbURL;
		}
		
		public function get imageURL() : String 
		{
			return _imageURL;
		}
		
		public function get name() : String 
		{
			trace("MEDIADTO : get name "+_name );
			return _name;
		}
		
		public function get title() : String 
		{
			return _title;
		}
		
		public function get desc() : String 
		{
			return _desc;
		}
	}
}
