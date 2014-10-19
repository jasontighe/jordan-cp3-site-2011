package com.jordan.cp.view.help {
	import com.greensock.TweenLite;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.view.AbstractOverlay;
	import com.jordan.cp.view.vignette.AbstractExitButton;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jason.tighe
	 */
	public class Help 
	extends AbstractOverlay 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static const BACK_Y_SPACE				: uint = 40;
		protected static const BACK_X					: uint = 356;
		protected static const BACK_Y					: uint = 334;
		protected static const ANGLES_X					: uint = 0;
		protected static const ANGLES_Y					: uint = 0;
		protected static const TIME_X					: uint = 294;
		protected static const TIME_Y					: uint = 0;
		protected static const ZOOM_X					: uint = 588;
		protected static const ZOOM_Y					: uint = 0;
		protected static const SCALE_OVER				: Number = 1.05;
		protected static const SCALE_OUT				: Number = .95;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _sections							: Array;					
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var angles								: Angles;
		public var timeControl							: TimeControl;
		public var zoom									: Zoom;
		public var backBtn								: AbstractExitButton;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Help() 
		{
			trace( "HELP : Constr");
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init( ) : void
		{	
			trace( "HELP : init()" );
			addViews();
			_sections = new Array( angles, timeControl, zoom );
			setVariables();
		}
		
		
		public override function updateViews( stageW : uint, stageH : uint ) : void
		{
			trace( "HELP : updateViews()" );
			setWidth( stageW );
			setHeight( stageH );
			
			center();
			
//			addViews();
		}
		
		public override function transitionIn() : void
		{
			trace( "HELP : transitionIn()" );
			alpha = 1;
			TweenLite.from( this, TIME_IN, { alpha: 0, onComplete: transitionInComplete  } );
		}
		
		public override function transitionOut() : void
		{
			trace( "HELP : transitionOut()" );
			deactivate();
			TweenLite.to( this, TIME_OUT, { alpha: 0, onComplete: transitionOutComplete  } );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function initViews() : void
		{
			trace( "HELPSCREEN : initViews()" );
			
			var i : uint = 0;
			var I : uint = _sections.length;
			for( i; i < I; i++ )
			{
				var section : HelpSection = _sections[ i ];
				section.init();
			}
		}
		
		protected function addViews() : void
		{
			trace( "HELP : addViews()" );
			addAngles();
			addTimeControl();
			addZoom();
			addExitButton();
		}
		
		protected function addAngles() : void
		{
			trace( "HELP : addAngles()" );
			angles = new Angles();
			angles.init();
			angles.x = ANGLES_X;
			angles.y = ANGLES_Y;
			addChild( angles );
		}
		
		protected function addTimeControl() : void
		{
			trace( "HELP : addTimeControl()" );
			timeControl = new TimeControl();
			timeControl.init();
			timeControl.x = TIME_X;
			timeControl.y = TIME_Y;
			addChild( timeControl );
		}
		
		protected function addZoom() : void
		{
			trace( "HELP : addZoom()" );
			zoom = new Zoom();
			zoom.init();
			zoom.x = ZOOM_X;
			zoom.y = ZOOM_Y;
			addChild( zoom );
		}
		
		protected function addExitButton() : void
		{
			trace( "HELP : addExitButton()" );
			backBtn = new AbstractExitButton();
			var exitId : String = "help-exit";
			var exitTxt : String = ContentModel.gi.getCopyDTOByName( exitId ).copy as String;
			backBtn.addViews( exitTxt );
			backBtn.addEventListener( Event.COMPLETE, onClick );
			backBtn.activate();
			backBtn.x = BACK_X;
			backBtn.y = BACK_Y;
			addChild( backBtn );
		}
		
		protected function setVariables() : void
		{
			var i : uint = 0;
			var I : uint = _sections.length;
			for( i; i < I; i++ )
			{
				var section : HelpSection = _sections[ i ];
				section.setX( section.x );
				section.setY( section.y );
				section.setWidth( section.width );
				section.setHeight( section.height );
				
				trace( "\n");
				trace( "HELP : setVariables() : section is "+section );
				trace( "HELP : setVariables() : section.x is "+section.x );
				trace( "HELP : setVariables() : section.y is "+section.y );
				trace( "HELP : setVariables() : section.width is "+section.width );
				trace( "HELP : setVariables() : section.height is "+section.height );
			}
		}
		
		protected override function transitionInComplete() : void
		{
			trace( "HELP : transitionInComplete()" );
			activate();
		}
		
		protected function activate() : void
		{
			trace( "HELP : activate()" );
			var i : uint = 0;
			var I : uint = _sections.length;
			for( i; i < I; i++ )
			{
				var section : HelpSection = _sections[ i ];
				section.activate();
				section.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				section.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			}
		}
		
		protected function deactivate() : void
		{
			trace( "HELP : deactivate()" );
			var i : uint = 0;
			var I : uint = _sections.length;
			for( i; i < I; i++ )
			{
				var section : HelpSection = _sections[ i ];
				section.deactivate();
				section.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				section.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			}
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void
		{
//			trace( "HELP : onMouseOver()" );
			var activeSection : HelpSection = e.target as HelpSection;
			var percent : Number;
			var i : uint = 0;
			var I : uint = _sections.length;
			for( i; i < I; i++ )
			{
				var section : HelpSection = _sections[ i ];
				if( activeSection == section )
				{
					percent = SCALE_OVER
				}
				else
				{ 
					percent = SCALE_OUT;
				}
				
				section.scale( percent );
			}
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void
		{
//			trace( "HELP : onMouseOut()" );
			var i : uint = 0;
			var I : uint = _sections.length;
			for( i; i < I; i++ )
			{
				var section : HelpSection = _sections[ i ];
				section.scale( 1 );
			}
		}
		
		protected function onClick( e : Event = null ) : void
		{
			trace( "HELP : onClick()" );
//			deactivate();
			backBtn.removeEventListener( Event.COMPLETE, onClick );
			_stateModel.state = StateModel.STATE_OVERLAY_OUT;
		}
	}
}
