package com.jordan.cp.view.welcome {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;

	import flash.display.MovieClip;

	/**
	 * @author jsuntai
	 */
	public class LoaderIcons 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var iconArray									: Array = new Array();
		protected var curIcon									: MovieClip;
		protected var prevIcon									: MovieClip;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var logoMask										: MovieClip;
		public var lock											: MovieClip;
		public var message										: MovieClip;
		public var keyboard										: MovieClip;
		public var camera										: MovieClip;
		public var shoe											: MovieClip;
		public var background									: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function LoaderIcons() 
		{
			trace( "LOADERICONS : Constr" );
			super();
			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "LOADERICONS : init" );
			
			TweenPlugin.activate([BlurFilterPlugin]);
			iconArray = [ lock, message, keyboard, camera, shoe ];
			var i : uint = 0;
			var I : uint = iconArray.length;
			for( i; i < I; i++ )
			{
				trace( "WELCOME : transitionIn()" );
				var icon : MovieClip = iconArray[ i ];
				removeChild( icon );
			}
		}
		
		public function updateIcon( id : uint ) : void
		{
//			var icon : MovieClip = iconArray[ currentId ];
//			showIcon( icon );
			curIcon = iconArray[ id ];
			if( id > 0 )
			{
				prevIcon = iconArray[ id - 1 ];
				prevIconOut();
			}
			else
			{
				curIconIn();
			}
			
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function curIconIn( ) : void
		{
			addChild( curIcon );
			curIcon.y = curIcon.height;
			TweenMax.to( curIcon, 0, { blurFilter: { blurY: SiteConstants.ICON_BLUR_Y } } );
			TweenMax.to( curIcon, SiteConstants.ICON_TIME_IN, {  y: SiteConstants.ICON_OFFSET, ease: Quad.easeOut, onComplete: curIconInComplete } );
		}
		
		protected function prevIconOut( ) : void
		{
			TweenMax.to( prevIcon, SiteConstants.ICON_TIME_OUT, { y: -prevIcon.height, ease: Quad.easeOut, onComplete: prevIconOutComplete } );
		}
		
		protected function curIconInComplete( ) : void
		{
			TweenMax.to( curIcon, SiteConstants.ICON_TIME_OUT, { blurFilter: { blurY: 0 }, y: 0, ease: Quad.easeOut } )
		}
		
		protected function prevIconOutComplete( ) : void
		{
			curIconIn();
			removeChild( prevIcon );
			prevIcon = null;
		}
		
			
	}
}
