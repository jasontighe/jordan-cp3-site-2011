package com.jordan.cp.view {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jasontighe.util.Box;
	import com.jordan.cp.model.StateModel;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jason.tighe
	 */
	public class AbstractView 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var _defaultSize							: uint = 100;
		private var _defaultColor							: uint = 0xAEAEAE;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var background								: Box;
		public var header									: TextField;
		public var _stateModel								: StateModel;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function AbstractView() 
		{
//			trace( "ABSTRACTVIEW : Constr" );
			super();
			
			setDefaultValues();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
//			 trace( "ABSTRACTVIEW : init()" );
			 addViews();
		}
		
		public function setViewSize( w : uint, h : uint ) : void
		{
			setWidth( w );
			setHeight( h );
		}
		
//		USE ON STAGE RESIZE FROM SHELL TO CENTER AND ALSO UPDATE SIZES
		public function updateViews( w : uint, h : uint ) : void
		{		
//			trace( "ABSTRACTVIEW : updateViews() : w is "+w+" : h is "+h );
			setWidth( w );
			setHeight( h );
			center();
		}
			
		public function transitionIn() : void
		{
			trace( "ABSTRACTVIEW : transitionIn()" );
			show( .5 );
			addEventListener( ContainerEvent.SHOW, transitionInComplete );
		}

		public function transitionOut() : void
		{
			trace( "ABSTRACTVIEW : transitionOut()" );
			hide( .25 );
			addEventListener( ContainerEvent.HIDE, transitionInComplete );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function transitionInComplete( e : ContainerEvent = null ) : void
		{
			removeEventListener( ContainerEvent.SHOW, transitionInComplete );
		}
		
		protected function transitionOutComplete( e : ContainerEvent = null ) : void
		{
			removeEventListener( ContainerEvent.HIDE, transitionInComplete );
		}
		
//		USE SET WIDTH AND HEIGHT FOR STAGE W AND H VALUES
		protected function setDefaultValues() : void
		{
//			trace( "ABSTRACTVIEW : setDefaultValues()" );
			setWidth( _defaultSize );
			setHeight( _defaultSize );
		}
		
		protected function addViews() : void
		{
//			 trace( "ABSTRACTVIEW : addViews()" );
			 addHeader();
		}
		
		protected function center( ) : void
		{
		}
		
		
//		THIS IS TEMPORARY
		protected function addHeader() : void
		{
			var className : Class = getClass( this );
			trace( "ABSTRACTVIEW : addHeader() : className is "+className );
			header = new TextField();
			header.htmlText = String( className ).toUpperCase();
			header.autoSize = TextFieldAutoSize.LEFT;
			var format : TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF;
			format.size = 60;
			header.setTextFormat(format);
			addChild( header );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public static function getClass( obj : Object ) : Class 
		{
			return Class( getDefinitionByName( getQualifiedClassName( obj ) ) );
		}
		
		public function set stateModel( model : StateModel ) : void
		{
			_stateModel = model;
		}
	}
}
