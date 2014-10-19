package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.MediaDTO;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperSizesNav 
	extends DisplayContainer 
	{
		protected static var DEVICE_NAV_X_SPACE				: uint = 14;
		protected var _dto									: MediaDTO;
		protected var _navArray								: Array = new Array();
		protected var _url									: String;
		protected var _id									: uint;
		protected var _navId								: uint;
		public var nav										: Nav;
//		public var deviceArray								: Array;
		
		public function WallpaperSizesNav() 
		{
			super();
//			deviceArray = new Array( "DESKTOP", "IPHONE", "IPAD", "TWITTER" );
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( array : Array ) : void
		{
			trace( "WALLPAPERSIZESNAV : addNav()" );
			nav = new Nav();
			
//			navArray = array;
			
//			var dto : ContentDTO;
			var item : WallpaperSizesNavItem;
			var last : WallpaperSizesNavItem;
			var i : uint = 0;
			var I : uint = array.length;
			var lastItem : uint = I - 1;
			
			var xSpace : uint = 0;
			
			for( i; i < I; i++)
			{	
//				dto = _contentModel.getSceneItemAt( i ) as ContentDTO;
				item = new WallpaperSizesNavItem();
				item.setIndex( i );
				
//				item.init();
				var name : String = array[ i ] as String;
				item.addViews( name );
				item.setOutState();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				item.x = xSpace;
				item.y = 0;
				
				xSpace += item.width + DEVICE_NAV_X_SPACE;
				
				nav.add( item );
				nav.addChild( item );
			}
			
			nav.init();
			nav.disable();
			addChild( nav );
		}

		public function transitionIn( ) : void
		{
			alpha = 1;
			TweenLite.from( this, SiteConstants.NAV_TIME_IN, { alpha: 0, onComplete: transitionInComplete } );
		}

		public function transitionOut( ) : void
		{
			hide();
			nav.disable();
		}
			
		//----------------------------------------------------------------------------
		// protected functions
		//----------------------------------------------------------------------------
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function transitionInComplete( ) : void
		{
			nav.enable();
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : WallpaperSizesNavItem = e.target as WallpaperSizesNavItem; 
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : WallpaperSizesNavItem = e.target as WallpaperSizesNavItem; 
			item.setOverState();
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			trace("WALLPAPERSIZESNAV() : onNavItemClick()" );
			var item : WallpaperSizesNavItem = e.target as WallpaperSizesNavItem; 
			_id = item.getIndex();
			nav.setActiveItem( item );
			item.setActiveState();
			var dto : MediaDTO = _navArray[ _id ] as MediaDTO;
			_url = dto.url;
			trace("WALLPAPERSIZESNAV() : onNavItemClick() : _id is "+_id );
			trace("WALLPAPERSIZESNAV() : onNavItemClick() : _url is "+_url );
			dispatchCompleteEvent();
		}
			
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}
		
		public function get url( ) : String
		{
			return _url;
		}
		
		public function get navId( ) : uint
		{
			return _navId;
		}
		
		public function set navId( n : uint ) : void
		{
			_navId = n;
		}

		public function set dto ( dto : MediaDTO ) : void
		{
			_dto = dto
		}

		public function set navArray ( array : Array ) : void
		{
			_navArray = array;
		}
	}
}
