package com.jordan.cp.model {
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.jordan.cp.model.dto.SectionDTO;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author jason.tighe
	 */
	public class ContentModel 
	extends EventDispatcher 
	{
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private static var _instance 					: ContentModel;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _sections							: Array = new Array();
		protected var _scenes							: Array = new Array();
		protected var _content							: Array = new Array();
		protected var _copies							: Array = new Array();
		protected var _eggs								: Array = new Array();
		protected var _unlockedContent					: Array = new Array();
		protected var _unlockedScene					: Array = new Array();
		protected var _unlockedEggs						: Array = new Array();
		protected var _hotspotName						: String;
		protected var _hotspotD							: Dictionary;
		protected var _copiesD							: Dictionary;
		protected var _currentLock						: uint;
		protected var _hasVoted							: Boolean = false;
		protected var _vote								: String = "";
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function ContentModel( e : ContentModelEnforcer ) 
		{
			trace( "CONTENTMODEL : Constr" );
		}
		
		public function addData( data : * ) : void
		{
			var xml : XML = XML( data );
			
//			SECTION DTOS
			var sections : XMLList = xml.sections.*;
			var i : uint = 0
			var I : uint = sections.length();
			
			_copiesD = new Dictionary();
			var copyDTO : CopyDTO;
			var copies : XMLList;	// = xml.copies.*;
			var l : uint;	// = 0
			var L : uint;	// = sections.length();
			for( i; i < I; i++ )
			{
				copies = sections[ i ].copies.*;
				l = 0;
				L = sections[ i ].copies.copy.length();
				for( l; l < L; l++ )
				{
					copyDTO = new CopyDTO( copies[ l ] );
					_copiesD[ copyDTO.name ] = copyDTO;
				}
			}
			
			_hotspotD = new Dictionary();
			var contentDTO : ContentDTO;
//			var xml : XML = XML( data );
			
//			COPIES DTOS
//			var copies : XMLList = xml.sections.*;
//			var i : uint = 0
//			var I : uint = sections.length();
//			for( i; i < I; i++ )
//			{
//				_sections.push( new SectionDTO( sections[ i ] ) );
//			}
//			
//			_hotspotD = new Dictionary();
//			var contentDTO : ContentDTO;
			
//			HOTSPOT BONUS SCENES DTOS
			var scenes : XMLList = xml.hotspots.scenes.*;
			var j : uint = 0
			var J : uint = scenes.length();
			
			for( j; j < J; j++ )
			{
				contentDTO = new ContentDTO( scenes[ j ], j );
				_scenes.push( contentDTO );
				_hotspotD[contentDTO.name] = contentDTO;
			}
			
//			HOTSPOT BONUS CONTENT DTOS
			var content : XMLList = xml.hotspots.content.*;
			var k : uint = 0
			var K : uint = content.length();
			
			for( k; k < K; k++ )
			{
				contentDTO = new ContentDTO( content[ k ], k );
				_content.push( contentDTO );
				_hotspotD[contentDTO.name] = contentDTO;
			}

//			HOTSPOT BONUS EGGS DTOS
			content = xml.hotspots.eggs.*;
			K = content.length();
			
			for( k = 0; k < K; k++ )
			{
				contentDTO = new ContentDTO( content[ k ], k );
				_eggs.push( contentDTO );
				_hotspotD[contentDTO.name] = contentDTO;
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		 
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function doTracking( id : uint ) : void
		{
			var name : String = getContentItemAt( id ).name;
			trace( "CONTENTMODEL : doTracking() : name is "+name );
			
			switch( name ) 
			{
				case SiteConstants.VIGNETTE_HORSE:
					break;
				case SiteConstants.VIGNETTE_VINTAGE:
					break;
				case SiteConstants.FACTOID_SODA:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_DRINK );
					break;
				case SiteConstants.VIGNETTE_BLOND:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_BLONDE );
					break;
				case SiteConstants.FACTOID_MEAL:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_MEAL );
					break;
				case SiteConstants.FACTOID_GOSPEL:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_MUSIC );
					break;
				case SiteConstants.VIGNETTE_3_5:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_SNEAKER );
					break;
				case SiteConstants.FACTOID_ASSIST:
					break;
				case SiteConstants.VIGNETTE_JORDAN:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_JORDAN );
					break;
				case SiteConstants.FACTOID_STEALS:
					break;
				case SiteConstants.VIGNETTE_WALLPAPER:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_WALLPAPER );
					break;
				case SiteConstants.EGG_GREEN:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_GREEN_SCREEN );
					break;
				case SiteConstants.EGG_KONAMI:
					TrackingManager.gi.trackCustom(TrackingConstants.UNLOCKED_DANCE_OFF );
					break;
					
			}
		}
		 
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public static function get gi() : ContentModel
		{
			if(!_instance) _instance = new ContentModel(new ContentModelEnforcer());
			return _instance;
		}
		
		public function getSectionItemAt( index : uint ) : SectionDTO 
		{	
			return _sections[ index ];
		}
		
		public function get sections() : Array
		{
			return _sections;
		}
		
		public function getSceneItemAt( index : uint ) : ContentDTO 
		{	
			return _scenes[ index ];
		}
		
		public function get scenes() : Array
		{
			return _scenes;
		}
		
		public function getSceneItemByName( name : String ) : ContentDTO
		{
			return _hotspotD[ name ];
		}
		
		public function getContentItemAt( index : uint ) : ContentDTO 
		{	
			return _content[ index ];
		}
		
		public function get content() : Array
		{
			return _content;
		}
		
		public function getContentItemByName( name : String ) : ContentDTO
		{
			return _hotspotD[ name ];
		}
		
		public function getEggItemAt( index : uint ) : ContentDTO 
		{	
			return _eggs[ index ];
		}
		
		public function get eggs():Array
		{
			return _eggs;
		}
		
		public function get unlockedContent() : Array
		{
			return _unlockedContent;
		}
		
		public function set unlockedContent( array : Array ) : void
		{
			_unlockedContent = array;
		}
		
		public function addUnlockedContent( id : uint ) : void
		{
			trace( "CONTENTMODEL : addUnlockedContent() : id is "+id );
			if( _unlockedContent.indexOf( id ) == -1 )
			{
				_unlockedContent.push( id );
				_currentLock = id;
				doTracking( id );
				var cookiename : String = Shell.COOKIE_UNLOCKED_CONTENT;
				Shell.getInstance().setCookie( cookiename, _unlockedContent );
				dispatchEvent( new Event( Event.COMPLETE ) ) ;
			}
		}
		
		public function get unlockedEggs() : Array
		{
			return _unlockedEggs;
		}
		
		public function set unlockedEggs( array : Array ) : void
		{
			_unlockedEggs = array;
		}
		
		public function addUnlockedEgg( id : uint ) : void
		{
			trace( "CONTENTMODEL : addUnlockedEgg() : id is "+id );
			if( _unlockedEggs.indexOf( id ) == -1 )
			{
				_unlockedEggs.push(id);
				_currentLock = id;
				var cookiename : String = Shell.COOKIE_UNLOCKED_EGGS;
				Shell.getInstance().setCookie( cookiename, _unlockedEggs );
				// I DON'T THINK THIS IS NEEDED SO I'M COMMENTING IT OUT. FINGERS CROSSED! 12.19
//				dispatchEvent( new Event( Event.COMPLETE ) ) ;
			}
		}
		
		public function isUnlockedEgg( id : uint ) : Boolean
		{
			return !( _unlockedEggs.indexOf( id ) == -1 );
		}
		
		public function get currentLock() : uint
		{
			return _currentLock;
		}
		
		public function isUnlockedContent( id : uint ) : Boolean
		{
			return !( _unlockedContent.indexOf( id ) == -1 );
		}
		
		public function get unlockedScene() : Array
		{
			return _unlockedScene;
		}
		
		public function set unlockedScene( array : Array ) : void
		{
			_unlockedScene = array;
		}
		
		public function addUnlockedScene( id : uint ) : void
		{
			if( _unlockedScene.indexOf( id ) == -1 )	
			{
				_unlockedScene.push( id );
				var cookiename : String = Shell.COOKIE_UNLOCKED_SCENES;
				Shell.getInstance().setCookie( cookiename, _unlockedScene );
			}
		}
		
		public function isUnlockedScene( id : uint ) : Boolean
		{
			return !( _unlockedScene.indexOf( id ) == -1 );
		}
		
		public function get hotspotName() : String
		{
			return _hotspotName;
		}

		public function set hotspotName( s : String ) : void 
		{
			_hotspotName = s
		}
		
		public function get hotspotD() : Dictionary
		{
			return _hotspotD;
		}
		
		public function getCopyDTOByName( name : String ) : CopyDTO
		{
//			trace( "CONTENTMODEL : getCopyDTOByName() : name is "+name );
			return _copiesD[ name ];
		}
		
		public function getCopyByName( name : String ) : String
		{
//			trace( "CONTENTMODEL : getCopyByName() : name is "+name );
			return _copiesD[ name ].name;
		}

		public function set hasVoted( b : Boolean ) : void 
		{
			_hasVoted = b;
		}

		public function set vote( s : String ) : void 
		{
			_vote = s;
		}
	}
}

class ContentModelEnforcer{}
