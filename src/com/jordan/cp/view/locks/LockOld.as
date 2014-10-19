package com.jordan.cp.view.locks {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.NavItem;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;

	/**
	 * @author jsuntai
	 */
	public class LockOld 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		 public var locked									: MovieClip;
		 public var unlocked								: MovieClip;
		 public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public function LockOld() 
		{
			init();
		}
		
		public override function setOverState(  active : int = -1  ) : void
		{
			openLock();
		}
		
		public function openLock(   ) : void
		{
			TweenMax.to( this, .35, { y: this.y - 4, ease: Quad.easeIn, onComplete: onUnlockComplete } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			locked.alpha = SiteConstants.LOCKED_ALPHA;
			showLock( locked );
			hideLock( unlocked );
			background.alpha = 0;
		}
		
		protected function hideLock( mc : MovieClip ) : void
		{
			mc.visible = false;
		}
		
		protected function showLock( mc : MovieClip ) : void
		{
			mc.visible = true;
		}
		
		protected function onUnlockComplete( ) : void
		{
			hideLock( locked );
			showLock( unlocked );
			TweenMax.to( this, .15, { y: this.y + 4, ease: Quad.easeOut } );
		}
	}
}
