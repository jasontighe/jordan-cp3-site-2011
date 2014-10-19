package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.view.AbstractOverlay;

	import flash.events.Event;
	import flash.net.NetConnection;

	/**
	 * @author jason.tighe
	 */
	public class Vignette 
	extends AbstractOverlay 
	{
		//----------------------------------------------------------------------------
		// protected function 
		//----------------------------------------------------------------------------
		protected var _currentInterface					: AbstractVignette;
		protected var _name								: String;
		protected var _dto								: ContentDTO;
		//----------------------------------------------------------------------------
		// public function 
		//----------------------------------------------------------------------------
		public var copyImages							: CopyImages;
		public var copyVideo							: CopyVideo;
		public var wallpaper							: Wallpaper;
		public var videoOnly							: VideoOnly;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Vignette() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function updateViews( w : uint, h : uint ) : void
		{
//			trace( "VIGNETTE : updateViews()" );
			_name = Shell.getInstance().getContentModel().hotspotName;
//			trace( "VIGNETTE : updateViews() : _name is "+_name );
			_dto = Shell.getInstance().getContentModel().getContentItemByName( _name );
//			trace( "VIGNETTE : updateViews() : _dto is "+_dto );
			
			if( _currentInterface && contains( _currentInterface ) )
			{
//			trace( "VIGNETTE : updateViews() : THIS ALREADY CONTAINS THIS VIGNETTE" );
			}
			
			addInterface( _name );
			_currentInterface.stateModel = _stateModel;
			_currentInterface.populateByDTO( _dto );
			_currentInterface.addEventListener( Event.COMPLETE, onExitClick )
			addChild( _currentInterface );
			
			if( _name == SiteConstants.VIGNETTE_BLOND || _name == SiteConstants.VIGNETTE_JORDAN
				 || _name == SiteConstants.VIGNETTE_HORSE )
			{
				var url : String = Shell.getInstance().getVideoModel().getUrlByName( _name );
				var videoInterface : VideoOnly = _currentInterface as VideoOnly;
				var nc : NetConnection = Shell.getInstance().getVideoModel().nc;
				videoInterface.playVideo( url, nc );
			}
			
			center();
		}
		
		public override function transitionIn() : void
		{
			TweenLite.to( this, TIME_OUT, { alpha: 1, onComplete: transitionInComplete  } );
		}
		
		public override function transitionOut() : void
		{
//			trace( "VIGNETTE : transitionIn()" );
			if( _name == SiteConstants.VIGNETTE_BLOND || _name == SiteConstants.VIGNETTE_JORDAN )
			{
				var videoInterface : VideoOnly = _currentInterface as VideoOnly;
				videoInterface.destroyVideo();
			}
			TweenLite.to( this, TIME_OUT, { alpha: 0, onComplete: transitionOutComplete  } );
		}
		
		public function pauseVignette() : void
		{
//			trace( "VIGNETTE : pauseVignette()" );
			if( _name == SiteConstants.VIGNETTE_BLOND || _name == SiteConstants.VIGNETTE_JORDAN
				 || _name == SiteConstants.VIGNETTE_HORSE )
			{
				var videoInterface : VideoOnly = _currentInterface as VideoOnly;
				videoInterface.pauseStream();
			}
		}
		
		public function resumeVignette() : void
		{
//			trace( "VIGNETTE : resumeVignette()" );
			if( _name == SiteConstants.VIGNETTE_BLOND || _name == SiteConstants.VIGNETTE_JORDAN
				 || _name == SiteConstants.VIGNETTE_HORSE )
			{
				var videoInterface : VideoOnly = _currentInterface as VideoOnly;
				videoInterface.resumeStream();
			}
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected override function transitionInComplete() : void
		{
//			trace( "VIGNETTE : transitionInComplete()" );
			_currentInterface.activate();
		}
		
		protected function addInterface( name : String ) : void
		{
//			trace( "VIGNETTE : addInterface() : name is "+name );
			
			if( _currentInterface != null )
			{
				removeChild( _currentInterface );
			}
			
			switch( name )
			{
				case SiteConstants.VIGNETTE_3_5:
					addCopyImages();
					break;
				case SiteConstants.VIGNETTE_VINTAGE:
					addCopyImages();
					break;
				case SiteConstants.VIGNETTE_WALLPAPER:	
					addWallpaper();
					break;
				case SiteConstants.VIGNETTE_JORDAN:
					addVideoOnly();
					break;
				case SiteConstants.VIGNETTE_BLOND:
					addVideoOnly();
					break;
				case SiteConstants.VIGNETTE_HORSE:
					addVideoOnly();
					break;
			}
		}
		
		protected function addCopyImages( ) : void
		{
			copyImages = new CopyImages();
			copyImages.init();
			_currentInterface = copyImages;
		}
		
		protected function addCopyVideo( ) : void
		{
//			trace( "VIGNETTE : addCopyVideo()" );
			copyVideo = new CopyVideo();
			copyVideo.init();
			_currentInterface = copyVideo;
		}
		
		protected function addWallpaper( ) : void
		{
//			trace( "VIGNETTE : addWallpaper() : _dto is "+_dto );
			wallpaper = new Wallpaper();
			wallpaper.dto = _dto;
			wallpaper.init();
			_currentInterface = wallpaper;
		}
		
		protected function addVideoOnly( ) : void
		{
//			trace( "VIGNETTE : addVideoOnly()" );
			videoOnly = new VideoOnly();
			videoOnly.init();
			_currentInterface = videoOnly;
		}
		
//		protected function addDualVideo( ) : void
//		{
//			dualVideo = new DualVideo();
//			_currentInterface = dualVideo;
//		}
		
		public function set dto( object : ContentDTO ) : void
		{
//			trace( "VIGNETTE : set dto()" );
			_dto = object;
		}
		
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onExitClick( e : Event = null ) : void
		{
//			trace( "VIGNETTE : onExitClick() XXXXXXXX" );
			_stateModel.state = StateModel.STATE_VIGNETTE_OUT;
		}
	}
}
