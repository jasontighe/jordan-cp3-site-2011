package com.jordan.cp.view.vignette {
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class CopyImages 
	extends AbstractVignette 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var EXIT_X							: uint = 378;
		protected static var EXIT_Y							: uint = 469;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var imagePanel								: CopyImagePanel;
		public var textPanel								: CopyTextPanel;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CopyImages() 
		{
			super();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
			if( background && contains( background ) )	background.alpha = 0;
			addViews();
		}
		
		public override function populateByDTO( dto : ContentDTO ) : void
		{
			trace( "COPYIMAGES : populateByDTO() : dto is "+dto );
			imagePanel.populateByDTO( dto );
			imagePanel.addEventListener( Event.COMPLETE, onImageSelected )
			textPanel.populateByDTO( dto );
			
			addExitButton();
			positionExitButton( EXIT_X, EXIT_Y );
		}
		
		protected function onImageSelected( e : Event ) : void
		{
			var id : uint = imagePanel.id;
			textPanel.transitionCopy( id )
		}
	}
}
