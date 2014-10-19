package com.jordan.cp.view.summary {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author jason.tighe
	 */
	public class SummarySceneNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		//TODO TEMP, PULL FROM content.xml
		protected static var BORDER_COLOR				: uint = 0x000000;
		protected static var BORDER_ALPHA				: Number = .29;
		protected static var BORDER_WIDTH				: uint = 154;
		protected static var BORDER_HEIGHT				: uint = 90;
		protected static var BORDER_X					: uint = 1;
		protected static var BORDER_Y					: uint = 18;
		protected static var OVERLAY_COLOR				: uint = 0x000000;
		protected static var OVERLAY_ALPHA				: Number = .35;
		protected static var ARROW_ICON_SCALE			: Number = .75;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		protected var _isUnlocked						: Boolean = false;
		protected var BORDER_CONTENT_Y					: uint = 12;
		protected var arrow								: MovieClip; //from AssetManager
		protected var arrowIcon							: MovieClip;
		protected var arrowBg							: MovieClip;
		protected var lock								: MovieClip;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var numeratorTxt							: TextContainer;
		public var border								: Box;
		public var imageBg								: Box;
		public var imageHolder							: MovieClip;
		public var imageOverlay							: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummarySceneNavItem( ) 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function addViews( ) : void
		{
			addNumerator();
			addBorder();
			addImageBg()
		}
		
		public function addImage( url : String ) : void
		{
			imageHolder = new MovieClip();
			addChild( imageHolder );
			imageHolder.x = imageBg.x;
			imageHolder.y = imageBg.y;
			
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageLoaded );
			loader.load( new URLRequest( url ) );
			imageHolder.addChild( loader );
		}

		public override function setOverState ( active : int = -1 ) : void
		{
			doOverState();
		}

		public override function setOutState () : void
		{
			doOutState();
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
			doClickState();
		}

		public override function setInactiveState () : void
		{
		}
		
		public function resetInactive() : void
		{
//			trace( "SUMMARYSCENENAVITEM : resetInactive()" );
			if( arrowIcon && contains( arrowIcon ) ) 
			{
				arrow.visible = false;
				TweenMax.to( arrowBg, 0, { tint: OVERLAY_COLOR });
			}
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addNumerator() : void
		{
			numeratorTxt= new TextContainer();
			var s : String = ".0" + ( getIndex() + 1 );
			numeratorTxt.populate( s.toUpperCase(), "summary-active-title");
			addChild( numeratorTxt );
		}
		
		protected function addBorder() : void
		{
			border = new Box( BORDER_WIDTH, BORDER_HEIGHT, BORDER_COLOR );
			border.alpha = BORDER_ALPHA;
			addChild( border );
			border.x = BORDER_X;
			border.y = BORDER_Y;
			addChild( border );
		}
		
		protected function addImageBg() : void
		{
			imageBg = new Box( BORDER_WIDTH - 2, BORDER_HEIGHT - 2, BORDER_COLOR );
			imageBg.x = BORDER_X + 1;
			imageBg.y = BORDER_Y + 1;
			addChild( imageBg );
		}
		
		protected function addImageLock() : void
		{
			if( lock && contains( lock ) )
				return;
			lock = MovieClip( AssetManager.gi.getAsset( "SummaryIconSceneLockedAsset", SiteConstants.ASSETS_ID ) );
			lock.x = ( ( imageBg.x + imageBg.width ) * .5 ) - ( lock.width * .5 );
			lock.y = ( imageBg.y + imageBg.height ) * .5;;
			addChild( lock );
		}
		
		protected function addImageOverlay() : void
		{
			imageOverlay = new Box( imageHolder.width, imageHolder.height, BORDER_COLOR );
			imageOverlay.x = imageHolder.x;
			imageOverlay.y = imageHolder.y;
			imageOverlay.alpha = OVERLAY_ALPHA;
			addChild( imageOverlay );
		}
		
		protected function addArrow() : void
		{
			arrow = MovieClip( AssetManager.gi.getAsset( "SummaryVideoButtonArrowAsset", SiteConstants.ASSETS_ID ) );
			arrow.x = border.x + Math.round( ( border.width - arrow.width ) * .5 );
			arrow.y = border.y + Math.round( ( border.height - arrow.height ) * .5 );
			addChild( arrow );
			
			arrowIcon = arrow.arrow;
			arrowBg = arrow.background;
			
			if( _isUnlocked )	setOutState();
		}
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onImageLoaded( e : Event ) : void
		{
//			trace( "SUMMARYSCENENAVITEM : onImageLoaded() : _isUnlocked is "+_isUnlocked );
			addImageOverlay();
			addArrow();
			if( !_isUnlocked )
			{
				resetInactive();
				addImageLock();
			}
		}
		
		protected function doOverState( ) : void
		{
			if( imageOverlay && contains( imageOverlay ) ) TweenMax.to( imageOverlay, SiteConstants.NAV_TIME_IN, { alpha: 0, ease: Quad.easeIn } );
			if( arrowBg && contains( arrowBg ) ) 
			{
				TweenMax.to( arrowBg, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED, ease: Quad.easeOut });
				TweenMax.to( arrowIcon, SiteConstants.NAV_TIME_IN * .6, { scaleX: 1, scaleY: 1, ease: Quad.easeIn });
			}
		}

		protected function doOutState( ) : void
		{
			if( imageOverlay && contains( imageOverlay ) ) TweenMax.to( imageOverlay, SiteConstants.NAV_TIME_OUT, { alpha: OVERLAY_ALPHA, ease: Quad.easeOut } );
			if( arrowBg && contains( arrowBg ) ) 
			{
				TweenMax.to( arrowBg, SiteConstants.NAV_TIME_OUT, { tint: OVERLAY_COLOR, ease: Quad.easeOut } );
				TweenMax.to( arrowIcon, SiteConstants.NAV_TIME_OUT, { scaleX: ARROW_ICON_SCALE, scaleY: ARROW_ICON_SCALE, ease: Quad.easeOut } );
			}
		}
		
		protected function doClickState( ) : void
		{
			if( arrow && contains( arrow ) ) arrow.visible = true;
			
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
		}

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set isUnlocked( boolean : Boolean ) : void
		{
//			trace( "SUMMARYSCENENAVITEM : set isUnlocked()" );
			_isUnlocked = boolean;
		}
	}
}
