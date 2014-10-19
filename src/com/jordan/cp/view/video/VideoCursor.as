package com.jordan.cp.view.video 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;
	
	import flash.display.MovieClip;	

	/**
	 * @author jason.tighe
	 */

	public class VideoCursor 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static const	ARROW_SCALE					: Number = .75;
		public static const	ARROW_ALPHA					: Number = .2;
		public static const	LEFT						: String = "left";
		public static const	RIGHT						: String = "right";
		public static const	NEUTRAL						: String = "neutral";
		public static const SCRUB						: String = "scrub";
		public static const EXPLORE						: String = "explore";
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _isActive							: Boolean = true;
		protected var _currentX							: Number;
		protected var _direction						: String;
		protected var _mode								: String;
		protected var _activeArrowL 					: MovieClip;
		protected var _activeArrowR						: MovieClip;
		
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var handOpen								: MovieClip;
		public var handClenched							: MovieClip;
		public var arrowL 								: MovieClip;
		public var arrowR 								: MovieClip;
		public var arrowFFL 							: MovieClip;
		public var arrowFFR 							: MovieClip;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function VideoCursor() 
		{
			super();
			_mode = EXPLORE;
			_direction = NEUTRAL;
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		// Set _isActive before calling init
		public override function init() : void
		{
//			TODO Turn off until Firefox fix
//			toggleHand();
			if( _isActive) 
			{
				hideHands();
			}
			else
			{
				handClenched.visible = false;
			}
			
			setArrows();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function toggleHand() : void
		{
			trace( "ABSTRACTCURSOR : toggleHand() : _isActive is "+_isActive );
			handOpen.visible = !_isActive; 
			handClenched.visible = _isActive; 
		}
		
		protected function hideHands() : void
		{
			handOpen.visible = false; 
			handClenched.visible = false; 
		}
		
		protected function setArrows() : void
		{
			if( _mode == EXPLORE )
			{
				_activeArrowL = arrowL;
				_activeArrowR = arrowR;
				showArrow( arrowL );
				showArrow( arrowR );
				hideArrow( arrowFFL );
				hideArrow( arrowFFR );
			}
			else
			{
				_activeArrowL = arrowFFL;
				_activeArrowR = arrowFFR;
				showArrow( arrowFFL );
				showArrow( arrowFFR );
				hideArrow( arrowL );
				hideArrow( arrowR );
			}
		}
		
		protected function showArrow( m : MovieClip ) : void
		{
			m.visible = true;
			m.alpha = 1;
			TweenLite.from( m, SiteConstants.NAV_TIME_IN, { alpha: 0 } );
		}

		protected function hideArrow( m : MovieClip ) : void
		{
			m.visible = false;
			m.alpha = 0;
		}
		
		protected function updateArrows() : void
		{
			switch ( _direction )
			{
				case LEFT:
					directionL();
					break;
				case RIGHT:
					directionR();
					break;
				default:
					neutral();
			}
		}

		protected function directionR() : void
		{
			animateActive( _activeArrowR );
			animateInactive( _activeArrowL );
		}

		protected function directionL() : void
		{
			animateActive( _activeArrowL );
			animateInactive( _activeArrowR );
		}
		
		protected function neutral() : void
		{
			animateActive( _activeArrowL );
			animateActive( _activeArrowR );
		}
		
		protected function animateActive( object : MovieClip ) : void
		{
			TweenLite.to( object, SiteConstants.NAV_TIME_IN, { alpha:1, scaleX: 1, scaleY: 1, ease: Quad.easeOut } );
		}
		
		protected function animateInactive( object : MovieClip ) : void
		{
			TweenLite.to( object, SiteConstants.NAV_TIME_OUT, { alpha:ARROW_ALPHA, scaleX: ARROW_SCALE, scaleY: ARROW_SCALE, ease: Quad.easeOut } );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get isActive( ) : Boolean
		{
			return _isActive;
		}
		
		public function set isActive( b : Boolean ) : void
		{
			_isActive = b;
		}
		
		public function set currentX( n : Number ) : void
		{
			if( _currentX < n )
			{
			   	direction = RIGHT;
			}
			else if( _currentX > n )
			{
			  	direction = LEFT;
			}
			else
			{
			    direction = NEUTRAL;
			}
		    
		    _currentX = n;
		}
		
		public function set direction( s : String ) : void
		{
			if( _direction != s)
			{
				_direction = s;
				updateArrows();
			}
		}
		
		public function get mode( ) : String
		{
			return _mode;
		}
			
		public function set mode( s : String ) : void
		{
			if( _mode != s)
			{
				_mode = s;
				setArrows();
			}
		}
		
	}
}
