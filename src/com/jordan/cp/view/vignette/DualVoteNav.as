package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.media.SimpleStreamingPlayer;
	import com.jordan.cp.media.events.SimpleStreamingEvent;
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.events.Event;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class DualVoteNav 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var SCENE_NAV_X_SPACE				: uint = 370;
		protected static var OVERLAY_ALPHA					: Number = .6;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _id									: uint;
		protected var _itemXPos								: uint;
		protected var _videosComplete						: uint = 0;
		protected var _overlays								: Array = new Array;
		protected var _videoNames							: Array = new Array;
		protected var _videos								: Array = new Array;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var nav										: Nav;
		
		public function DualVoteNav() 
		{
			super();
			
			_videoNames = [ SiteConstants.VIGNETTE_JORDAN_DO, SiteConstants.VIGNETTE_BLOND_DO ];
		}

		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public function addNav( dto : ContentDTO ) : void
		{
//			trace( "DULAVOTENAV : addNav()" );
			nav = new Nav();
			
			var dto : ContentDTO = dto;
			var item : DualVoteNavItem;
			var last : DualVoteNavItem;
			var i : uint = 0;
			var I : uint = dto.nav.length;
			
			for( i; i < I; i++)
			{	
//				dto = model.getSceneItemAt( i ) as ContentDTO; 
				item = new DualVoteNavItem();
				item.addEventListener( SimpleStreamingEvent.VIDEO_READY, onVideoReady )
				item.setIndex( i );
				item.addViews();
				
//				item.setOutState();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				item.addEventListener( SimpleStreamingEvent.VIDEO_COMPLETE, onVideoComplete )
				
				
				item.x = i * SCENE_NAV_X_SPACE ;
				item.y = 0;
				
				nav.add( item );
				nav.addChild( item );
			}
			
			nav.init();
			addChild( nav );
			
			
			var j : uint = 0;
			var J : uint = dto.nav.length;
	
			for( j; j < J; j++)
			{	
				var w : uint = SiteConstants.VIDEO_DANCE_OFF_WIDTH;
				var h : uint = SiteConstants.VIDEO_DANCE_OFF_HEIGHT;
				var box : Box = new Box( w, h, 0x000000 );
				box.alpha = 0;
				box.x = ( j * SCENE_NAV_X_SPACE ) + 1;
				box.y = 1;
				addChild( box );
				
				_overlays.push( box );
			}
		}
		
		public function playVideos() : void
		{
			var i : uint = 0;
			var I : uint = nav.length;
			
			for( i; i < I; i++)
			{	
				var name : String = _videoNames[ i ];
//				trace("\n\n\n");
//				trace( "DULAVOTENAV : addNav() : name is "+name );
				var item : DualVoteNavItem = nav.getItemAt( i ) as DualVoteNavItem;				
				var url : String = Shell.getInstance().getVideoModel().getUrlByName( name );
				var nc : NetConnection = Shell.getInstance().getVideoModel().nc;
				item.playVideo( url, nc );
			}	
		}
		
		public function showResults( array : Array ) : void
		{
//			trace( "DULAVOTENAV : addNav() : array is "+array );
			var navArray : Array = nav.getItems();
			var i : uint = 0;
			var I : uint = array.length;
			
			for( i; i < I; i++)
			{	
				var navItem : DualVoteNavItem = nav.getItemAt( i ) as DualVoteNavItem;
//				trace( "DULAVOTENAV : addNav() : array[ i ] is "+array[ i ] );
				var percent : uint = uint( array[ i ] );
				navItem.showResult( percent );
			}
		}
					
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onNavAltItemOut( id : uint ) : void
		{
			var i : uint = 0;
			var I : uint = _overlays.length;
			
			for( i; i < I; i++)
			{	
				if( i != id)
				{
					var overlay : Box = _overlays[ i ];
					TweenLite.to( overlay, SiteConstants.NAV_TIME_IN, { alpha: 0, ease:Quad.easeOut } );
				}
			}
		}
		
		protected function onNavAltItemOver( id : uint ) : void
		{
			var i : uint = 0;
			var I : uint = _overlays.length;
			
			for( i; i < I; i++)
			{	
				if( i != id)
				{
					var overlay : Box = _overlays[ i ];
					TweenLite.to( overlay, SiteConstants.NAV_TIME_OUT, { alpha: OVERLAY_ALPHA, ease:Quad.easeOut } );
				}
			}
		}
	
		protected function transitionOutNavItems( ) : void
		{
//			trace( "DUALVOTINGNAV : transitionOutNavItems()" );
			var array : Array = nav.getItems();
			var i : uint = 0;
			var I : uint = array.length;
			
			for( i; i < I; i++)
			{	
				var navItem : DualVoteNavItem = array[ i ] as DualVoteNavItem;
				navItem.transitionOut();
			}
		}
		
		protected function dispatchVideoComplete( ) : void
		{
//			trace( "DUALVOTINGNAV : dispatchVideoComplete()" );
			dispatchEvent( new SimpleStreamingEvent( SimpleStreamingEvent.VIDEO_COMPLETE ) );
		}
					
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : DualVoteNavItem = e.target as DualVoteNavItem; 
			var id : uint = item.getIndex();
			item.setOutState();
			
			onNavAltItemOut( id );
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : DualVoteNavItem = e.target as DualVoteNavItem; 
			var id : uint = item.getIndex();
			item.setOverState();
			
			onNavAltItemOver( id );
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			var item : DualVoteNavItem = e.target as DualVoteNavItem; 
			_id = item.getIndex();
			_itemXPos = item.x;
			nav.setActiveItem( item );
			item.setActiveState();
			nav.disable();
			
			transitionOutNavItems();
			dispatchCompleteEvent();
		}
		
		protected function onVideoComplete( e : Event ) : void
		{
			_videosComplete++
//			var navArray = nav.getItems();
			
			if( _videosComplete == nav.getItems().length )	dispatchVideoComplete();
		}
		
		protected function onVideoReady( e : Event = null ) : void 
		{
//			trace( "DUALVOTINGNAV : onVideoReady()" );
			var item : DualVoteNavItem = e.target as DualVoteNavItem;
//			trace( "DUALVOTINGNAV : onVideoReady() : item is "+item );
			var player : SimpleStreamingPlayer = item.player
//			trace( "DUALVOTINGNAV : onVideoReady() : player is "+player );
			_videos.push( player ) ;
//			trace( "DUALVOTINGNAV : onVideoReady() : _videos.length is "+_videos.length );
		}
			
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}
		
		public function get itemXPos( ) : uint
		{
			return _itemXPos;
		}
		
		public function get videos( ) : Array
		{
			return _videos;
		}
	}
}
