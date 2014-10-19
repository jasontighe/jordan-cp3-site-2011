package com.jordan.cp.view.summary {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.util.Box;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ConfigModel;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.jordan.cp.view.AbstractOverlay;
	import com.jordan.cp.view.summary.events.SummaryEvent;
	import com.jordan.cp.view.vignette.AbstractExitButton;
	import com.jordan.cp.view.vignette.CopyImages;
	import com.jordan.cp.view.vignette.DualVideo;
	import com.jordan.cp.view.vignette.VideoOnly;
	import com.jordan.cp.view.vignette.Wallpaper;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author jason.tighe
	 */
	public class Summary 
	extends AbstractOverlay
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var REGISTRATION_X					: uint = 230;
		protected static var REGISTRATION_Y					: uint = 200;
		protected static var PERCENTAGE_X					: int = 356;
		protected static var PERCENTAGE_Y					: int = 202;
//		protected static var PANEL_X						: uint = 200;
		protected static var PANEL_Y						: uint = 248;
		protected static var MEDIA_Y						: uint = 148;
//		protected static var NAV_X							: uint = 200;
		protected static var NAV_Y							: uint = 673;
		protected static var GRAIDENT_WIDTH					: uint = 1240;
		protected static var GRAIDENT_HEIGHT				: uint = 968;
		protected static var AREA_WIDTH						: uint = 840;
		protected static var AREA_HEIGHT					: uint = 568;
		protected static var HIDE_OFFSET					: uint = 40;

		protected static var CONTINUE_X						: uint = 0;
		protected static var CONTINUE_Y						: uint = 15;
		protected static var BUY_X							: uint = 517;
		protected static var BUY_Y							: uint = 22;
		protected static var QUICK_X						: uint = 617;
		protected static var QUICK_Y						: uint = 22;
		protected static var HR_COLOR						: uint = 0x323232;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _contentModel							: ContentModel;
		protected var _id									: uint;
		protected var _dto									: ContentDTO;
		protected var _percentageX							: int;
		protected var _percentageY							: int;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var percentageScreen							: SummaryPercentageScreen;
		public var panelHolder								: MovieClip;
		public var lowerNavHolder							: MovieClip;
		public var mediaHolder								: MovieClip;
		public var maskHolder								: MovieClip;
		public var summaryPanel								: SummaryPanel;
		public var hr										: Box;
		public var buyShoesBtn								: MovieClip;
		public var quickMoves								: MovieClip;
		public var videoOnly								: VideoOnly;
		public var wallpaper								: Wallpaper;
		public var copyImages								: CopyImages;
		public var danceOff									: DualVideo;
		public var continueBtn								: AbstractExitButton;
		public var buyBtn									: SummaryBuyButton;
		public var quickBtn									: SummaryQuickButton;
		public var background								: Box;
		public var summaryGradient							: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Summary() 
		{
			trace( "SUMMARY : Constr" );
			super();
//			setWidth( background.width );
//			setHeight( background.height );
//			background.alpha = 0;
//			
//			init();
			_contentModel = ContentModel.gi;
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			 trace( "SUMMARY : init()" );
//			 hide();
		}
		
		public function addViews() : void
		{
			trace( "SUMMARY : addViews()" );
//			addBackground();
			addHolders();
			addPrecentageScreen();
			addSummaryPanel();
			
			addHr();
			addContinueButton();
			addBuyButton();
			addQuickButton();
			addGradientMask();
//			setStageDimensions();
		}
		
		public override function transitionIn() : void
		{
			TweenLite.from( this, TIME_OUT, { alpha: 0, onComplete: transitionInComplete  } );
		}
		
		public override function transitionOut() : void
		{
			trace( "SUMMARY : transitionIn()" );
			TweenLite.to( this, TIME_OUT, { alpha: 0, onComplete: transitionOutComplete  } );
		}
//		public override function setStageDimensions() : void
//		{
//			setWidth( GRAIDENT_WIDTH );
//			setHeight( GRAIDENT_HEIGHT );
//			trace( "SUMMARY : setStageDimensions() getWidth() is "+getWidth() + " : getHeight() is "+getHeight() );
//		}
		
		//----------------------------------------------------------------------------
		// protected function 
		//----------------------------------------------------------------------------
		protected override function center() : void
		{
			var w : uint = getWidth();
			var h : uint = getHeight();
			trace( "ABSTRACTOVERLAY : center() w is "+w + " : h is "+h  );
			
			var xPos : Number = Math.round( ( w - GRAIDENT_WIDTH ) * .5 );
			var yPos : Number = Math.round( ( h - GRAIDENT_HEIGHT ) * .5 );
			
			x = xPos;
			y = yPos;
		}
		
		protected function addHolders() : void
		{
			// THESE ARE ADDED TO STAGE IN NAV
			panelHolder = new MovieClip();
			addChild( panelHolder );
			panelHolder.x = REGISTRATION_X;
			panelHolder.y = PANEL_Y;
			 
			lowerNavHolder = new MovieClip();
			lowerNavHolder.x = REGISTRATION_X;
			lowerNavHolder.y = NAV_Y;
			addChild( lowerNavHolder );
			 
			mediaHolder = new MovieClip();
			mediaHolder.x = GRAIDENT_WIDTH;
			mediaHolder.y = MEDIA_Y;
			addChild( mediaHolder );
			 
			maskHolder = new MovieClip();
			addChild( maskHolder );
			
			maskHolder.addChild( panelHolder );
			maskHolder.addChild( lowerNavHolder );
			maskHolder.addChild( mediaHolder );
		}
		
		protected function addPrecentageScreen() : void
		{
			trace( "SUMMARY : addPrecentageScreen()" );
			var headerId : String = "summary-header"
			var headerDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( headerId ) as CopyDTO;
			percentageScreen = new SummaryPercentageScreen();			
			percentageScreen.addViews( );
			percentageScreen.x = headerDTO.copyX;
			percentageScreen.y = headerDTO.copyY;
			_percentageX = percentageScreen.x;
			_percentageY = percentageScreen.y;
			addChild( percentageScreen );
		}
		
		protected function addSummaryPanel() : void
		{
			trace( "SUMMARY : addSummaryPanel()" );
			summaryPanel = new SummaryPanel();
//			summaryPanel.contentModel = _contentModel;
			summaryPanel.addViews();
			summaryPanel.setWidth( SiteConstants.STAGE_AREA_WIDTH );
			summaryPanel.setHeight( SiteConstants.STAGE_AREA_HEIGHT );
			summaryPanel.addEventListener( SummaryEvent.SCENE_CLICK, onSceneClick );
			summaryPanel.addEventListener( SummaryEvent.CONTENT_CLICK, onContentClick );
			panelHolder.addChild( summaryPanel );
		}
		
		protected function addHr() : void
		{
			trace( "SUMMARY : addHr()" ); 
			hr = new Box( SiteConstants.STAGE_AREA_WIDTH, 1, HR_COLOR );
			lowerNavHolder.addChild( hr );
		}
		
		protected function addContinueButton() : void
		{
			trace( "SUMMARY : addContinueButton()" );
			continueBtn = new AbstractExitButton();
			var continueId : String = "summary-exit-button";
			var continueTxt : String = ContentModel.gi.getCopyDTOByName( continueId ).copy as String;
			continueBtn.addViews( continueTxt );
			continueBtn.addEventListener( Event.COMPLETE, onContinueClick );
			continueBtn.activate();
			continueBtn.x = CONTINUE_X;
			continueBtn.y = CONTINUE_Y;
			lowerNavHolder.addChild( continueBtn );
		}
		
		protected function addBuyButton() : void
		{
			trace( "SUMMARY : addBuyButton()" );
			buyBtn = new SummaryBuyButton();
			buyBtn.addViews();
			buyBtn.addEventListener( Event.COMPLETE, onBuyClick );
			buyBtn.x = BUY_X;
			buyBtn.y = BUY_Y;
			lowerNavHolder.addChild( buyBtn );
		}
		
		protected function addQuickButton() : void
		{
			trace( "SUMMARY : addQuickButton()" );
			quickBtn = new SummaryQuickButton();
			quickBtn.addViews();
			quickBtn.addEventListener( Event.COMPLETE, onQuickClick );
			quickBtn.x = QUICK_X;
			quickBtn.y = QUICK_Y;
			lowerNavHolder.addChild( quickBtn );
		}
		
		protected function addGradientMask() : void
		{
			trace( "SUMMARY : addGradientMask()" );
			summaryGradient = MovieClip( AssetManager.gi.getAsset( "SummaryGradient", SiteConstants.ASSETS_ID ) );
			addChild( summaryGradient );
			
			maskHolder.cacheAsBitmap = true;
			summaryGradient.cacheAsBitmap = true;
			
			maskHolder.mask = summaryGradient;
		}
		
		protected override function transitionInComplete() : void
		{
			continueBtn.activate();
			buyBtn.activate();
			quickBtn.activate();
		}
		
		protected function panelHide() : void
		{
			trace( "SUMMARY : panelHide() ......................................" );
			var time : Number = SiteConstants.NAV_TIME_IN;
			var delay : Number = SiteConstants.NAV_TIME_IN * .35;
			
			var percentageY : int = Math.round( PERCENTAGE_Y - HIDE_OFFSET );
			TweenLite.to( percentageScreen, time, { alpha: 0, y: percentageY, ease:Quad.easeOut } );
			
			var navY : int = Math.round( NAV_Y + ( HIDE_OFFSET * .85 ) );
			TweenLite.to( lowerNavHolder, time, { alpha: 0, y: navY, ease:Quad.easeOut } );
			
			// THIS SHOULD BE DELAYED
			var panelX : int = Math.round( -panelHolder.width );
			TweenLite.to( panelHolder, time, { x: panelX, delay: delay, ease:Quad.easeInOut } );
		}
		
		protected function panelShow() : void
		{
			trace( "SUMMARY : panelShow() ......................................" );
			var delay : Number = SiteConstants.NAV_TIME_IN * .75;
			
			TweenLite.to( percentageScreen, SiteConstants.NAV_TIME_IN, { alpha: 1, y: PERCENTAGE_Y, delay: delay, ease:Quad.easeOut } );
			TweenLite.to( lowerNavHolder, SiteConstants.NAV_TIME_IN, { alpha: 1, y: NAV_Y, delay: delay, ease:Quad.easeOut } );
			
			TweenLite.to( panelHolder, SiteConstants.NAV_TIME_IN, { x: REGISTRATION_X, ease:Quad.easeOut, onComplete: panelShowComplete } );
			
			mediaHide()
		}
		
		protected function panelShowComplete() : void
		{
			trace( "SUMMARY : panelShowComplete() ......................................" );
		}
		
		protected function mediaShow() : void
		{
			trace( "SUMMARY : mediaShow() ......................................" );
			var delay : Number = SiteConstants.NAV_TIME_IN * .35;
			
			var percentageY : int = Math.round( -percentageScreen.height );
			TweenLite.to( mediaHolder, SiteConstants.NAV_TIME_IN, { x: REGISTRATION_X, delay: delay, ease:Quad.easeInOut, onComplete: onMediaShowComplete } );
		}
		
		protected function mediaHide() : void
		{
			trace( "SUMMARY : mediaHide() ......................................" );
			TweenLite.to( mediaHolder, SiteConstants.NAV_TIME_IN, { x: GRAIDENT_WIDTH, ease:Quad.easeInOut } );
		}
		
		protected function onMediaShowComplete() : void
		{
			trace( "SUMMARY : onMediaShowComplete() ......................................" );
			var type : String = summaryPanel.type;
			trace( "SUMMARY : onMediaShowComplete() : type is "+type );
			
			if( type == SiteConstants.HOTSPOT_TYPE_SCENE ) 
			{
				playVideo();
			}
			else if( type == SiteConstants.HOTSPOT_TYPE_CONTENT )
			{
				// cATCH TO DECIDE IF ITS A CONTENT OR EASTER EGG
				var contentLength : uint = _contentModel.content.length
				var id : uint = _id;
				var name : String = _dto.name;
				
				trace( "SUMMARY : onMediaShowComplete() : name is "+name );
				if( name == SiteConstants.VIGNETTE_BLOND || name == SiteConstants.VIGNETTE_JORDAN || name == SiteConstants.VIGNETTE_HORSE  ) 
				{
					playVideo();
				}
				else if( name == SiteConstants.EGG_KONAMI )
				{
				trace( "SUMMARY : onMediaShowComplete() : DO SOME KONAMI CODE SHIT RIGHT HERE" );
				}
			}
		}
		
		protected function playVideo() : void
		{
			var name : String = _dto.name;
			trace( "SUMMARY : playVideo() : name is "+name );
			var url : String = Shell.getInstance().getVideoModel().getUrlByName( name );
			var nc : NetConnection = Shell.getInstance().getVideoModel().nc;
			videoOnly.playVideo( url, nc );
			
			trace( "SUMMARY : playVideo() : VIDEO SHOULD BE ACTIVATING" );
			videoOnly.activate();
		}
		
		protected function showMedia( type : String ) : void
		{
			trace( "SUMMARY : showMedia() : type is "+type );
			
			switch( type )
			{
				case SiteConstants.HOTSPOT_TYPE_SCENE:
					addSceneMedia();
					mediaShow();
					break;
				case SiteConstants.HOTSPOT_TYPE_CONTENT:
					addContentMedia();
					mediaShow();
					break;
			}
		}
		
		protected function addVideoOnly( ) : void
		{
			if( videoOnly && mediaHolder.contains( videoOnly ) ) return;
			trace( "SUMMARY : addVideoOnly() : _id is "+_id );
			videoOnly = new VideoOnly();
			videoOnly.social = true;
			videoOnly.type = SiteConstants.EXIT_BUTTON_BACK;
			trace( "SUMMARY : addVideoOnly() : _dto.name is "+_dto.name );
			videoOnly.videoName = _dto.name;
			videoOnly.init();
			videoOnly.addEventListener( Event.COMPLETE,  onExitClick )
			mediaHolder.addChild( videoOnly );
		}
		
		protected function addDualVideo( ) : void
		{
			trace( "\n" );
			trace( "SUMMARY : addDualVideo() .............................." );
			if( danceOff && mediaHolder.contains( danceOff ) ) return;
			trace( "SUMMARY : addDualVideo() : _id is "+_id );
			danceOff = new DualVideo();
			
			danceOff.type = SiteConstants.EXIT_BUTTON_BACK;
			danceOff.init();
			danceOff.setViewSize( AREA_WIDTH, AREA_HEIGHT );
			danceOff.updateViews( AREA_WIDTH, AREA_HEIGHT );
			danceOff.inSummary = true;
			danceOff.addEventListener( Event.COMPLETE,  onExitClick )
			danceOff.transitionIn();
			danceOff.x = -60; //TODO HACK!
			mediaHolder.addChild( danceOff );
		}
		
		protected function addWallpaper( ) : void
		{
			if( wallpaper && mediaHolder.contains( wallpaper ) ) return;
			var id : uint = summaryPanel.id;
			trace( "SUMMARY : addWallpaper() : id is "+id );
			wallpaper = new Wallpaper();
			wallpaper.dto = _contentModel.getContentItemAt( _id );
			wallpaper.type = SiteConstants.EXIT_BUTTON_BACK;
			wallpaper.init();
			wallpaper.addEventListener( Event.COMPLETE,  onExitClick )
			wallpaper.activate();
			mediaHolder.addChild( wallpaper );
		}
		
		protected function addCopyImages( ) : void
		{
			if( copyImages && mediaHolder.contains( copyImages ) ) return;
			var id : uint = summaryPanel.id;
			trace( "SUMMARY : addCopyImages() : id is "+id );
			copyImages = new CopyImages();
			var dto : ContentDTO = _contentModel.getContentItemAt( _id );
			copyImages.type = SiteConstants.EXIT_BUTTON_BACK;
			copyImages.init();
			copyImages.populateByDTO( dto );
			copyImages.addEventListener( Event.COMPLETE,  onExitClick )
			copyImages.activate();
			mediaHolder.addChild( copyImages );
		}
		
		protected function addSceneMedia( ) : void
		{
			if( videoOnly && mediaHolder.contains( videoOnly ) ) return;
			trace( "SUMMARY : addSceneMedia() : _id is "+_id );
//			videoOnly = new VideoOnly();
//			videoOnly.social = true;
//			videoOnly.type = SiteConstants.EXIT_BUTTON_BACK;
//			videoOnly.init();
//			videoOnly.addEventListener( Event.COMPLETE,  onExitClick )
//			mediaHolder.addChild( videoOnly );
			
			addVideoOnly();
//			var name : String = _dto.name;
//			
//			trace( "SUMMARY : showMedia() : name is "+name );
//			switch ( name )
//			{
//				case SiteConstants.SUMMARY_CHEF:
//					addVideoOnly();
//					break;
//				case SiteConstants.SUMMARY_HORSE:
//					addVideoOnly();
//					break;
//				case SiteConstants.SUMMARY_KISS:
//					addVideoOnly();
//					break;
			
			
			
		}
		
		protected function addContentMedia( ) : void
		{
			var name : String = _dto.name;
			
			trace( "SUMMARY : showMedia() : name is "+name );
			switch ( name )
			{
				case SiteConstants.VIGNETTE_BLOND:
					addVideoOnly();
					break;
				case SiteConstants.VIGNETTE_JORDAN:
					addVideoOnly();
					break;
				case SiteConstants.VIGNETTE_HORSE:
					addVideoOnly();
					break;
				case SiteConstants.VIGNETTE_WALLPAPER:
					addWallpaper();
					break;
				case SiteConstants.VIGNETTE_VINTAGE:
					addCopyImages();
					break;
				case SiteConstants.VIGNETTE_3_5:
					addCopyImages();
					break;
				case SiteConstants.EGG_KONAMI:
					addDualVideo();
					break;
			}
		}
		
		protected function stopVideo( ) : void
		{
			if( videoOnly && mediaHolder.contains( videoOnly ) )
			{
				videoOnly.destroyVideo();
			}
		}
		
		protected function toggleSoundIcon( ) : void
		{
			if( videoOnly && mediaHolder.contains( videoOnly ) )
			{
				videoOnly.destroyVideo();
			}
		}
		
		protected function cleanMediaHolder( ) : void
		{
			trace( "\n\n" );
			trace( "SUMMARY : cleanMediaHolder() ..............................................................." );
			for ( var i:uint = 0; i < mediaHolder.numChildren; i++)
			{
				var object : * = mediaHolder.getChildAt(i);
				trace( "SUMMARY : cleanMediaHolder() : object is "+object );
				trace( "SUMMARY : cleanMediaHolder() : typeof (mediaHolder.getChildAt(i)) is "+typeof (mediaHolder.getChildAt(i)) );
				mediaHolder.removeChild( object );
				object = null;
//				trace ('\t|\t ' +i+'.\t name:' + mediaHolder.getChildAt(i).name + '\t type:' + typeof (mediaHolder.getChildAt(i))+ '\t' + mediaHolder.getChildAt(i));
			}
		}	
		
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onSceneClick( e : SummaryEvent) : void 
		{
			trace("\n\n\n.......................................")
			trace( "SUMMARY : onSceneClick()" );
			_id = summaryPanel.id;
			_dto = _contentModel.getSceneItemAt( _id )
			trace( "SUMMARY : onSceneClick() : _dto is "+_dto );
			var name : String = _dto.name;
			trace( "SUMMARY : onSceneClick() : _id is "+_id );
			cleanMediaHolder();
			panelHide();
			
			var type : String = summaryPanel.type;
			showMedia( type );
			trace( "SUMMARY : onSceneClick() : type is "+type );
		}
		
		protected function onContentClick( e : SummaryEvent) : void 
		{
			trace("\n\n\n.......................................")
			trace( "SUMMARY : onContentClick()" );
			_id = summaryPanel.id;
			_dto = _contentModel.getContentItemAt( _id )
			trace( "SUMMARY : onContentClick() : name is "+name );
			cleanMediaHolder();
			
//			var dto : ContentDTO;
			var contentLength : uint = _contentModel.content.length
			trace( "SUMMARY : onContentClick() : contentLength is "+contentLength );
			// SET DTO FOR THE REST OF THE STUFF!
			if( _id >= contentLength )
			{
				_id = _id - contentLength;
				_dto = _contentModel.getEggItemAt( _id );
			}
			else
			{
				_dto = _contentModel.getContentItemAt( _id );
			}
			
			if( _dto.category == SiteConstants.HOTSPOT_CATEGORY_FACTOID )
			{
				return;
			}
			
			panelHide();
			
			var type : String = summaryPanel.type;
			trace( "SUMMARY : onContentClick()" );
			showMedia( type );
		}
		
		protected function onContinueClick( e : Event) : void 
		{
			trace( "SUMMARY : onContinueClick()" );
			continueBtn.removeEventListener( Event.COMPLETE, onContinueClick );
			_stateModel.state = StateModel.STATE_OVERLAY_OUT;
		}
		
		protected function onBuyClick( e : Event) : void 
		{
			trace( "SUMMARY : onBuyClick()" );
			var url : String = ConfigModel.gi.buyURL;
			var request : URLRequest = new URLRequest( url );
			navigateToURL( request, "_self");
		}
		
		protected function onQuickClick( e : Event) : void 
		{
			trace( "SUMMARY : onQuickClick()" );
			var url : String = ConfigModel.gi.quickURL;
			var request : URLRequest = new URLRequest( url );
			navigateToURL( request, "_self");
		}
		
		protected function onExitClick( e : Event) : void 
		{
			trace( "SUMMARY : onExitClick()" );
			stopVideo();
			panelShow();
		}
		
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set contentModel( object : ContentModel ) : void
		{
			trace( "SUMMARY : set contentModel: object is "+object );
			_contentModel = object;
		}
	}
}
