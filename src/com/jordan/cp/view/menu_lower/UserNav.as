package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.Nav;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.view.AbstractNav;
	import com.jordan.cp.view.menu_lower.events.NavEvent;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jason.tighe
	 */
	public class UserNav 
	extends AbstractNav 
	{
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static const USER_NAV_WIDTH					: uint = 349;
		public static const X_SPACE							: uint = 20;
		public static const PAUSE_TIME						: uint = 5000;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _tm									: TrackingManager = TrackingManager.gi;
		protected var _nav									: Nav;
		protected var _navWidth								: Number;
		protected var _timer								: Timer;
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var navArray								: Array;
		private var subNavArray								: Array;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var help										: Help;
//		public var divider0									: MovieClip;
		public var settings									: Settings;
//		public var divider1									: MovieClip;
		public var share									: Share;
		public var bandwidthNav								: SettingsBandwidthNav;
		public var socialNav								: SettingsSocialNav;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function UserNav() 
		{
			trace( "USERNAV : Constr" );
			super();
//			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "USERNAV : init()" );
			_navWidth = USER_NAV_WIDTH;
			
			navArray = new Array( help, settings, share );
			
			addNav();
			
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var navItem : UserNavItem = navArray[ i ];
				navItem.id = i;
				navItem.init();
				navItem.setX( navItem.x );
				navItem.setWidth( navItem.width );
			}
			
			subNavArray = new Array( bandwidthNav, socialNav );
			var j : uint = 0;
			var J : uint = subNavArray.length;
			for( j; j < J; j++ )
			{
				var subNavItem : AbstractNav = subNavArray[ j ];
				trace( "USERNAV : init() : subNavItem is "+subNavItem );
				trace( "USERNAV : init() : _stateModel is "+_stateModel );
				trace( "USERNAV : init() : _jsBridge is "+_jsBridge );
				subNavItem.id = j;
				subNavItem.setX( subNavItem.x );
				subNavItem.setWidth( subNavItem.width );
				subNavItem.jsBridge = _jsBridge;
				subNavItem.stateModel = _stateModel;
				subNavItem.init();
				subNavItem.hide();
			}
		}
		
		public override function activate() : void
		{
//			trace( "USERNAV : activate()" );
			_nav.enable();
		}
		
		public override function deactivate() : void
		{
//			trace( "USERNAV : deactivate()" );
			_nav.disable();
		}
		
		public function resetMainNav() : void
		{
			_nav.reset();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function activateItem( item : * ) : void
		{
			item.mouseEnabled = true;
			item.mouseChildren = false;
			item.buttonMode = true;
			item.useHandCursor = true;
		}
		
		protected function deactivateItem( item : * ) : void
		{
			item.mouseEnabled = false;
			item.mouseChildren = false;
			item.buttonMode = false;
			item.useHandCursor = false;
		}
		
		protected function addNav() : void
		{
//			trace( "USERNAV : addNav()" );
			_nav = new Nav();
			var item : UserNavItem;
			var last : UserNavItem;
			var i : uint = 0;
			var I : uint = navArray.length;
			var lastItem : uint = I - 1;
			
			for( i; i < I; i++ )
			{
				item = navArray[ i ];
				item.setIndex( i );
				item.init();
				item.setOutState();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
//				item.setOutState(); 
				
				_nav.add( item );
				_nav.addChild( item );
			}
			
//			_nav.disable();			
			_nav.enable();

			_nav.init();
			addChild( _nav );
		}
		
		protected function onNavItemOver( e : Event = null ) : void
		{
			var item : UserNavItem = e.target as UserNavItem;
			item.setOverState();
//			trace( "USERNAV : onMouseOver() : item is "+item );
		}
		
		protected function onNavItemOut( e : Event = null ) : void
		{
			var item : UserNavItem = e.target as UserNavItem;
			item.setOutState();
//			trace( "USERNAV : onMouseOut() : item is "+item );
		}
		
		protected function startTimer() : void
		{
			_timer = new Timer( PAUSE_TIME );
			_timer.addEventListener( TimerEvent.TIMER, onTimerComplete );
			_timer.start();
		}
		
		protected function stopTimer() : void
		{
			_timer.removeEventListener( TimerEvent.TIMER, onTimerComplete );
			_timer.stop();
		}
		
		protected function onTimerComplete( e : TimerEvent ) : void
		{
			_timer.removeEventListener( TimerEvent.TIMER, onTimerComplete );
			closeNav();
		}
		
		protected function closeNav( ) : void
		{
			updateNav( 0 );
			showSubNav( 0 );
			resetMainNav();
			dispatchCompleteEvent();
		}
		
		protected function onNavItemClick( e : Event = null ) : void
		{
			var item : UserNavItem = e.target as UserNavItem;
			item.setActiveState();
			_nav.setActiveItem( item );
			trace( "\n\nUSERNAV : onNavItemClick() : item is "+item );
			var id : uint = item.id;
			trace( "USERNAV : onNavItemClick() : id is "+id );
			switch ( item ) 
			{
				case help:
				    updateNav( id );
					showSubNav( id );
					dispatchCompleteEvent();
					_stateModel.state =  StateModel.STATE_HELP;
					break;
				case settings:
				    updateNav( id );
					showSubNav( id ); // 0
					dispatchCompleteEvent();
					startTimer();
					_tm.trackPage(TrackingConstants.SETTINGS_OVERLAY );
					break;
				case share:
				    updateNav( id );
					showSubNav( id ); // 1
					dispatchCompleteEvent();
					startTimer();
					_tm.trackPage(TrackingConstants.SHARE_OVERLAY );
					break;
			}
		}
		
		protected function updateNav( id : uint ) : void
		{
			trace( "USERNAV : updateNav() : id is "+id );
			_navWidth = USER_NAV_WIDTH;
			
			var i : uint = 0;
			var I : uint = navArray.length;
			var middleId : uint = navArray.length - 2;
			var lastItem : uint = navArray.length - 1;
			trace( "USERNAV : updateNav() : middleId is "+middleId );
			trace( "USERNAV : updateNav() : lastItem is "+lastItem );
			for( i; i < I; i++ )
			{
				var navItem : UserNavItem = navArray[ i ];
				var xPos : Number = navItem.getX();
				trace( "USERNAV : updateNav() : xPos is "+xPos );
				
				// IF THE MIDDLE ( SETTINGS ) IS SELECTED, SHIFT THE LAST NAV ITEM ( SHARE )
				if( id == ( middleId ) && ( i == lastItem )  )
				{
					var subNavItem : AbstractNav = subNavArray[ 0 ];
					xPos +=  subNavItem.getWidth() + X_SPACE;
					
					trace( "USERNAV : updateNav() : ADJSUTED X POS! : xPos is "+xPos );
				}
				
				TweenLite.to( navItem, SiteConstants.NAV_TIME_IN, { x: xPos, ease: Quad.easeOut } );
			}
		}
		
		protected function showSubNav( navId : uint ) : void
		{
			trace( "USERNAV : showSubNav() : navId is "+navId );
			// Get subnav properties if nav clicked is not help ( navId = 0 )
			var subNavId : int = navId - 1;
			if( navId > 0 )
			{
				var subNavItem : AbstractNav = subNavArray[ subNavId ];
				var subNavItemX : Number = navArray[ navId ].getX() + navArray[ navId].width;
				var subNavItemWidth : Number = subNavItem.width;
				_navWidth = subNavItemWidth + USER_NAV_WIDTH;
				subNavItem.x = subNavItemX;
//				subNavItem.show( SiteConstants.NAV_TIME_IN );

				//IF SHARE IS SELECTED AND BANDWIDTH WSA PREVIOUS SELECTED, SET MASK TRANSITION
				var navItem : UserNavItem = navArray[ navId ];
				if( navId == 2 && navItem.x != navItem.getX() )	subNavItem.direction = subNavItem.RIGHT;
				subNavItem.transitionIn( );
				subNavItem.addEventListener( Event.COMPLETE, onSubNavClick );
				subNavItem.addEventListener( NavEvent.INTERACTING, onSubNavInteracting );
				
				
				trace( "USERNAV : showSubNav() : subNavItem is "+subNavItem );
				subNavItem.activate();
				
				// ADD PADDING IF SETTINGS IS SELECTED
				if( navId == 1 )	_navWidth += X_SPACE;
			}
			
			trace( "USERNAV : showSubNav() : _navWidth is "+_navWidth );
			trace( "USERNAV : showSubNav() : navArray[ navId ].width is "+navArray[ navId ].width );
			
			hideSubNav( subNavId );
		}
		
		protected function hideSubNav( id : int = -1 ) : void
		{
			trace( "USERNAV : hideSubNav() : id is "+id );
			var i : uint = 0;
			var I : uint = subNavArray.length;
			for( i; i < I; i++ )
			{
				var subNavItem : AbstractNav = subNavArray[ i ];
				if( subNavItem.id != id )
				{
					subNavItem.hide( SiteConstants.NAV_TIME_OUT );
//					subNavItem.transitionOut( );
					subNavItem.deactivate();
				}
			}
		}
		
		protected function onSubNavInteracting( e : NavEvent ) : void
		{
			trace( "USERNAV : onSubNavInteracting() ................" );
			stopTimer();
			startTimer();
		}
		
		protected function onSubNavClick( e : Event ) : void
		{
			trace( "USERNAV : onSubNavClick() ................" );
			stopTimer();
			closeNav();
		}
		
		protected function dispatchCompleteEvent() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) ); 
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get navWidth() : uint
		{
			return _navWidth;
		}
		
		public function set navWidth( n : uint ) : void
		{
			_navWidth = n;
		}
	}
}
