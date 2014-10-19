package com.jordan.cp.model.dto 
{

	/**
	 * @author jason.tighe
	 */
	public class VideoDTO 
	implements IDTO 
	{
		protected var _name : String;
		protected var _id : uint;
		protected var _length : Number;
		protected var _flvUrl : String;
//		private var _stillUrl : String;

		
		public function VideoDTO( data : * )
		{
			var data : Object = Object(data);
			
			if ( data.name )		_name = data.name;
			if ( data.id	 )		_id = data.id;
			if ( data.length )		_length = data.length;
			if ( data.FLVURL )		_flvUrl = data.FLVURL;
//			if ( data.videoStillURL ) _stillUrl = data.videoStillURL;
			
//			trace(" ");
//			trace("VIDEODTO : Constr");
//			toMyString();

		}
		
		public function toMyString() : void
		{
			trace("VIDEODTO : _name is " + _name);
			trace("VIDEODTO : _id is " + _id);
			trace("VIDEODTO : _length is " + _length);
			trace("VIDEODTO : _flvUrl is " + _flvUrl);
//			trace("VIDEODTO : _stillUrl is " + _stillUrl);
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

		public function get length( ) : Number
		{
			return _length;	
		}

		public function get flvUrl( ) : String
		{
			return _flvUrl;	
		}

//		public function get stillUrl() : String 
//		{
//			return _stillUrl;
//		}
	}
}
