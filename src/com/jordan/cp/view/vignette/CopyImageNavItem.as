package com.jordan.cp.view.vignette {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.NavItem;
	import com.jordan.cp.constants.SiteConstants;

	/**
	 * @author jason.tighe
	 */
	public class CopyImageNavItem 
	extends NavItem 
	{		
		protected static const SCALE						: Number = .6;
		protected static const ALPHA						: Number = .6;
		protected var _id							: uint;
		
		public function CopyImageNavItem() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get id() : uint
		{
			return _id;	
		}
		
		public function set id( n : uint ) : void
		{
			_id = n;	
		}
		

		public override function setOverState ( active : int = -1 ) : void
		{
			TweenMax.to( this, SiteConstants.NAV_TIME_OUT, { alpha: 1, scaleX: 1, scaleY: 1, ease: Quad.easeOut } );
//			scaleX = scaleY = 1;
//			alpha = 1;
		}

		public override function setOutState ( ) : void
		{
			TweenMax.to( this, SiteConstants.NAV_TIME_OUT, { alpha: ALPHA, scaleX: SCALE, scaleY: SCALE, ease: Quad.easeOut } );
//			scaleX = scaleY = SCALE;
//			alpha = ALPHA;
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
			scaleX = scaleY = 1;
			alpha = 1;
		}

		public override function setInactiveState () : void
		{
			scaleX = scaleY = SCALE;
			alpha = ALPHA * .5;
		}
	}
}
