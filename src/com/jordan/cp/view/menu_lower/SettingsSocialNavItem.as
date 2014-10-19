package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenMax;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class SettingsSocialNavItem 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _iconColorOver					: uint = 0xFFFFFF;
		protected var _iconColorOut						: uint = 0x464646;
		protected var _textColorOver					: uint = 0xFFFFFF;
		protected var _textColorOut						: uint = 0x464646;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon									: MovieClip;
		public var copyTxt								: AutoTextContainer;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SettingsSocialNavItem() 
		{
			super();
		}
		
		public function setOverState( ) : void
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_IN, { tint: _iconColorOver } );
			TweenMax.to( copyTxt, SiteConstants.NAV_TIME_IN, { tint: _textColorOver } );
		}
		
		public function setOutState( ) : void
		{
			TweenMax.to( icon, SiteConstants.NAV_TIME_OUT, { tint: _iconColorOut } );
			TweenMax.to( copyTxt, SiteConstants.NAV_TIME_OUT, { tint: _textColorOut } );
		}
		
		public function setActiveState(  ) : void
		{
//			TweenMax.to( copyTxt, 0, { tint: COLOR_CLICK } );
			
			buttonMode = false;
			mouseEnabled = false;
			mouseChildren = false;
			useHandCursor = false;
		}
		
		public function setInactiveState( ) : void
		{
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get iconColorOver( ) : uint
		{
			return _iconColorOver;
		}
		
		public function set iconColorOver( n : uint ) : void
		{
			_iconColorOver = n;
		}
		
		public function get iconColorOut( ) : uint
		{
			return _iconColorOut;
		}
		
		public function set iconColorOut( n : uint ) : void
		{
			_iconColorOut = n;
		}
		
		public function get textColorOver( ) : uint
		{
			return _textColorOver;
		}
		
		public function set textColorOver( n : uint ) : void
		{
			_textColorOver = n;
		}
		
		public function get textColorOut( ) : uint
		{
			return _textColorOut;
		}
		
		public function set textColorOut( n : uint ) : void
		{
			_textColorOut = n;
		}
	}
}
