package com.jordan.cp.model.dto {
	import com.jordan.cp.model.MediaDTO;

	import flash.utils.Dictionary;

	/**
	 * @author jsuntai
	 */
	public class ContentDTO 
	implements IDTO 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _id	 							: uint;
		protected var _name 							: String;
		protected var _type 							: String;
		protected var _category							: String;
		protected var _shortTitle						: String;
		protected var _longTitle 						: String;
		protected var _icon 							: String;
		protected var _thumbURL							: String;
		protected var _desc 							: String;
		protected var _navs	 							: Array = new Array();
		protected var _navsD 							: Dictionary;
		protected var _nav	 							: Array = new Array();
		protected var _navNames							: Array = new Array();
		//----------------------------------------------------------------------------
		// contructor
		//----------------------------------------------------------------------------
		public function ContentDTO( data : *, id : uint = 0 )
		{
			var data : Object = Object(data);
			
			_id = id;
			if ( data.@name )			_name = data.@name;
			if ( data.@type )			_type = data.@type;
			if ( data.@category )		_category = data.@category;
			if ( data.@short_title )	_shortTitle = data.@short_title;
			if ( data.@long_title )		_longTitle = data.@long_title;
			if ( data.@icon )			_icon = data.@icon;
			if ( data.@thumbURL )		_thumbURL = data.@thumbURL;
			if ( data.desc )			_desc = String(data.desc.toString()).toUpperCase();
			
//			trace( "\n" );
//			trace( "CONTENTDTO : _name is "+_name );
//			preview();
			
//			MEDIA DTOS FOR VIGNETTES
//			var nav : XMLList = data.nav.*;
//			var i : uint = 0
//			var I : uint = nav.length();
//			for( i; i < I; i++ )
//			{
//				_nav.push( new MediaDTO( nav[ i ], i ) );
//			}
			
//			preview();
			
			_navsD = new Dictionary();
			var navs : XMLList = data.navs.*;
			var i : uint = 0
			var I : uint = navs.length();
			
			var nav : XMLList; 
			var j : uint;
			var J : uint;
			var mediaDTO : MediaDTO;
			
			for( i; i < I; i++ )
			{
				nav = navs[ i ].*;
				j = 0;
				J = nav.length();
				var name : String = data.navs.nav[i].@name;
				_navNames.push( name );
				_nav = new Array();
				for( j; j < J; j++ )
				{
					mediaDTO = new MediaDTO( nav[ j ], j );
					_nav.push( mediaDTO );
				}
				
				_navsD[ name ] = _nav;
				_navs.push( _nav );
			}
			
//			preview();
		}

		public function preview() : void 
		{
			trace("\n");
			trace("CONTENTDTO : _id is " + _id );
			trace("CONTENTDTO : _name is " + _name );
			trace("CONTENTDTO : _type is " + _type );
			trace("CONTENTDTO : _shortTitle is " + _shortTitle );
			trace("CONTENTDTO : _longTitle is " + _longTitle );
			trace("CONTENTDTO : _icon is " + _icon );
			trace("CONTENTDTO : _thumbURL is " + _thumbURL );
			trace("CONTENTDTO : _desc is " + _desc);
		}

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id() : uint 
		{
			return _id;
		}
		
		public function get name() : String 
		{
			return _name;
		}
		
		public function get type() : String 
		{
			return _type;
		}
		
		public function get category() : String 
		{
			return _category;
		}
		
		public function get shortTitle() : String 
		{
			return _shortTitle;
		}
		
		public function get longTitle() : String 
		{
			return _longTitle;
		}
		
		public function get icon() : String 
		{
			return _icon;
		}
		
		public function get thumbURL() : String 
		{
			return _thumbURL;
		}
		
		public function get desc() : String 
		{
			return _desc;
		}
		
		public function get nav() : Array 
		{
			return _nav;
		}
		
		public function get navs() : Array 
		{
			return _navs;
		}
		
		public function get navNames() : Array 
		{
			return _navNames;
		}
		
		public function getNavItemAt( n : uint ) : MediaDTO 
		{
			return _nav[ n ];
		}
		
		public function getNavsItemAt( n : uint ) : Array 
		{
			return _navs[ n ];
		}
		
		public function getNavArrayByName( s : String ) : Array 
		{
			return _navsD[ name ];
		}
	}
}
