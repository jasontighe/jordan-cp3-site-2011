package com.jordan.cp.view.summary {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.jordan.cp.view.summary.events.SummaryEvent;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummaryPanel 
	extends DisplayContainer 
	{
		//TODO TEMP, PULL FMOR content.xml
//		protected static var BONUS_SCENES_TEXT				: String = "Bonus Scenes";
		protected static var BONUS_SCENES_X					: uint = 19;
		protected static var BONUS_SCENES_Y					: uint = 45;
//		protected static var BONUS_CONTENT_TEXT				: String = "Bonus Content";
//		protected static var BONUS_CONTENT_X				: uint = 19;
//		protected static var BONUS_CONTENT_Y				: uint = 244;
		protected static var SCENE_NAV_X					: uint = 116;
		protected static var SCENE_NAV_Y					: uint = 75;
//		protected static var SCENE_NAV_X_SPACE				: uint = 194;
		protected static var CONTENT_NAV_X					: uint = 74;
		protected static var CONTENT_NAV_Y					: uint = 261;
		protected static var CONTENT_MASK_X					: uint = 24;
		protected static var CONTENT_MASK_Y					: uint = 254;
		protected static var SCROLLER_NAV_X					: uint = 327;
		protected static var SCROLLER_NAV_Y					: uint = 222;
		protected static var GRADIENT_OFFSET				: uint = 200;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _contentModel							: ContentModel;
		protected var _type									: String;
		protected var _id									: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var scenesTxt								: AutoTextContainer;
		public var contentTxt								: AutoTextContainer;
		public var background								: Box;
		public var sceneNav									: SummarySceneNav;
		public var contentNav								: SummaryContentNav;
		public var contentHolder							: MovieClip;
		public var scrollerNav								: SummaryScrollerNav;
		public var contentMask								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryPanel() 
		{
			super();
			_contentModel = ContentModel.gi;
			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
		}
		
		public function addViews() : void
		{
//			trace( "SUMMARYPANEL : addViews()" );
			addHolder();
			addScenesNav();
			addContentNav();
			addScrollerNav();
			addHeaders();
		}
		
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addHolder() : void
		{
			contentHolder = new MovieClip();
			addChild( contentHolder );
		}
		
		protected function addHeaders() : void
		{
			var scenesId : String = "summary-bonus-scenes"
			var scenesDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( scenesId ) as CopyDTO;
			scenesTxt = new AutoTextContainer( );
			scenesTxt.populate( scenesDTO, scenesId );
			addChild( scenesTxt );
			
			var contentId : String = "summary-bonus-content"
			var contentDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( contentId ) as CopyDTO;
			contentTxt = new AutoTextContainer( );
			contentTxt.populate( contentDTO, contentId );
			addChild( contentTxt );
		}
		
		protected function addScenesNav() : void
		{
//			trace( "SUMMARYPANEL : addScenesNav()" );
			sceneNav = new SummarySceneNav();
			sceneNav.addNav( _contentModel );
			sceneNav.x = SCENE_NAV_X;
			sceneNav.y = SCENE_NAV_Y;
			sceneNav.addEventListener( Event.COMPLETE, onSceneNavClicked )
			addChild( sceneNav );
		}
		
		protected function addContentNav() : void
		{
//			trace( "SUMMARYPANEL : addContentNav()" );
			contentNav = new SummaryContentNav();
			contentNav.addNav( );
			contentNav.x = CONTENT_NAV_X;
			contentNav.y = CONTENT_NAV_Y;
			contentNav.addEventListener( Event.COMPLETE, onContentNavClicked )
			addChild( contentNav );
			
			contentMask = MovieClip( AssetManager.gi.getAsset( "SummaryContentMaskAsset", SiteConstants.ASSETS_ID ) );
			contentMask.x = CONTENT_MASK_X;
			contentMask.y = CONTENT_MASK_Y;
			addChild( contentMask );
			
			contentNav.cacheAsBitmap = true;
			contentMask.cacheAsBitmap = true;
			contentNav.mask = contentMask;
		}

		protected function addScrollerNav() : void
		{
//			trace( "SUMMARYPANEL : addScrollerNav()" );
			scrollerNav = new SummaryScrollerNav();
			scrollerNav.addNav( 2 );
			scrollerNav.x = SCROLLER_NAV_X;
			scrollerNav.y = SCROLLER_NAV_Y;
			scrollerNav.addEventListener( Event.COMPLETE, onScrollerNavClicked )
			addChild( scrollerNav );
			
			
		}
		
		protected function dispatchSceneClickEvent() : void
		{
			dispatchEvent( new SummaryEvent( SummaryEvent.SCENE_CLICK));
		}
		
		protected function dispatchContentClickEvent() : void
		{
			dispatchEvent( new SummaryEvent( SummaryEvent.CONTENT_CLICK));
		}
		
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
			
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onSceneNavClicked( e : Event ) : void
		{
			var nav : SummarySceneNav = e.target as SummarySceneNav; 
			_id = nav.id;  
			trace("SUMMARYPANEL : onSceneNavClicked() : id is "+id );
			_type = SiteConstants.HOTSPOT_TYPE_SCENE;
			
			dispatchSceneClickEvent();
		}
		
		protected function onContentNavClicked( e : Event ) : void
		{
			var nav : SummaryContentNav = e.target as SummaryContentNav; 
			_id = nav.id;  
			trace("SUMMARYPANEL : onContentNavClicked() : id is "+id );
			_type = SiteConstants.HOTSPOT_TYPE_CONTENT;
			
			dispatchContentClickEvent();
		}
		
		protected function onScrollerNavClicked( e : Event ) : void
		{
			
			var nav : SummaryScrollerNav = e.target as SummaryScrollerNav; 
			var id : uint = nav.id;  
			var xPos : int = Math.round( -( id * contentNav.shiftX ) + CONTENT_NAV_X );
			TweenLite.to( contentNav, SiteConstants.NAV_TIME_IN, { x: xPos, ease: Quad.easeOut } );
//			
//			dispatchContentClickEvent();
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get type() : String
		{
			return _type;
		}
		
		public function get id() : uint
		{
			return _id;
		}
	}
}
