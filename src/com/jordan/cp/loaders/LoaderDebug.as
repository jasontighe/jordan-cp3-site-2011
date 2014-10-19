package com.jordan.cp.loaders {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;

	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * @author jason.tighe
	 */
	public class LoaderDebug 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function LoaderDebug() 
		{
			trace( "LOADERDEBUG : Constr" );
			super();
			hide();
			init();
		}
		
		//----------------------------------------------------------------------------
		// public functions
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			addViews();
		}
		
		public function stopTimer() : void
		{
			var duration:uint = getTimer() / 1000;
            trace("LOADERDEBUG : stopTimer() : duration: " + duration);
            
            var text : String = "Load time is "+duration+ " seconds.";

			var txt : TextContainer = new TextContainer();
			txt.populate(text, 'loader-debug');
            txt.x = 10;
            txt.y = getHeight() - txt.tf.textHeight - 10;
			
			addChild(txt);
			transitionIn();
		}
		
		public function transitionIn() : void
		{ 
            show();
			TweenLite.from( this, SiteConstants.NAV_TIME_IN, { y: -height, ease: Quad.easeOut, onComplete: transitionInComplete } );
		}
		
		public function transitionOut() : void
		{
			TweenLite.to( this, SiteConstants.NAV_TIME_IN, { y: -height, ease: Quad.easeOut, onComplete: transitionOutComplete } );
		}

		//----------------------------------------------------------------------------
		// protected functions
		//----------------------------------------------------------------------------
		protected function addViews() : void
		{
			var box : Box = new Box( 200, SiteConstants.NAV_BAR_HEIGHT, 0xFFFFFF);
//			box.alpha = .5;
			addChild( box );
			setWidth( width );
			setHeight( height );
		}
		
		protected function transitionInComplete() : void
		{
			var to : uint = setTimeout( transitionOut, 4000 );
		}
		
		protected function transitionOutComplete() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
	}
}
