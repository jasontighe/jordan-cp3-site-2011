package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.view.AbstractNav;
	import com.jordan.cp.view.menu_lower.events.NavEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class SettingsSocialNav 
	extends AbstractNav 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected const BG_COLOR						: uint = 0x181818;
		protected const BG_COLOR_INIT					: uint = 0x515151;
		protected var _tm									: TrackingManager = TrackingManager.gi;
		protected var navArray							: Array;
//		protected var _stateModel						: StateModel;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var facebook								: SettingsFacebook;
		public var twitter								: SettingsTwitter;
		public var email								: SettingsEmail;
		public var background							: MovieClip;
		public var masker								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SettingsSocialNav() 
		{
			trace( "SETTINGSSOCIALNAV : Constr" );
			super();
//			init();
		}
		
		public override function init() : void
		{
			trace( "SETTINGSSOCIALNAV : init()" );
			navArray = new Array( twitter, facebook, email );
			masker = new Box( background.width, background.height );
			addChild( masker );
			this.mask = masker;
			_direction = LEFT;
//			addNav();
		}
		
		public override function transitionIn() : void
		{
//			show( SiteConstants.NAV_TIME_IN );
			show();
			
			var xPos : Number = -masker.width;
			var timeOffset : Number;
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var navItem : SettingsSocialNavItem = navArray[ i ];
				navItem.hide();
				timeOffset = ( SiteConstants.NAV_TIME_IN * .4  ) * ( i + .5 );
				navItem.show( SiteConstants.NAV_TIME_IN, timeOffset );
			}
			
			if( _direction == RIGHT )
			{
				xPos = masker.width;
				_direction = LEFT;
			}
			
			TweenMax.from( masker, SiteConstants.NAV_TIME_IN, { x: xPos, ease:Quad.easeOut, onComplete: transitionInComplete } );
			TweenMax.from( background, SiteConstants.NAV_TIME_IN, { tint: BG_COLOR_INIT } );
		}
		
		public override function transitionOut() : void
		{
//			show( SiteConstants.NAV_TIME_OUT );
			TweenMax.to( masker, SiteConstants.NAV_TIME_IN, { x: -masker.width, ease:Quad.easeOut, onComplete: transitionOutComplete } );
			TweenMax.to( background, SiteConstants.NAV_TIME_IN, { tint: BG_COLOR_INIT } );
		}
		
		public override function activate() : void
		{
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var navItem : SettingsSocialNavItem = navArray[ i ];
				navItem.init();
				setActiveState( navItem );
				navItem.addEventListener( MouseEvent.MOUSE_OVER, onNavItemOver );
				navItem.addEventListener( MouseEvent.MOUSE_OUT, onNavItemOut );
				navItem.addEventListener( MouseEvent.CLICK, onNavItemClick );
			}
		}
		
		public override function deactivate() : void
		{
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var navItem : SettingsSocialNavItem = navArray[ i ];
				setInactiveState( navItem );
				navItem.removeEventListener( MouseEvent.MOUSE_OVER, onNavItemOver );
				navItem.removeEventListener( MouseEvent.MOUSE_OUT, onNavItemOut );
				navItem.removeEventListener( MouseEvent.CLICK, onNavItemClick );
			}
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function doFaceBook( ) : void
		{
			_jsBridge.doSocial( SiteConstants.SHARE_FACEBOOK );
			_tm.trackCustom(TrackingConstants.SHARE_FB );
		}
		
		protected function doTwitter( ) : void
		{
			_jsBridge.doSocial( SiteConstants.SHARE_TWITTER );

			_tm.trackCustom(TrackingConstants.SHARE_TWITTER );
		}
		
		protected function doEmail( ) : void
		{
			trace( "SETTINGSSOCIALNAV : doEmail() : _stateModel is "+_stateModel );
			_stateModel.state = StateModel.STATE_EMAIL;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : MouseEvent ) : void
		{
			var item : SettingsSocialNavItem = e.target as SettingsSocialNavItem;
			item.setOutState();
		}
		
		protected function onNavItemOver( e : MouseEvent ) : void
		{
			var item : SettingsSocialNavItem = e.target as SettingsSocialNavItem;
			item.setOverState();
			dispatchEvent( new NavEvent( NavEvent.INTERACTING ) );
		}
		
		protected function onNavItemClick( e : MouseEvent ) : void
		{
			var item : SettingsSocialNavItem = e.target as SettingsSocialNavItem;
			trace( "SETTINGSSOCIALNAV : onNavItemClick() : item is "+item );
			
			switch( item )
			{
				case facebook:
					doFaceBook();
					break;
				case twitter:
					doTwitter();
					break;
				case email:
					doEmail();
					break;
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function setActiveState( navItem : SettingsSocialNavItem ) : void
		{
			navItem.buttonMode = true;
			navItem.mouseEnabled = true;
			navItem.mouseChildren = false;
			navItem.useHandCursor = true;
		}
		
		protected function setInactiveState( navItem : SettingsSocialNavItem ) : void
		{
			navItem.buttonMode = false;
			navItem.mouseEnabled = false;
			navItem.mouseChildren = false;
			navItem.useHandCursor = false;
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public override function set stateModel( object : StateModel ) : void
		{
			trace( "SETTINGSSOCIALNAV : set stateModel .......... : object is "+object );
			_stateModel = object;
			trace( "SETTINGSSOCIALNAV : set _stateModel .......... : _stateModel is "+_stateModel );
		}
	}
}
