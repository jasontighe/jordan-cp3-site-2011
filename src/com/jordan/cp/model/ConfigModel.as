package com.jordan.cp.model {
	import com.jordan.cp.model.dto.ConfigDTO;
	import com.jordan.cp.model.dto.FontDTO;
	import com.jordan.cp.model.dto.ImagesDTO;

	import flash.events.EventDispatcher;

	/**
	 * @author jason.tighe
	 */
	public class ConfigModel 
	extends EventDispatcher 
	{
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private static var _instance 				: ConfigModel;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _bgColor						: uint;
		protected var _cookieMS						: uint = 0;
		protected var _siteURL						: String;
		protected var _chaosURL						: String;
		protected var _quickURL						: String;
		protected var _buyURL						: String;
		protected var _jumpmanURL					: String;
		protected var _cookieURL					: String;
		protected var _contentURL					: String;
		protected var _hotspotURL 					: String;
		protected var _welcomeURL					: String;
		protected var _assetsURL					: String;
		protected var _fontsUSURL					: String;
		protected var _stylesURL 					: String;
		protected var _soundURL 					: String;
		protected var _fonts						: Array = new Array();
		protected var _usFonts						: Array = new Array();
		protected var _chFonts						: Array = new Array();
		protected var _zipImages					: Array = new Array();		protected var _images						: Array = new Array( );
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function ConfigModel( e : ConfigModelEnforcer ) 
		{
			trace( "CONFIGMODEL : Constr" );
		}
		
		public function addData( data : * ) : void
		{
			var xml : XML = XML( data );
			
			// TODO - CONFIG SHOULD BE LOCALE SPECIFIC & DICTATE THESE PROPERTIES
			
			if( xml.bg_color )					_bgColor = uint( "0x" + xml.bg_color );
			if( xml.cookie_ms )					_cookieMS =  xml.cookie_ms ;
			if( xml.site_url )					_siteURL =  xml.site_url ;
			if( xml.jumpman_url )				_jumpmanURL =  xml.jumpman_url;
			if( xml.chaos_url )					_chaosURL =  xml.chaos_url;
			if( xml.quick_url )					_quickURL =  xml.quick_url;
			if( xml.buy_url )					_buyURL =  xml.buy_url;
			if( xml.subloads.cookie.@url )		_cookieURL = xml.subloads.cookie.@url;
			if( xml.subloads.content.@url )		_contentURL = xml.subloads.content.@url;
			if( xml.subloads.hotspot.@url )		_hotspotURL = xml.subloads.hotspot.@url;
			if( xml.subloads.welcome.@url )		_welcomeURL = xml.subloads.welcome.@url;
			if( xml.subloads.assets.@url )		_assetsURL = xml.subloads.assets.@url;
			if( xml.subloads.fonts_us.@url )	_fontsUSURL = xml.subloads.fonts_us.@url;
			if( xml.subloads.styles.@url )		_stylesURL = xml.subloads.styles.@url;
			if( xml.subloads.sounds.@url )		_soundURL = xml.subloads.sounds.@url;
			
			trace( "CONFIGMODEL : _bgColor is "+_bgColor );
			trace( "CONFIGMODEL : _cookieMS is "+_cookieMS );
			trace( "CONFIGMODEL : _siteURL is "+_siteURL );
			trace( "CONFIGMODEL : _quickURL is "+_quickURL );
			trace( "CONFIGMODEL : _quickURL is "+_quickURL );
			trace( "CONFIGMODEL : _jumpmanURL is "+_jumpmanURL );
			trace( "CONFIGMODEL : _contentURL is "+_contentURL );
			trace( "CONFIGMODEL : _welcomeURL is "+_welcomeURL );
			trace( "CONFIGMODEL : _assetsURL is "+_assetsURL );
			trace( "CONFIGMODEL : _fontsUSURL is "+_fontsUSURL );
			trace( "CONFIGMODEL : _stylesURL is "+_stylesURL );
			trace( "CONFIGMODEL : _soundURL is "+_soundURL );
			
//			FONT DTOS
			var fonts : XMLList = xml.subloads.fonts.*;
			var i : uint = 0;
			var I : uint = fonts.length();
			
			for( i; i < I; i++ )
			{
				var fontDTO : FontDTO = new FontDTO( fonts[ i ] )
				_fonts.push( fontDTO );
				if( fontDTO.country == "us" )		_usFonts.push( fontDTO );
				if( fontDTO.country == "china" )	_chFonts.push( fontDTO );
			}

//			CONFIG DTOS
			var zipImages : XMLList = xml.subloads.zip_images.*;
			var j : uint = 0;
			var J : uint = zipImages.length();
			
			for( j; j < J; j++ )
			{
				var configDTO : ConfigDTO = new ConfigDTO( zipImages[ j ] )
				_zipImages.push( configDTO );
//				if( configDTO.type == "zip_images" )	_zipImages.push( configDTO );
			}
		}
		 
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public static function get gi() : ConfigModel
		{
			if(!_instance) _instance = new ConfigModel(new ConfigModelEnforcer());
			return _instance;
		}
		
		public function get bgColor( ) : uint 
		{
			return _bgColor;
		}
		
		public function get cookieMS( ) : uint 
		{
			return _cookieMS;
		}
		
		public function get siteURL( ) : String 
		{
			return _siteURL;
		}
		
		public function get chaosURL( ) : String 
		{
			return _chaosURL;
		}
		
		public function get quickURL( ) : String 
		{
			return _quickURL;
		}
		
		public function get buyURL( ) : String 
		{
			return _buyURL;
		}
		
		public function get jumpmanURL( ) : String 
		{
			return _jumpmanURL;
		}
		
		public function get cookieURL( ) : String 
		{
			return _cookieURL;
		}
		
		public function get contentURL( ) : String 
		{
			return _contentURL;
		}
		
		public function get hotspotURL( ) : String 
		{
			return _hotspotURL;
		}
		
		public function get welcomeURL( ) : String 
		{
			return _welcomeURL;
		}
		
		public function get assetsURL( ) : String 
		{
			return _assetsURL;
		}
		
		public function get stylesURL( ) : String 
		{
			return _stylesURL;
		}
		
		public function get fontsUSURL( ) : String 
		{
			return _fontsUSURL;
		}
		
		public function get soundURL() : String
		{
			return _soundURL;
		}
				
		public function get zipImages( ) : Array 
		{
			return _zipImages;
		}
		
		public function get usFonts( ) : Array 
		{
			return _usFonts;
		}
		
		public function get chFonts( ) : Array 
		{
			return _chFonts;
		}
	}
}

class ConfigModelEnforcer{}
