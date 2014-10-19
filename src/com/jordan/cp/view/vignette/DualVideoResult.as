package com.jordan.cp.view.vignette {
	import flash.events.Event;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class DualVideoResult 
	extends DisplayContainer 
	{
		public var percentageTxt						: TextContainer;
		public var background							: MovieClip;
		protected var _percent							: uint;
		protected var _showPercent						: uint = 0;
		protected static const PADDING					: uint = 5;
		
		public function DualVideoResult() 
		{
			super();
			hide();
		}
		
		public function addViews( ) : void
		{
			addBackground();	
//			addCopy( s );		
		}
		
		public function showResult( n : uint ) : void
		{
			addCopy( n );	
			show( SiteConstants.NAV_TIME_IN ); 	
		}
		
		
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addBackground() : void
		{		
			background = MovieClip( AssetManager.gi.getAsset( "DualVotingBackgroundAsset", SiteConstants.ASSETS_ID ) );
			addChild( background );
		}
		
		protected function addCopy( n : uint ) : void
		{		
			_percent = n;
			
			percentageTxt = new TextContainer();
			percentageTxt.populate( getPercentString( _showPercent ), "voting-percentage" );
			percentageTxt.x = ( background.x + background.width - percentageTxt.width ) * .5;
			percentageTxt.y = ( background.x + background.height - percentageTxt.height ) * .5;
			positionCopy();
			addChild( percentageTxt );
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame )
		}
		
		protected function updatePercentage( n : uint ) : void
		{
			percentageTxt.update( getPercentString( n ) );
		}
		
		protected function getPercentString( n : uint ) : String
		{
			var percentage : String = String( n + "%" );
			return percentage; 
		}
		
		protected function positionCopy() : void
		{
			var xPos : uint = background.x + background.width - percentageTxt.width - PADDING; 
			percentageTxt.x = xPos;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onEnterFrame( e : Event ) : void
		{
			_showPercent++
			if( _showPercent <= _percent )
			{
				updatePercentage( _showPercent );
				positionCopy();
			}
			else
			{
			this.removeEventListener( Event.ENTER_FRAME, onEnterFrame )
			}
		}
	}
}
