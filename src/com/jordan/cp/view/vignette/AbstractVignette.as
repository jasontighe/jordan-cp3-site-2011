package com.jordan.cp.view.vignette {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.ContentDTO;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class AbstractVignette 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _stateModel							: StateModel;
		protected var _dto									: ContentDTO;
		protected var _type									: String;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
//		public var closeBtn									: CloseButton_XXX;
//		public var closeBtn									: AbstractExitButton;
//		public var backBtn									: AbstractExitButton;
		public var exitButton								: AbstractExitButton;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function AbstractVignette() 
		{
			super();
//			setWidth( background.width );
//			setHeight( background.height );
//			background.alpha = 0;
			_type = SiteConstants.EXIT_BUTTON_CLOSE;
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "ABSTRACTVIGNETTE : init()" );
			// SET TYPE TO RESIZE FOR DANCE OFF
			if( background && contains( background ) )	background.alpha = 0;
			addViews();
		}
		
		
		public function populateByDTO( dto : ContentDTO ) : void
		{
			
		}
		
		public function addExitButton() : void
		{
			exitButton = new AbstractExitButton();
			exitButton.addViews( _type );
			exitButton.addEventListener( Event.COMPLETE, onExitClick );
			addChild( exitButton );
		}
		
		protected function positionExitButton( xPos : int, yPos : int ) : void
		{
			exitButton.x = xPos;
			exitButton.y = yPos;
		}
		
		public function activate() : void
		{
			trace( "ABSTRACTVIGNETTE : activate()" );
			exitButton.activate();
		}
		
		public function deactivate() : void
		{
			trace( "ABSTRACTVIGNETTE : deactivate()" );
			exitButton.deactivate();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addViews( ) : void
		{
			trace( "ABSTRACTVIGNETTE : addViews()" );
			addBackground();
		}
		
		protected function addBackground( ) : void
		{
			trace( "ABSTRACTVIGNETTE : addBackground()" );
//			background = new Box( SiteConstants.STAGE_AREA_WIDTH, SiteConstants.STAGE_AREA_HEIGHT );
//			background.alpha = 0;
//			addChild( background );
//			
//			setWidth( width );
//			setHeight( height );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onExitClick( e : Event = null ) : void
		{
			trace( "ABSTRACTVIGNETTE : onClick() : _type is "+_type );
//			if( _type == SiteConstants.EXIT_BUTTON_CLOSE )
//			{
//				deactivate();
//				_stateModel.state = StateModel.STATE_OVERLAY_OUT;
//			}
//			else
//			{
				dispatchEvent( new Event( Event.COMPLETE) ) ;
//			}
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set stateModel( model : StateModel ) : void
		{
			_stateModel = model;
		}
		
		public function set type( s : String ) : void
		{
			_type = s;
		}
	}
}
