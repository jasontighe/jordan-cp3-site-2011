package com.jordan.cp.view {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.model.StateModel;

	/**
	 * @author jason.tighe
	 */
	public class AbstractOverlay 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static const TIME_IN							: Number = 1;
		public static const TIME_OUT						: Number = .5;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _stateModel								: StateModel;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function AbstractOverlay() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function transitionIn() : void
		{
			
		}
		
		public function transitionOut() : void
		{
			
		}
		
		public function setViewSize( w : uint, h : uint ) : void
		{
			trace( "ABSTRACTOVERLAY : setViewSize() w is "+w + " : h is "+h  );
			setWidth( w );
			setHeight( h );
		}
		
		public function updateViews( w : uint, h : uint ) : void
		{
			setWidth( w );
			setHeight( h );
			center();
		}
		
		public function setStageDimensions() : void
		{
			setWidth( width );
			setHeight( height );
			trace( "ABSTRACTOVERLAY : setStageDimensions() getWidth() is "+getWidth() + " : getHeight() is "+getHeight() );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function transitionInComplete() : void
		{
			
		}
		
		protected function transitionOutComplete() : void
		{
			dispatchEvent( new ContainerEvent( ContainerEvent.HIDE ) );
		}
		
		protected function center() : void
		{
			var w : uint = getWidth();
			var h : uint = getHeight();
			trace( "ABSTRACTOVERLAY : center() w is "+w + " : h is "+h  );
			
			var xPos : Number = Math.round( ( w - width ) * .5 );
			var yPos : Number = Math.round( ( h - height ) * .5 );
			
			x = xPos;
			y = yPos;
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set stateModel( model : StateModel ) : void
		{
			_stateModel = model;
		}
	}
}
