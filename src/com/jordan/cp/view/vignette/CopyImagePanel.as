package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.loaders.QueueLoadItem;
	import com.jasontighe.loaders.QueueLoader;
	import com.jasontighe.loaders.events.QueueLoadItemEvent;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.MediaDTO;
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class CopyImagePanel 
	extends DisplayContainer
	{
		protected static const IMAGE_X						: uint = 163;
		protected static const IMAGE_Y						: uint = 250;
		protected static const BACKGROUND_WIDTH				: uint = 362;
		protected static const BACKGROUND_HEIGHT			: uint = 270;
		protected static const BACKGROUND_COLOR				: uint = 0x2c2c2c;
		protected static const IMAGE_X_SPACE				: uint = 14;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nav									: Nav;
		protected var _navArray								: Array = new Array();
		protected var _imagesArray							: Array = new Array();
		protected var _queueLoader							: QueueLoader;
		protected var _imageW								: uint;
		protected var _id									: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
//		public var navItem2									: CopyImageNavItem;
//		public var navItem3									: CopyImageNavItem;
		public var background								: MovieClip;
		public var imageHolder								: MovieClip;
		public var count									: uint = 0;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CopyImagePanel()
		{
			super();
			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			setWidth( background.width );
			setHeight( background.height );
			
//			addViews();
		}
		
		public function populateByDTO( dto : ContentDTO ) : void
		{
//			trace( "COPYPANELIMAGE : populateByDTO() : dto is "+dto );
			// LOAD IMAGES
			imageHolder = new MovieClip();
			imageHolder.alpha = 0;
			imageHolder.x = 1;
			imageHolder.y = 1;
			addChild( imageHolder );
			
			var imageMask : Box = new Box( background.width, background.height );
			imageHolder.mask = imageMask;
			addChild( imageMask );
			
			var dto : ContentDTO = dto;
			var nav : Array = dto.nav;
			
			_queueLoader = new QueueLoader();
			var i : uint = 0;
			var I : uint = nav.length;
			
			for( i; i < I; i++ )
			{
				var mediaDTO : MediaDTO = dto.getNavItemAt( i );
				var imageURL : String = mediaDTO.imageURL;
				var imageLoadItem : QueueLoadItem = new QueueLoadItem( imageURL, onImageLoadComplete );
				imageLoadItem.setId( i );
				_queueLoader.add( imageLoadItem);
			}
			
			_queueLoader.setLoadCompleteEventHandler( onImageLoaderComplete );
			_queueLoader.load();
			
			addNav( I );
			
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
//		protected function addViews() : void
//		{
//			addBackground();
//		}
//		
//		protected function addBackground() : void
//		{
//			background = new Box( BACKGROUND_WIDTH, BACKGROUND_HEIGHT, BACKGROUND_COLOR );
//			addChild( background );
//		}
		
		protected function addNav( totalItems : uint ) : void
		{
			_nav = new Nav();
			var item : CopyImageNavItem;
			var i : uint = 0;
			var I : uint = totalItems;
			
			for( i; i < I; i++ )
			{
				item = new CopyImageNavItem();
				item.setIndex( i );
				item.id = i;
				item.init();
				item.setOutState();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				_navArray.push( item );
				_nav.add( item );
				_nav.addChild( item );
				
				item.x = IMAGE_X + ( i * IMAGE_X_SPACE );
				item.y = IMAGE_Y;
				
				if( i == 0 )
				{
					item.setActiveState();
					_nav.setActiveItem( item );
				}
			}
			
			// CATCH FOR IF ITS ONE ITEM
			if( totalItems == 1)
			{
				_nav.visible = false;
			}
			else
			{
				_nav.init();
				addChild( _nav );
			}
		}
		
		
		protected function slideImages( id : uint ) : void
		{
//			trace( "COPYPANELIMAGE : slideImages() id is "+id );
			var xPos : int = -( id * getWidth() );
			TweenLite.to( imageHolder, SiteConstants.NAV_TIME_IN, { x: xPos, ease:Quad.easeOut } );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onImageLoadComplete( e: QueueLoadItemEvent ) : void
		{
			var mc : MovieClip  = new MovieClip( );
			mc.addChild( e.loadItem.content );
			imageHolder.addChild( mc );
			
			if( count == 0 )	
			{
				_imageW = mc.width;
				TweenLite.to( imageHolder, SiteConstants.NAV_TIME_IN, { alpha: 1, ease:Quint.easeOut } );
				
			}
			mc.x = _imageW * count;
			
			var item : CopyImageNavItem = _navArray[ count ];
			item.enable();
			
			count++
			_imagesArray.push( mc );
		}
		
		protected function onImageLoaderComplete( e: Event ) : void
		{
		}
		
		protected function onNavItemOver( e : Event = null ) : void
		{
			var item : CopyImageNavItem = e.target as CopyImageNavItem;
			var id : uint = item.id;
//
			item.setOverState();
//			item.setActiveState();
//			_nav.setActiveItem( item );
		}
		
		protected function onNavItemOut( e : Event = null ) : void
		{
			var item : CopyImageNavItem = e.target as CopyImageNavItem;
			var id : uint = item.id;
			
			item.setOutState();
		}
		
		protected function onNavItemClick( e : Event = null ) : void
		{
			var item : CopyImageNavItem = e.target as CopyImageNavItem;
			_id = item.id;
			
			item.setActiveState();
			_nav.setActiveItem( item );
			slideImages( _id );
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get id() : uint
		{
			return _id;
		}
	}
}
