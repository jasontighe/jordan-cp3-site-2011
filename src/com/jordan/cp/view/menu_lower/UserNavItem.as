package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenMax;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.navigations.NavItem;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class UserNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected const ICON_COLOR_OVER						: uint = 0xD7270A;
		protected const ICON_COLOR_OUT						: uint = 0x464646;
		protected const TEXT_COLOR_OVER						: uint = 0xFFFFFF;
		protected const TEXT_COLOR_OUT						: uint = 0x464646;
		//----------------------------------------------------------------------------
		// protected variable
		//----------------------------------------------------------------------------
		protected var _id									: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var copyTxt									: AutoTextContainer;
		public var icon										: AbstractIcon;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function UserNavItem() 
		{
			super();
			init();
		}

		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
		}
		
		public override function setOverState( active : int = -1 ) : void 
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_IN, { tint: ICON_COLOR_OVER } );
			TweenMax.to( copyTxt, SiteConstants.NAV_TIME_IN, { tint: TEXT_COLOR_OVER } );
		}

		public override function setOutState() : void 
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_OUT, { tint: ICON_COLOR_OUT } );
			TweenMax.to( copyTxt, SiteConstants.NAV_TIME_OUT, { tint: TEXT_COLOR_OUT } );
		}
		
		public override function setActiveState( active : int = -1 ) : void 
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_IN, { tint: ICON_COLOR_OVER } );
			TweenMax.to( copyTxt, SiteConstants.NAV_TIME_IN, { tint: TEXT_COLOR_OVER } );
		}
		
		public override function setInactiveState( ) : void
		{
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id( ) : uint
		{
			return _id;
		}
		
		public function set id( n : uint ) : void
		{
			_id = n;
		}
	}
}
