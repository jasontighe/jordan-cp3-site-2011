package com.jordan.cp.view.vignette {
	import com.greensock.TweenMax;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.MediaDTO;
	import com.plode.framework.containers.TextContainer;

	/**
	 * @author jason.tighe
	 */
	public class WallpaperSizesNavItem 
	extends NavItem 
	{
		protected var _dto									: MediaDTO;
		protected var _url									: String;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var sizeTxt									: TextContainer;
		public var background								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function WallpaperSizesNavItem() 
		{
			super();
		}
		// TODO SET TEXT, THEN RESIZE BACKGROUND
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			addViews();
		}
		
		public function addViews( s : String ) : void
		{
			addBackground();
			addCopy( s );
			resizeBackground( );
		}

		public override function setOverState ( active : int = -1 ) : void
		{
			doOverState()
		}

		public override function setOutState () : void
		{
			doOutState()
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
			doClickState();
		}

		public override function setInactiveState () : void
		{
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function addBackground() : void
		{
			background = new Box( 10, 10 );
			addChild( background );
			background.alpha = 0;
		}
		
		protected function addCopy( s : String ) : void
		{
			var sizeTxt : TextContainer = new TextContainer();
			sizeTxt.populate( s, 'wallpaper-sizes-inactive');
			addChild( sizeTxt );
		}
		
		protected function resizeBackground() : void
		{
			background.width = width;
			background.height = height;
		}
		
		protected function doOverState( ) : void
		{
			TweenMax.to( this, SiteConstants.NAV_TIME_IN, { tint: 0xFFFFFF } );
		}

		protected function doOutState( ) : void
		{
			TweenMax.to( this, SiteConstants.NAV_TIME_OUT, { tint: 0x464646 } );
		}
		
		protected function doClickState( ) : void
		{
			TweenMax.to( this, 0, { tint: 0xFFFFFF } );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set dto ( dto : MediaDTO ) : void
		{
			_dto = dto
		}
		
		public function get url ( ) : String
		{
			return _url;
		}
	}
}
