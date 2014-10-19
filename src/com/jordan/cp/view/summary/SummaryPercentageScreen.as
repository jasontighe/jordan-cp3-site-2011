package com.jordan.cp.view.summary {
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.plode.framework.containers.TextContainer;

	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SummaryPercentageScreen 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var TITLE							: String = "CP3 Downloads";
		protected static var PERCENTAGE_X					: uint = 73;
		protected static var PERCENTAGE_Y					: uint = 29;
		protected static var PERCENTAGE_X_SPACE				: int = 6;
		protected static var PERCENTAGE_WIDTH				: int = 40;
		protected static var DOWNLOAD_X						: uint = 32;
		protected static var DOWNLOAD_Y						: uint = 115;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _contentModel							: ContentModel;
		protected var _percentage							: uint = 0;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var header0Txt								: TextContainer;
		public var header1Txt								: TextContainer;
		public var percentageTxt							: TextContainer;
		public var progressBar								: SummaryProgressBar;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryPercentageScreen() 
		{
//			trace( "SUMMARYPERCENTAGESCREEN : Constr" );
			super();
			_contentModel = ContentModel.gi;
//			init();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "SUMMARYPERCENTAGESCREEN : init()" );
//			addViews();
		}
		
		public function addViews( ) : void
		{
			trace( "SUMMARYPERCENTAGESCREEN : addViews() " );
			addCopy( );
			addProgressBar();
		}
		
		//----------------------------------------------------------------------------
		// protected function 
		//----------------------------------------------------------------------------
		protected function addCopy( ) : void
		{
			trace( "SUMMARYPERCENTAGESCREEN : addCopy() " );
			var headerId : String = "summary-header"
			var headerDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( headerId ) as CopyDTO;
			trace( "SUMMARYPERCENTAGESCREEN : addCopy() : headerDTO is "+headerDTO );
			
			trace( "SUMMARYPERCENTAGESCREEN : addCopy() : headerDTO.copy is "+headerDTO.copy );
			var headerCopy : String = headerDTO.copy;
			trace( "SUMMARYPERCENTAGESCREEN : addCopy() : headerName is "+headerCopy );
			var headerArray:Array = headerDTO.copy.split("%");
			
			header0Txt = new TextContainer();
			header0Txt.populate( headerArray[ 0 ], headerId);
			addChild( header0Txt );
			
			_percentage = getPercentage();	
//			_percentage = 0;	
			percentageTxt = new TextContainer();
			var percentText : String = String( 0 + "%");
//			trace( "SUMMARYPERCENTAGESCREEN : addCopy() : percentText is "+percentText );	
			percentageTxt.populate( percentText, 'summary-percentage');
			percentageTxt.x = header0Txt.width + PERCENTAGE_X_SPACE;
			addChild( percentageTxt );
			
			header1Txt = new TextContainer();
			header1Txt.populate( headerArray[ 1 ], 'summary-header');
			header1Txt.x = percentageTxt.x + PERCENTAGE_WIDTH + PERCENTAGE_X_SPACE;
			addChild( header1Txt );
			
		}
		
		protected function addProgressBar() : void
		{
//			trace( "SUMMARYPERCENTAGESCREEN : addProgressBar()" );
			progressBar = new SummaryProgressBar();
			progressBar.x = PERCENTAGE_X;
			progressBar.y = PERCENTAGE_Y;
			progressBar.init();
			addChild( progressBar );
			
			progressBar.addEventListener( Event.COMPLETE, onProgressBarComplete );
			addEventListener( Event.ENTER_FRAME, onProgessBarUpdate );
			progressBar.showProgress( _percentage * .01 );
		}
		
		protected function getPercentage() : Number
		{
			var unlocked : uint = _contentModel.unlockedContent.length;
			var total : uint = _contentModel.content.length;
			var percent : Number = unlocked / total * 100;
			return percent;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onProgessBarUpdate( e : Event ) : void
		{
//			trace( "SUMMARYPERCENTAGESCREEN : onProgessBarUpdate()" );
			var percent : uint =  Math.round( progressBar.getPercentage() * 100  );
			var s : String = String( percent + "%");
			percentageTxt.update( s );
//			trace( "SUMMARYPERCENTAGESCREEN : onProgessBarUpdate() : percent is "+percent );
		}
		
		protected function onProgressBarComplete( e : Event ) : void
		{
//			trace( "SUMMARYPERCENTAGESCREEN : onProgressBarComplete()" );
			removeEventListener( Event.ENTER_FRAME, onProgessBarUpdate );
			progressBar.removeEventListener( Event.COMPLETE, onProgressBarComplete );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set percentage( n : Number ) : void
		{
//			trace( "SUMMARYPERCENTAGESCREEN : set percentage: n is "+n );
			_percentage = n;
		}
	}
}
