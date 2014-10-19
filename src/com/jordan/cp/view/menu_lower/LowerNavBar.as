package com.jordan.cp.view.menu_lower 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.util.JSBridge;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.players.TimeTracker;
	import com.jordan.cp.view.AbstractNav;
	import com.jordan.cp.view.AbstractOverlay;
	import com.jordan.cp.view.locks.Locks;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class LowerNavBar 
	extends AbstractOverlay 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var navArray								: Array;
		protected var _jsBridge								: JSBridge;
		protected var _contentModel							: ContentModel;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
//		public var socialNav								: SocialNav;
		public var userNav									: UserNav;
		public var utilNav									: UtilNav;
		public var locks									: Locks;
		public var background								: MovieClip;
		
		public function LowerNavBar() 
		{
			trace( "LOWERNAVBAR : Constr" );
			super();
			navArray = new Array( userNav, utilNav );

		}


		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "LOWERNAVBAR : init()" );
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var nav : * = navArray[ i ];
				nav.stateModel = _stateModel;
				nav.jsBridge = _jsBridge;
				nav.init();
			}
			
			addLocks();
			
			userNav.addEventListener( Event.COMPLETE, centerUserNav );
		}
		
		public override function transitionIn() : void
		{
			trace( "LOWERNAVBAR : transitionIn()" );
//			trace( "LOWERNAVBAR : transitionIn() : getHeight() is "+getHeight() );
			show();
			var yPos : uint = getHeight();
			TweenMax.from( this, SiteConstants.NAVBAR_TIME_IN, { y: yPos, ease: Quad.easeOut, onComplete: transitionInComplete  } );
		}
		
		public override function transitionOut() : void
		{
			
		}
		
		//Position all views after width (stageW) has been updated
		public override function updateViews(  stageW : uint, stageH : uint ) : void
		{
			setWidth( stageW );
			updateBackground();
			center();
			
			var yPos : uint = Math.round( stageH - SiteConstants.NAV_BAR_HEIGHT );
			y = yPos;
		}
		
		public function resetMainNav() : void
		{
			trace( "LOWERNAVBAR : resetMainNav()" );
			userNav.resetMainNav();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function transitionInComplete() : void
		{
//			trace( "LOWERNAVBAR : transitionInComplete()" );
			dispatchEvent( new Event( Event.COMPLETE ) ); 
			activate();
		}
		
		protected function activate() : void
		{
			trace( "LOWERNAVBAR : activate() : _stateModel is "+_stateModel );
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var nav : * = navArray[ i ];
				trace( "LOWERNAVBAR : activate() : nav is "+nav );
				trace( "LOWERNAVBAR : activate() : _jsBridge is "+_jsBridge );
				nav.jsBridge = _jsBridge;
				nav.stateModel = _stateModel;
//				nav.init();
				trace( "LOWERNAVBAR : activate() : _stateModel is "+_stateModel );
				nav.activate();
			}
		}
		
		protected function deactivate() : void
		{
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var nav : AbstractNav = navArray[ i ];
				nav.deactivate();
			}
		}
		
		protected function addLocks() : void
		{
			trace( "LOWERNAVBAR : addLocks() : _contentModel is "+_contentModel );
			locks = new Locks();
			locks.stateModel = _stateModel;
			locks.contentModel = _contentModel;
			locks.init();
			addChild( locks );
			
		}
		
		protected function updateBackground() : void
		{
			var w : uint = getWidth();
			background.width = w;
		}
		
		protected override function center() : void
		{
			var w : uint = getWidth();
			
			var userX : uint = Math.round( ( w - UserNav.USER_NAV_WIDTH ) * .5);
			userNav.x = userX;
			
			var utilX : uint = w - utilNav.width;
			utilNav.x = utilX;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function centerUserNav( e : Event = null ) : void
		{
			var w : uint = getWidth();
			var userX : uint = Math.round( ( w - userNav.navWidth ) * .5);
			TweenLite.to( userNav, SiteConstants.NAV_TIME_IN, { x: userX, ease: Quad.easeOut } );
//			userNav.x = userX;
		}
		

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set jsBridge( object : JSBridge ) : void
		{
			trace( "LOWERNAVBAR : set jsBridge .......... object is "+object );
			_jsBridge = object;
		}
		
		public function set contentModel( object : ContentModel ) : void
		{
			_contentModel = object;
		}
		
		public function getSound( ) : Sound
		{
			return utilNav.sound;
		}
		
//		public function getCommentary() : Commentary
//		{
//			var commentary : Commentary = utilNav.commentary;
//			return commentary;
//		}
	}
}
