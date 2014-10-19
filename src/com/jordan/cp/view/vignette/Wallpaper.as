package com.jordan.cp.view.vignette {
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.loaders.QueueLoadItem;
	import com.jasontighe.loaders.QueueLoader;
	import com.jasontighe.loaders.events.QueueLoadItemEvent;
	import com.jasontighe.navigations.INavItem;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.MediaDTO;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	/**
	 * @author jason.tighe
	 */
	public class Wallpaper 
	extends AbstractVignette
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var ICON_X							: uint = 293;
		protected static var ICON_Y							: uint = 63;
		protected static var DOWNLOAD_X						: uint = 32;
		protected static var DOWNLOAD_Y						: uint = 115;
		protected static var PREVIEW_BG_X					: uint = 31;
		protected static var PREVIEW_BG_Y					: uint = 168;
		protected static var PREVIEW_BG_WIDTH				: uint = 528;
		protected static var PREVIEW_BG_HEIGHT				: uint = 328;
		protected static var COLOR_BLACK					: uint = 0x000000;
		protected static var COLOR_GREY						: uint = 0x464646;
		protected static var DEVICE_NAV_X					: uint = 30;
		protected static var DEVICE_NAV_Y					: uint = 103;
		protected static var SIZES_NAV_X					: uint = 33;
		protected static var SIZES_NAV_Y					: uint = 142;
		protected static var THUMB_NAV_X					: uint = 594;
		protected static var THUMB_NAV_Y					: uint = 188;
		protected static var CLOSE_X						: uint = 378;
		protected static var CLOSE_Y						: uint = 576;
		protected static var EXIT_X							: uint = 333;
		protected static var EXIT_Y							: uint = 515;
		protected static var ZIP_BASE						: String = "CP3on3_";
		protected static var IPHONE_EXT						: String = "iPhone_";
		protected static var IPAD_BASE						: String = "iPad_";
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _contentModel							: ContentModel;
		protected var _urlString							: String;
		protected var _urlStringAppend						: String;
		protected var _wallpaperType						: String;
		protected var _currentDevice						: String;
		protected var _thumbId								: uint = 0;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon										: MovieClip;
		public var titleTxt									: AutoTextContainer;
		public var deviceArray								: Array;
		public var sizesArray								: Array;
		public var sizesNavArray							: Array = new Array();
		public var previewArray								: Array = new Array();
		
		public var imagesArray								: Array = new Array();
		public var desktopArray								: Array = new Array();
		public var iphoneArray								: Array = new Array();
		public var ipadArray								: Array = new Array();
		public var twitterArray								: Array = new Array();
		
		public var deviceNav								: WallpaperDeviceNav;
		public var sizesNav									: WallpaperSizesNav;
		public var currentSizeNav							: WallpaperSizesNav;
		public var thumbNav									: WallpaperThumbNav;
		public var desktopNav								: Nav;
		public var iphoneNav								: Nav;
		public var ipadNav									: Nav;
		public var twitterNav								: Nav;
		public var deviceNavsArray							: Array;
		public var previewBg								: Box;
		public var previewBorder							: Box;
		public var tf										: TextField;
//		public var downloadBtn								: WallpaperDownloadButton;
		public var previewHolder							: MovieClip;
//		public var background								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Wallpaper()
		{
			super();
			_contentModel = ContentModel.gi;
//			init();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace("WALLPAPER : init()");
			
			var navs : Array = _contentModel.getContentItemByName( "wallpaper" ).navs;   
			  
			deviceArray = _contentModel.getContentItemByName( "wallpaper" ).navNames;
			trace("WALLPAPER : init() : deviceArray.length is "+deviceArray.length );
			if( deviceArray.length == navs.length )	deviceArray.splice( 0, 1 );
			
			// ADD ARRAY OF MediaDTOs TO ARRAYS
			sizesArray = new Array( imagesArray, desktopArray, iphoneArray, ipadArray, twitterArray );
			
			var i : uint;
			var I : uint;
			
			i = 0;
			I = navs.length;
			for( i; i < I; i++)
			{	
				var navArray : Array = navs[ i ];
				var sizeArray : Array = sizesArray[ i ];
				sizeArray.push( navArray );
			}
			
			desktopNav = new Nav();
			iphoneNav = new Nav();
			ipadNav = new Nav();
			twitterNav = new Nav();
			
			deviceNavsArray = new Array( desktopNav, iphoneNav, ipadNav, twitterNav );
			
			background.alpha = 0;
			
			addViews();
		}
		
		public override function populateByDTO( dto : ContentDTO ) : void
		{
			
		}
		
		//----------------------------------------------------------------------------
		// public function
		//----------------------------------------------------------------------------
		//----------------------------------------------------------------------------
		// protected function
		//----------------------------------------------------------------------------
		protected override function addViews() : void
		{
//			trace("WALLPAPER : addViews()");
			addCopy();
			addVisualAssets();
			addDeviceNav();
			addSizesNav();
			addThumbNav();
			addExitButton();
			positionExitButton( EXIT_X, EXIT_Y );
		}
		
		protected function addCopy() : void
		{
//			trace("WALLPAPER : addCopy()");
			var id : String = "wallpaper-title";
			var dto : CopyDTO = _contentModel.getCopyDTOByName( id ) as CopyDTO;
			titleTxt = new AutoTextContainer( );
			titleTxt.populate( dto, id );
			addChild( titleTxt );
		}
		
		protected function addVisualAssets() : void
		{
//			trace("WALLPAPER : addVisualAssets()");
			icon = MovieClip( AssetManager.gi.getAsset( "ComputerArrowAsset", SiteConstants.ASSETS_ID ) );
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChild( icon );
			
//			downloadBtn = new WallpaperDownloadButton();
//			downloadBtn.x = DOWNLOAD_X
//			downloadBtn.y = DOWNLOAD_Y;
//			deactivateDownloadBtn()
//			addChild( downloadBtn );
			
			previewBorder = new Box( PREVIEW_BG_WIDTH + 2, PREVIEW_BG_HEIGHT + 2, COLOR_GREY );
			previewBorder.x = PREVIEW_BG_X - 1;
			previewBorder.y = PREVIEW_BG_Y - 1;
			addChild( previewBorder );
			
			previewBg = new Box( PREVIEW_BG_WIDTH, PREVIEW_BG_HEIGHT, COLOR_BLACK );
			previewBg.x = PREVIEW_BG_X;
			previewBg.y = PREVIEW_BG_Y;
			addChild( previewBg );
		}
		
		protected function addDeviceNav() : void
		{
//			trace("WALLPAPER : addDeviceNav()");
			deviceNav = new WallpaperDeviceNav();
			deviceNav.addNav( deviceArray );
			deviceNav.x = DEVICE_NAV_X;
			deviceNav.y = DEVICE_NAV_Y;
			deviceNav.addEventListener( Event.COMPLETE, onDeviceNavClicked )
			addChild( deviceNav );
		}
		
		protected function addSizesNav() : void
		{
			sizesArray.splice( 0, 1 );
			var i : uint = 0;
			var I : uint = sizesArray.length;
			for( i; i < I; i++)
			{	
				addSizeNav( i );
			}
		}
		
		protected function addSizeNav( id : uint = 0 ) : void
		{
			var id : uint = id + 1
			var sizesNav : WallpaperSizesNav = new WallpaperSizesNav();
			
			var sizeArray : Array = new Array();
			var navArray : Array = _contentModel.getContentItemByName( "wallpaper" ).getNavsItemAt( id ); 
			
			var i : uint;
			var I : uint;
			
			i = 0;
			I = navArray.length;
			for( i; i < I; i++)
			{	
				var dto : MediaDTO = navArray[ i ] as MediaDTO;
				var name : String = dto.name;
				sizeArray.push( name );
			}
			
			sizesNav.addNav( sizeArray );
			sizesNav.navArray = navArray;
			sizesNav.navId = id
			sizesNav.x = SIZES_NAV_X;
			sizesNav.y = SIZES_NAV_Y;
			sizesNav.addEventListener( Event.COMPLETE, onSizesNavClicked )
			addChild( sizesNav );
			sizesNav.visible = false;
			sizesNavArray.push( sizesNav );
		}
		
		protected function showSizeNav( id : uint = 0 ) : void
		{
			if( currentSizeNav != null )	currentSizeNav.transitionOut();
			var nav : WallpaperSizesNav = sizesNavArray[ id ] as WallpaperSizesNav;
			nav.visible = true;
			nav.transitionIn();
			currentSizeNav = nav;
		}
		
		protected function addThumbNav() : void
		{
			thumbNav = new WallpaperThumbNav();
			
			var array : Array = ContentModel.gi.getContentItemByName( "wallpaper" ).getNavsItemAt( 0 ); 
			thumbNav.addNav( array );
			thumbNav.x = THUMB_NAV_X;
			thumbNav.y = THUMB_NAV_Y;
			thumbNav.addEventListener( Event.COMPLETE, onThumbNavClicked )
			addChild( thumbNav );
			
			var dto : MediaDTO = array[ 0 ] as MediaDTO;
			_urlStringAppend = dto.name;
			
			addPreviewImages( array );
		}
		
		protected function addPreviewImages( array : Array ) : void
		{
			previewHolder = new MovieClip();
			previewHolder.x = PREVIEW_BG_X;
			previewHolder.y = PREVIEW_BG_Y;
			addChild( previewHolder );
			
			var queueLoader : QueueLoader = new QueueLoader();
			var j : uint = 0;
			var J : uint = array.length;
			for( j; j < J; j++ )
			{
				var imageURL : String = array[ j ].imageURL;
				var imageLoadItem : QueueLoadItem = new QueueLoadItem( imageURL, onImageLoadComplete );
				imageLoadItem.setId( j );
				queueLoader.add( imageLoadItem );
			}
			queueLoader.load();
		}
		
		protected function showPreviewImage( id : uint ) : void
		{
			var i : uint = 0;
			var I : uint = previewArray.length;
			for( i; i < I; i++)
			{	
				var image : DisplayContainer = previewArray[ i ];
				if( id == i )
				{
					image.show( SiteConstants.NAV_TIME_IN );
				}
				else
				{
					image.hide( SiteConstants.NAV_TIME_OUT );
				}
			}
		}
		
		protected function downloadWallpaper() : void
		{
			var url : String = getURLString();
			trace("WALLPAPER : downloadWallpaper() : url is "+url );
			var request : URLRequest = new URLRequest( url );
			navigateToURL(request, "_blank");
		}
		
		protected function doTracking(  ) : void
		{
			trace("WALLPAPER : doTracking() : _thumbId is "+_thumbId );
			var calls : Array = new Array( TrackingConstants.WALLPAPERS_01,
			 							   TrackingConstants.WALLPAPERS_02,
			 							   TrackingConstants.WALLPAPERS_03);
			 							   
			var call : String = calls[ _thumbId ];
			TrackingManager.gi.trackCustom( call );
		}
		
		protected function getURLString() : String
		{
			var url : String = _urlString + "_" + _urlStringAppend + ".zip";
			return url;
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onDeviceNavClicked( e : Event ) : void
		{
			var deviceNav : WallpaperDeviceNav = e.target as WallpaperDeviceNav; 
			var id : uint = deviceNav.id;   
			showSizeNav( id );
//			deactivateDownloadBtn();
			_currentDevice = deviceNav.name;
			trace("WALLPAPER : onDeviceNavClicked() : _currentDevice is "+_currentDevice );
		}
		
		protected function onSizesNavClicked( e : Event ) : void
		{
			var deviceNav : WallpaperSizesNav = e.target as WallpaperSizesNav; 
			var id : uint = deviceNav.id;  
			var navId : uint = deviceNav.navId; 
			_urlString = deviceNav.url;
			downloadWallpaper();
			doTracking();
//			trace("WALLPAPER : onSizesNavClicked() : id is "+id );
//			trace("WALLPAPER : onSizesNavClicked() : navId is "+navId );
//			trace("WALLPAPER : onSizesNavClicked() : _urlString is "+_urlString );
		}
		
		protected function onThumbNavClicked( e : Event ) : void
		{
			var deviceNav : WallpaperThumbNav = e.target as WallpaperThumbNav; 
			var id : uint = deviceNav.id;   
			_thumbId = id;
			showPreviewImage( id );
			_urlStringAppend = deviceNav.name;
//			deactivateDownloadBtn();
//			trace("WALLPAPER : onThumbNavClicked() : id is "+id );
//			trace("WALLPAPER : onThumbNavClicked() : deviceNav.name is "+deviceNav.name );
		}
		
		protected function onDownloadClick( e : Event ) : void
		{
			downloadWallpaper();
		}
		
		protected function onImageLoadComplete( e : QueueLoadItemEvent ) : void
		{
//			trace( "WALLPAPER : onImageLoadComplete() :  **** IMAGE HAS LOADED" );
			var container : DisplayContainer = new DisplayContainer;
			container.addChild( e.loadItem.content )
			previewHolder.addChild( container );
			previewArray.push( container );
			
			var nav : Nav = thumbNav.nav;
			var id : uint = previewArray.length - 1
			if( id == 0 )
			{
//				trace( "WALLPAPER : onImageLoadComplete() :  **** id is "+id );
				var item : INavItem = nav.getItemAt( id );
//				trace( "WALLPAPER : onImageLoadComplete() :  **** item is "+item );
				item.setActiveState( );
			}
			else
			{
				container.hide();
			}
		}
		
//		protected function activateDownloadBtn() : void
//		{
//			downloadBtn.addEventListener( Event.COMPLETE, onDownloadClick)
//			downloadBtn.activate(); 
//		}
		
//		protected function deactivateDownloadBtn() : void
//		{
//			downloadBtn.removeEventListener( Event.COMPLETE, onDownloadClick)
//			downloadBtn.deactivate(); 
//		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set dto( object : ContentDTO ) : void
		{
			_dto = object;
		}
	}
}
