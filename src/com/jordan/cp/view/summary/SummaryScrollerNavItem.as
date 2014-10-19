package com.jordan.cp.view.summary {
	import com.greensock.TweenMax;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;

	/**
	 * @author jason.tighe
	 */
	public class SummaryScrollerNavItem 
	extends NavItem 
	{
//		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var titleTxt								: TextContainer;
		public var background							: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryScrollerNavItem( ) 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function addViews( s : String ) : void
		{
			addBackground();
			addCopy( s );
			resizeBackground();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addBackground() : void
		{
			background = new Box( 1, 1 );
			background.alpha = 0;
			addChild( background );
		}

		protected function addCopy( s : String ) : void
		{
			titleTxt = new TextContainer();
			var s : String = s.toUpperCase();
			titleTxt.populate( s, 'summary-scroll-inactive' );
			addChild( titleTxt );
		}
		
		protected function resizeBackground() : void
		{
			background.width = width;
			background.height = height;
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
		protected function doOverState( ) : void
		{
				TweenMax.to( titleTxt, SiteConstants.NAV_TIME_IN, { tint: 0xFFFFFF } );
		}

		protected function doOutState( ) : void
		{
				TweenMax.to( titleTxt, SiteConstants.NAV_TIME_OUT, { tint: 0x464646 } );
		}
		
		protected function doClickState( ) : void
		{
			TweenMax.to( titleTxt, 0, { tint: 0xFFFFFF } );
		}

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
	}
}