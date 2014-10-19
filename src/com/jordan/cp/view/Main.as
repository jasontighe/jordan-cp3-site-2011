package com.jordan.cp.view {
	import com.demonsters.debugger.MonsterDebugger;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.Shell;
	import com.jordan.cp.audio.VoiceOver;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.KeyboardManager;
	import com.jordan.cp.managers.StateManager;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.jordan.cp.model.events.StateEvent;
	import com.jordan.cp.players.TimeTracker;
	import com.jordan.cp.players.VideoTransitionView;
	import com.jordan.cp.ui.KeyboardCaptureChecker;
	import com.jordan.cp.view.email.Email;
	import com.jordan.cp.view.help.Help;
	import com.jordan.cp.view.intro.Intro;
	import com.jordan.cp.view.landing.Landing;
	import com.jordan.cp.view.menu_lower.LowerNavBar;
	import com.jordan.cp.view.menu_lower.Sound;
	import com.jordan.cp.view.menu_upper.UpperNavBar;
	import com.jordan.cp.view.scene.SceneView;
	import com.jordan.cp.view.summary.Summary;
	import com.jordan.cp.view.video.IScenePlayer;
	import com.jordan.cp.view.video.VideoView;
	import com.jordan.cp.view.vignette.DualVideo;
	import com.jordan.cp.view.vignette.Vignette;
	import com.jordan.cp.view.welcome.Welcome;
	import com.plode.framework.managers.sound.PlodeSoundItem;
	import com.plode.framework.managers.sound.PlodeSoundManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jason.tighe
	 */
	public class Main 
	extends MovieClip 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _stateManager							: StateManager;
		protected var _keyboardManager						: KeyboardManager;
		protected var _stateModel 							: StateModel;
		protected var _currentView							: *;
		protected var _currentVideo							: *;
		protected var _previousView							: *;
		protected var _currentOverlay						: AbstractOverlay;
		protected var _currentVignette						: AbstractOverlay;
		protected var _navVisible							: Boolean = false;
		protected var _isVignette							: Boolean = false;
		protected var _vignetteHidden						: Boolean = false;
		protected var _vignetteArray						: Array;
		protected var soundManager							: PlodeSoundManager;
		protected var _keyCaptureCheck						: KeyboardCaptureChecker;
		protected var _vo									: VoiceOver;
		protected var _tt									: TimeTracker = TimeTracker.gi;
		protected var _tm									: TrackingManager = TrackingManager.gi;
		protected var _sound								: Sound;
		
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var viewHolder								: MovieClip;
		public var vignetteHolder							: MovieClip;
		public var overlayHolder							: MovieClip;
		public var navHolder								: MovieClip;
		public var landing									: Landing;
		public var intro									: Intro;
		public var videoView								: VideoView;
		public var sceneView								: SceneView;
		public var help										: Help;
		public var email									: Email;
		public var summary									: Summary;
		public var lowerNavBar								: LowerNavBar;
		public var upperNavBar								: UpperNavBar;
		public var vignette									: Vignette;
		public var danceOff									: DualVideo;
		public var offset									: uint = 20;
		
		private var _videoTransition						: VideoTransitionView = VideoTransitionView.gi;
		private var _zoomIn : Boolean;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Main() 
		{
			trace( "MAIN : Constr  " );
			super();
//			init();
		}
		
		
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function init() : void
		{
			trace( "MAIN : init()" );
			addStateModel();
			addManagers();
			addHolders();
			
//			_vignetteArray = new Array( SiteConstants.VIGNETTE_3_5, SiteConstants.VIGNETTE_BLOND, SiteConstants.VIGNETTE_JORDAN, SiteConstants.VIGNETTE_VINTAGE, SiteConstants.VIGNETTE_WALLPAPER );
			_vignetteArray = new Array( SiteConstants.VIGNETTE_WALLPAPER );
			
			TimeTracker.gi.addEventListener(TimeTracker.BANDWIDTH_CHANGED, onBandwidthChanged);
		}
				
		private function onBandwidthChanged(event : Event) : void
		{
			// IMMEDIATELY UPDATE VIDEO
			if(_currentVideo && !IScenePlayer(_currentVideo).isPaused)
			{
				_currentVideo.pause();
				_currentVideo.resume();
			}
		}

		public function updateViews( stageW : uint, stageH : uint ) : void
		{
			// THIS IS ONLY CALLED FROM SHELL ON STAGE RESIZE...
			
//			trace( "MAIN : updateViews() : stageW is "+stageW+" : stageH is "+stageW );
//			trace( "MAIN : updateViews() : _currentView is "+_currentView );
			var w : uint = stageW;
			var h : uint = stageH;
			_currentView.updateViews( w, h );
			if( _currentOverlay && contains( _currentOverlay ) ) _currentOverlay.updateViews( w, h );
			
			if( _navVisible )	updateNavgationBars( w, h );
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addStateModel() : void
		{
			_stateModel = new StateModel();
			_stateModel.addEventListener( StateEvent.LANDING, onStateChange );
			_stateModel.addEventListener( StateEvent.INTRO, onStateChange );
			_stateModel.addEventListener( StateEvent.MAIN, onStateChange );
			_stateModel.addEventListener( StateEvent.SCENE, onStateChange );
			_stateModel.addEventListener( StateEvent.VIGNETTE, onStateChange );
			_stateModel.addEventListener( StateEvent.HELP, onStateChange );
			_stateModel.addEventListener( StateEvent.EMAIL, onStateChange );
			_stateModel.addEventListener( StateEvent.SUMMARY, onStateChange );
			_stateModel.addEventListener( StateEvent.OVERLAY_OUT, onStateChange );
			_stateModel.addEventListener( StateEvent.VIGNETTE_OUT, onStateChange );
			_stateModel.addEventListener( StateEvent.DANCE_OFF, onStateChange );
		}

		protected function addManagers() : void
		{
			_keyboardManager = new KeyboardManager();
			_keyboardManager.addEventListener( Event.COMPLETE, onKeyboardComplete );
			addChild( _keyboardManager );
			addSoundManager();
		}
		
		// holder all views go in holder clip so nav bars can stay above
		protected function addHolders() : void
		{
			trace( "MAIN : addHolders()" );
			viewHolder = new MovieClip();
			addChild( viewHolder );
			
			navHolder = new MovieClip();
			addChild( navHolder );
			
			vignetteHolder = new MovieClip();
			addChild( vignetteHolder );
			
			overlayHolder = new MovieClip();
			addChild( overlayHolder );
		}
		
		protected function addSoundManager() : void
		{
			soundManager = PlodeSoundManager.gi;
		}
		
		protected function initView( view : * ) : void
		{
			trace( "MAIN : initView() : view is "+view );
			view.stateModel = _stateModel;
			view.init();
			view.hide();
			setViewSize( view );
			view.updateViews( Shell.getInstance().stageW, Shell.getInstance().stageH );
			_currentView = view;
			view.transitionIn();
			viewHolder.addChild( view );
		}
		
		protected function initOverlay( overlay : AbstractOverlay ) : void
		{
			trace( "\n\n\n" );
			trace( "MAIN : initOverlay() : overlay is "+overlay );
			overlay.stateModel = _stateModel;
			overlay.init();
//			overlay.hide();
			setViewSize( overlay );
			overlay.updateViews( Shell.getInstance().stageW, Shell.getInstance().stageH );
			_currentOverlay = overlay;
			overlay.addEventListener( ContainerEvent.HIDE, onOverlayHide );
			overlay.transitionIn();
			
			// ADD OVERLAYS INTO SEPARATE HOLDERS
			if( overlay is Vignette || overlay is DualVideo )
			{	
				trace( "MAIN : initOverlay() : THE OVERYLAY IS A VIGNETTE!!!!!" );
				addToVignetteHolder( overlay );
			}
			else if( overlay is LowerNavBar || overlay is UpperNavBar )
			{
				addToNavHolder( overlay );
			}
			else
			{
				addToOverlayHolder( overlay );
			}
			//////////////////////////////////////
		}
		
		// ADD OVERLAYS INTO SEPARATE HOLDERS
		protected function addToVignetteHolder( overlay : AbstractOverlay ) : void
		{
			trace( "MAIN : addToVignetteHolder() : overlay is "+overlay );
			cleanHolder( vignetteHolder	 );
			vignetteHolder.addChild( overlay );
		}
		
		protected function addToOverlayHolder( overlay : AbstractOverlay ) : void
		{
			trace( "MAIN : addToOverlayHolder() : overlay is "+overlay );
			
			if( _currentOverlay == email || _currentOverlay == summary )
			{
				trace( "MAIN : addToOverlayHolder() : ACTIVATE LOWER NAV BAR MAIN MENU WHEN SWITCHING OVERLAY SCREENS" );
				lowerNavBar.resetMainNav();
			}
			cleanHolder( overlayHolder );
			overlayHolder.addChild( overlay );
		}
		
		protected function addToNavHolder( overlay : AbstractOverlay ) : void
		{
			trace( "MAIN : addToNavHolder() : overlay is "+overlay );
			navHolder.addChild( overlay );
		}
		//////////////////////////////////////
		
		protected function cleanHolder( holder : MovieClip ) : void
		{
			trace( "\n\n" );
			trace( "MAIN : cleanHolder() : holder is "+holder+" ..............................................................." );
			for ( var i:uint = 0; i < holder.numChildren; i++)
			{
				var object : * = holder.getChildAt(i);
				trace( "MAIN : cleanMediaHolder() : object is "+object );
				trace( "MAIN : cleanMediaHolder() : typeof (mediaHolder.getChildAt(i)) is "+typeof (holder.getChildAt(i)) );
				holder.removeChild( object );
				object = null;
//				trace ('\t|\t ' +i+'.\t name:' + holder.getChildAt(i).name + '\t type:' + typeof (holder.getChildAt(i))+ '\t' + holder.getChildAt(i));
			}
		}	
		
		protected function updateNavgationBars( stageW : uint, stageH : uint) : void
		{
			upperNavBar.updateViews( stageW, stageH );
			lowerNavBar.updateViews( stageW, stageH );
		}
		
		protected function setViewSize( view : * ) : void
		{
			var w : uint = Shell.getInstance().stageW;
			var h : uint = Shell.getInstance().stageH;
			view.setViewSize( w, h );
		}
		
		protected function showLanding() : void
		{
			trace( "MAIN : showLanding()" );
			if( landing && contains( landing ) )
			{
				landing.transitionIn();
				_currentView = landing;
			}
			else
			{
				landing = new Landing();
				var welcome : Welcome = Shell.getInstance().welcome;
				landing.welcome = welcome;
				trace( "MAIN : showLanding() : welcome is "+welcome );
				initView( landing );
			}
		}
		
		protected function showIntro() : void
		{
//			trace( "MAIN : showIntro()" );
			if( intro && contains( intro ) )
			{
				intro.transitionIn();
				_currentView = intro;
			}
			else
			{
				intro = new Intro();
				var nc : NetConnection = Shell.getInstance().getVideoModel().nc;
				intro.nc = nc;
				var url : String = Shell.getInstance().getVideoModel().getIntroUrl();
				intro.url = url;
				initView( intro );
			}
		}
		
		protected function showVideoView() : void
		{
			trace('\n\n\n-------------------------------------------------------------');
			trace( "MAIN : showVideoView()" );
			trace( "Main.showVideoView._stateModel.previousState: " + _stateModel.previousState );
			trace( "CURRENT STATE: " + _stateModel.state );
			
			if( videoView && contains( videoView ) )
			{
				// TODO - THIS CONDITIONAL DOESN'T SEEM TO DO ANYTHING
				// - previousState is already Main most of the time?
//				if( _stateModel.previousState == StateModel.STATE_SUMMARY  )
				if( _currentOverlay == summary &&  _stateModel.previousState == StateModel.STATE_MAIN )
				{
//					videoView.restart();
					videoView.resume();
				}
				else
				{
					if(_stateModel.previousState == StateModel.STATE_SCENE)
					{
						// SET DIRECTION FOR TRANSITION ANIMATION
						_zoomIn = false;

						_videoTransition.showTransition(_zoomIn);
						_videoTransition.animateTransition(_zoomIn);
					}

					videoView.resume();
				}

				videoView.transitionIn();
				_currentView = videoView;
			}
			else
			{
				videoView = new VideoView();
				initView( videoView );

				addBgLoop();
			}
			
			TimeTracker.gi.showUtilNav();
			_currentVideo = videoView;
		}
		
		private function addBgLoop() : void
		{
			var psm : PlodeSoundManager = PlodeSoundManager.gi;
			psm.fadeGlobalVolume(1);

			var item : PlodeSoundItem = psm.getSound(SiteConstants.AUDIO_BG_LOOP);
			item.looping = true;
			item.play();
		}

		protected function showSceneView() : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace("Main.showSceneView() : prev state:", _stateModel.previousState, _stateModel.state);
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			trace( "MAIN : showSceneView()" );

			if( sceneView && contains( sceneView ) )
			{
				// PREVIOUS STATE CAN BE SCENE WHEN AN OVERLAY IS CLOSED
				if( _stateModel.previousState == StateModel.STATE_VIGNETTE || _stateModel.previousState == StateModel.STATE_SCENE )
				{
					trace( "MAIN : showSceneView() : CASE 1 RESUME SCENE" );
					sceneView.resume();
				}
				else
				{
					trace( "MAIN : showSceneView() : CASE 2 SHOW VIDEO TRANSITION, SCENE RESTART" );
					sceneView.restart();
				}

				sceneView.transitionIn();
				_currentView = sceneView;
			}
			else
			{
				_tt.videoDuration = 0;
				sceneView = new SceneView();
				sceneView.addEventListener(SceneView.STREAM_READY, onSceneReady );
				initView( sceneView );

				setupVideoTransition();
			}

			// SET TRANSITION ZOOM DIRECTION
			_zoomIn = true;
			if(_stateModel.previousState != StateModel.STATE_SCENE)
			{
				// SHOULD ONLY SHOW IF NOT OVERLAY
				_videoTransition.showTransition(_zoomIn);
			}
			
			TimeTracker.gi.hideUtilNav();
			_currentVideo = sceneView;
		}
		
		private function setupVideoTransition() : void
		{
			if(!_videoTransition.parent)
			{
				trace('\n\n\n-------------------------------------------------------------');
				trace("Main.showVideoTransition : SHOULD ONLY HAPPEN ONCE");
				trace('-------------------------------------------------------------\n\n\n');
				_videoTransition.mouseEnabled = false;
//				_videoTransition.addEventListener(Event.COMPLETE, onVideoTransitionComplete);
				viewHolder.addChild(_videoTransition);
			}

// TODO
// - ASSIGN LISTENERS FOR VIDEO STATES


//			_videoTransition.setBmp(videoView);

//			if(zoomIn)
//			{
trace('\n\n\n-------------------------------------------------------------');
trace("Main.showVideoTransition");
trace('-------------------------------------------------------------\n\n\n');
//				_videoTransition.showTransition(zoomIn);
//				sceneView.addEventListener(SceneView.STREAM_READY, onSceneReady );

//				if(!_videoTransition.hasEventListener(Event.COMPLETE))
//					_videoTransition.addEventListener(Event.COMPLETE, onVideoTransitionComplete);
//			}
			
		}

		private function onSceneReady(event : Event) : void
		{
			trace('\n\n\n-------------------------------------------------------------');
			trace("Main.onSceneReady : ANIMATE TRANSITION"); 
			trace('-------------------------------------------------------------\n\n\n');
			_videoTransition.animateTransition(_zoomIn);
		}

//		private function onVideoTransitionComplete(event : Event) : void 
//		{
//			trace('\n\n\n\n\n\n----------------------------------------------------------');
//			trace("Main.onVideoTransitionComplete(event)");
//			trace('----------------------------------------------------------\n\n\n\n\n\n');
//
//			_videoTransition.removeEventListener(Event.COMPLETE, onVideoTransitionComplete);
//			sceneView.removeEventListener(SceneView.STREAM_READY, onSceneReady );
//		}

		protected function showNavgationBars() : void
		{
			trace( "MAIN : showNavgationBars()" );
			if( _navVisible )
			{
				return;
			}
			else
			{
				trace( "MAIN : showNavgationBars() XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX : _navVisible is "+_navVisible );
				upperNavBar = new UpperNavBar();
				initOverlay( upperNavBar );
				
				lowerNavBar = new LowerNavBar();
				lowerNavBar.contentModel = ContentModel.gi;
				lowerNavBar.jsBridge = Shell.getInstance().jsBridge();
				lowerNavBar.addEventListener( Event.COMPLETE, onLowerNavComplete );
				initOverlay( lowerNavBar );
				_sound = lowerNavBar.getSound();
				
				_navVisible = true;
			}
		}
		
		protected function showHelp() : void
		{
			trace( "MAIN : showHelp()" );
			if( help && contains( help ) )
			{
				help.updateViews( Shell.getInstance().stageW, Shell.getInstance().stageH );
				help.transitionIn();
			}
			else
			{
				help = new Help();
				initOverlay( help );
			}
		}
		
		protected function showEmail() : void
		{
			trace( "MAIN : showEmail()" );
			if( email && contains( email ) )
			{
				email.updateViews( Shell.getInstance().stageW, Shell.getInstance().stageH );
				email.transitionIn();
			}
			else
			{
				email = new Email();
				initOverlay( email );
			}
		}
		
		protected function showVignette() : void
		{
//			trace( "MAIN : showVignette()" );
			if( vignette && contains( vignette ) )
			{
				vignette.transitionIn();
			}
			else
			{
				vignette = new Vignette();
				initOverlay( vignette );
			}
			
			_currentVignette = vignette;
		}
		
		protected function showDanceOff() : void
		{
			trace( "MAIN : showHelp()" );
			if( danceOff && contains( danceOff ) )
			{
				danceOff.updateViews( Shell.getInstance().stageW, Shell.getInstance().stageH );
				danceOff.transitionIn();
			}
			else
			{
				danceOff = new DualVideo();
				initOverlay( danceOff );
			}
			
			_currentVignette = danceOff;
		}
		
		protected function showSummary() : void
		{
			trace( "MAIN : showSummary()" );
			if( summary && contains( summary ) )
			{
				summary.transitionIn();
			}
			else
			{
				summary = new Summary();
				var contentModel : ContentModel = Shell.getInstance().getContentModel();
				summary.contentModel = contentModel;
				summary.addViews();
				trace( "MAIN : showSummary() : contentModel is "+contentModel );
				initOverlay( summary );
			}
			
			// DON'T KNOW WHY BUT SCENEVIEW IS ALWAYS SET AS CURRENTVIEW SOMEWHERE
			// SO.....
			_previousView = videoView;
			videoView.hideEndframe();
		}
		
		protected function showPreviousView() : void
		{
			var previousState : String = _stateModel.previousState;
			trace( "MAIN : showPreviousView() : previousState is "+previousState );
		}
		
		protected function toggleSound() : void
		{
			trace( "MAIN : toggleSound()" );
			_sound.toggleSound();
			
//			var globalVolume : Number = soundManager.globalVolume;
//			if( globalVolume == 0 )
//			{
//				soundManager.fadeGlobalVolume( 1, SiteConstants.TIME_IN );
//			}
//			else
//			{
//				soundManager.fadeGlobalVolume( 0, SiteConstants.TIME_IN );
//			}
		}
		
		protected function activeVignette( ) : Boolean
		{
			var activeVignette : Boolean = false;
			if( vignetteHolder.numChildren > 0 )	
				activeVignette = true;
			
			trace( "MAIN : checkForVignette() : activeVignette is << "+activeVignette+" >> ....vignetteHolder.numChildren is "+vignetteHolder.numChildren+" ......................................" );
			return activeVignette;
		}
		
		protected function activeOverlay( ) : Boolean
		{
			var activeOverlay : Boolean = false;
			if( overlayHolder.numChildren > 0 )	
				activeOverlay = true;
				
			trace( "MAIN : activeOverlay() : activeOverlay is << "+activeOverlay+" >> ....overlayHolder.numChildren is "+overlayHolder.numChildren+" ......................................" );
			
			return activeOverlay;
		}
		
		protected function hideVignetteBeforeOverlay( ) : void
		{
			trace( "MAIN : hideVignetteForOverlay() XXXX" );
			vignetteHolder.visible = false;
//			vignetteHolder.alpha = .5; // FOR VIDEO PAUSE TESTING
			_vignetteHidden = true;
			
			for ( var i:uint = 0; i < vignetteHolder.numChildren; i++)
			{
				var object : * = vignetteHolder.getChildAt(i);
				trace( "MAIN : hideVignetteForOverlay() : object is "+object );
				if( object is Vignette || DualVideo )
				{
					object.pauseVignette();
				}
			}
		}
		
		protected function showVignetteAfterOverlay( ) : void
		{
			trace( "MAIN : showVignetteAfterOverlay() XXXX" );
			vignetteHolder.visible = true;
//			vignetteHolder.alpha = 1; // FOR VIDEO RESUME TESTING
			_vignetteHidden = false;
			
			for ( var i:uint = 0; i < vignetteHolder.numChildren; i++)
			{
				var object : * = vignetteHolder.getChildAt(i);
				trace( "MAIN : showVignetteAfterOverlay() : object is "+object );
				if( object is Vignette || DualVideo )
				{
					object.resumeVignette();
				}
			}
		}
		
		protected function hideOverlay() : void
		{
			trace( "MAIN : hideOverlay() : _currentOverlay is "+_currentOverlay );
			_currentOverlay.transitionOut();	
			
			if( _currentOverlay == help )
			{
				trace( "MAIN : hideOverlay() : ACTIVATE LOWER NAV BAR MAIN MENU WHEN CLOSING HELP SCREEN" );
				lowerNavBar.resetMainNav();
			}
			
			// ????					
//			if( _currentView == videoView || _currentView == sceneView )
//			{
//				trace( "MAIN : hideOverlay() : _currentView is a video player view: "+_currentView );
//				if(_stateModel.previousState == StateModel.STATE_SUMMARY && _currentView == videoView)
//				{
//					trace("Main.hideOverlay() : _stateModel.previousState: IS SUMMARY OVER VIDEOVIEW: " + (_stateModel.previousState));
//					_currentVideo.restart();
//				}
////				else if( activeVignette() && activeOverlay() )
////				{
////					trace( "MAIN : hideOverlay() : THERE ARE ITEMS IN BOTH VIGNETTE AND OVERLAY HOLDERS, SO RETURN" );
////					return;
////				}
//				else
//				{
//					trace( "MAIN : hideOverlay() : VIDEO OR BONUS SCENE IS BEING CALLED TO RESUME", _currentVideo );
//					_currentVideo.resume();
//				}
//			}
		}
		
		protected function activateCommentary() : void
		{
			_tt.showUtilNav();
		}
		
		protected function deactivateCommentary() : void
		{
			_tt.hideUtilNav();
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onStateChange( e : StateEvent ) : void
		{
//			trace( "MAIN : onStateChange() : e.type is "+e.type );
			var state : String = e.type;
			var previousState : String = _stateModel.previousState;
			trace('\n\n\n-------------------------------------------------------------');
			trace( "MAIN : onStateChange() : state is "+state );
			trace( "MAIN : onStateChange() : previousState is "+previousState );
			trace( "MAIN : onStateChange() : _currentView is "+_currentView );
			trace( "MAIN : onStateChange() : _previousView is "+_previousView );
			trace( "Main.onStateChange._previousView: " + _previousView );
			trace( "MAIN : onStateChange() : _currentOverlay is "+_currentOverlay );
			
			
			// USE FOR OVERLAY AND OVERLAY OUT
			var activeVignette : Boolean = activeVignette();
			var activeOverlay : Boolean = activeOverlay();
//
			if( _currentView != null )
			{
				_previousView = _currentView;
				
				var isOverlay : Boolean = ( state == StateModel.STATE_VIGNETTE 
										 	|| state == StateModel.STATE_HELP 
										 	|| state == StateModel.STATE_EMAIL 
										 	|| state == StateModel.STATE_SUMMARY 
										 	|| state == StateModel.STATE_DANCE_OFF );
				if(isOverlay)
				{
					trace('-------------------------------------------------------------');
					trace( "MAIN : onStateChange() isOverlay : activeVignette is "+activeVignette+" : CASE 0 : VIGNETTE IS ACTIVE" );
					
					
					//PAUSE VIDEO BEHIND AND BLUR FOR OVERLAY ONLY IF OVERLAY IS NOT OVER VIGNETTE
		            if( previousState == StateModel.STATE_MAIN && !activeVignette || previousState == StateModel.STATE_SCENE && !activeVignette)			
					{
						trace( "MAIN : onStateChange() : CASE 1 : PAUSE VIDEO BECAUSE OF !!!OVERLAY!!! STATE CHANGE :: _currentVideo is "+_currentVideo );
						trace( "MAIN : onStateChange() : CASE 1 : PAUSE VIDEO BECAUSE OF !!!OVERLAY!!! STATE CHANGE :: _currentVideo.isPaused is "+_currentVideo.isPaused );
						if( !_currentVideo.isPaused )
							_currentVideo.pause( isOverlay );
					}					
				}
				// PAUSE VIDEO WHEN SWITCHING TO BONUS SCENE
	            else if( previousState == StateModel.STATE_MAIN 
	            		&& state != StateModel.STATE_MAIN 
	            		&& state != StateModel.STATE_OVERLAY_OUT 
	            		&& state != StateModel.STATE_VIGNETTE_OUT ) 
				{
					trace( "MAIN : onStateChange() : CASE 2 : PREVIOUS STATE IS MAIN" );
					_currentVideo.pause( isOverlay );
				}
				// PREVIOUS STATE CAN EQUAL STATE IN SCENE WHEN AN OVERLAY IS CLOSED
				else if( state != previousState 
						&& state != StateModel.STATE_OVERLAY_OUT 
						&& state != StateModel.STATE_VIGNETTE_OUT )
				{
					// HIDE OLD VIEW
					trace( "MAIN : onStateChange() : CASE 3 : default" );
					trace( "Main.onStateChange._previousView: " + _previousView );
					trace("Main.onStateChange(e) : _currentView : " + _currentView);
					_currentView.transitionOut();
				}
			}
			
			switch( state )
			{
				case StateModel.STATE_LANDING:
					showLanding();
					_stateModel.previousState = state;
					break;
				case StateModel.STATE_INTRO:
					showIntro();
					_stateModel.previousState = state;
					break;
				case StateModel.STATE_MAIN:
					activateCommentary();
					showVideoView();
					_stateModel.previousState = state;
					showNavgationBars();
					break;
				case StateModel.STATE_SCENE:
					activateCommentary();
					showSceneView();
					_stateModel.previousState = state;
					break;
				case StateModel.STATE_VIGNETTE:
					deactivateCommentary();
					showVignette();
					break;
				case StateModel.STATE_HELP:
					deactivateCommentary();
					_tm.trackPage(TrackingConstants.START_EXPLORING );
					// THIS IS FOR OVERLAY BUG
					if( activeVignette )	hideVignetteBeforeOverlay();
					showHelp();
					break;
				case StateModel.STATE_EMAIL:
					deactivateCommentary();
					// THIS IS FOR OVERLAY BUG
					if( activeVignette )	hideVignetteBeforeOverlay();
					showEmail();
					break;
				case StateModel.STATE_SUMMARY:
					deactivateCommentary();
					// THIS IS FOR OVERLAY BUG
					if( activeVignette )	hideVignetteBeforeOverlay();
					showSummary();
					_tm.trackPage(TrackingConstants.OVERLAY_RESOLVE );
					break;
				case StateModel.STATE_DANCE_OFF:
					deactivateCommentary();
					showDanceOff();
					break;
				case StateModel.STATE_OVERLAY_OUT:
					trace( "\n\n\n" );
					trace( "MAIN : onStateChange() : switch ........ StateModel.STATE_OVERLAY_OUT" );
					trace( "MAIN : onStateChange() : switch ........ activeVignette is "+activeVignette );
					trace( "MAIN : onStateChange() : switch ........ activeOverlay is "+activeOverlay );
					if( _vignetteHidden )
					{		
						trace( "MAIN : onStateChange() : switch ........ CASE 1 : _vignetteHidden is "+_vignetteHidden );
						showVignetteAfterOverlay();
						hideOverlay();
						_currentOverlay = _currentVignette;
					}
					else
					{
						trace( "MAIN : onStateChange() : switch ........ CASE 2 : _vignetteHidden is "+_vignetteHidden );
						_stateModel.state = _stateModel.previousState;
						hideOverlay();
					}
					break;
				case StateModel.STATE_VIGNETTE_OUT:
					trace( "\n\n\n" );
					trace( "MAIN : onStateChange() : switch ........ StateModel.STATE_VIGNETTE_OUT" );
					trace( "MAIN : onStateChange() : switch ........ activeVignette is "+activeVignette );
					trace( "MAIN : onStateChange() : switch ........ activeOverlay is "+activeOverlay );
					hideOverlay();
					_stateModel.state = _stateModel.previousState;
					break;
			}
		}
		
		protected function onLandingComplete( e : Event ) : void
		{
			trace( "MAIN : onLandingComplete()" );
			landing.removeEventListener( Event.COMPLETE, onLandingComplete );
			landing.transitionIn();
		}
		
		protected function onOverlayHide( e : ContainerEvent ) : void
		{
			trace( "MAIN : onOverlayHide() : e.target is "+e.target );
			var overlay : AbstractOverlay = e.target as AbstractOverlay;
			overlay.removeEventListener( ContainerEvent.HIDE, onOverlayHide );

			// REMOVE OVERLAYS FROM SEPARATE HOLDERS
			if( overlay is Vignette || overlay is DualVideo )
			{	
				removeVignetteHolder( overlay );
			}
			else
			{
				removeFromOverlayHolder( overlay );
			}
			//////////////////////////////////////
		}
		
		// ADD OVERLAYS INTO SEPARATE HOLDERS
		protected function removeVignetteHolder( overlay : AbstractOverlay ) : void
		{
			trace( "MAIN : removeVignetteHolder() : overlay is "+overlay );
			vignetteHolder.removeChild( overlay );
		}
		
		protected function removeFromOverlayHolder( overlay : AbstractOverlay ) : void
		{
			trace( "MAIN : removeFromOverlayHolder() : overlay is "+overlay );
			overlayHolder.removeChild( overlay );
		}
		//////////////////////////////////////
		
		protected function getRandomVignetteName() : String
		{
			var num : uint = Math.round( Math.random() * ( _vignetteArray.length - 1 ) );
			var name : String = _vignetteArray[ num ];
			trace( "MAIN : getRandomVignetteName() : num is "+num );
			trace( "MAIN : getRandomVignetteName() : name is "+name );
			return name;
		}
		
		protected function onKeyboardComplete( e : Event ) : void
		{
			if( _stateModel.state == StateModel.STATE_EMAIL )	return;
			
			
			var keyCode : uint = _keyboardManager.keyCode;
			trace( "MAIN : onKeyboardComplete() : keyCode is "+keyCode );

			// SET UP CHECKER FOR EASTER EGGS
			if(!_keyCaptureCheck) _keyCaptureCheck = new KeyboardCaptureChecker();
			var eggId : String= _keyCaptureCheck.checkCodes(keyCode.toString());
			if(eggId != '') checkEasterEggs(eggId);


			switch( keyCode )
			{
//				case 74: // "j"
//					_stateModel.state = StateModel.STATE_MAIN;
//					break;
				case 68: // "d"
					_stateModel.state = StateModel.STATE_DANCE_OFF;
					break;
//				case 86: // "v"
//					// USED TO TEST RANDOM VIGNETTES
//					var name : String = getRandomVignetteName(); 
//					Shell.getInstance().getContentModel().hotspotName = name;
//					_stateModel.state = StateModel.STATE_VIGNETTE;
//					break;
				case 77: // "m"
					toggleSound();
					break;
			}
		}

		private function checkEasterEggs(id : String) : void 
		{
//			trace( "MAIN : checkEasterEggs() : id is "+id );
			var contentModel : ContentModel = Shell.getInstance().getContentModel();
			contentModel.hotspotName = id;
			
			MonsterDebugger.inspect(this);
//          MonsterDebugger.trace(this, "Hello World!");
// 			MonsterDebugger.breakpoint(this);

			var dto : ContentDTO = contentModel.getContentItemByName(id) as ContentDTO;
//			trace("Main.checkEasterEggs(id) : dto: " + (dto));
//			trace( "MAIN : checkEasterEggs() : dto.id is "+dto.id );
//			trace( "MAIN : checkEasterEggs() : TimeTracker.SPEED_REG is "+TimeTracker.SPEED_REG );
//			trace( "MAIN : checkEasterEggs() : _tt.currentSpeed is "+_tt.currentSpeed );
//			trace( "MAIN : checkEasterEggs() : StateModel.STATE_MAIN is "+StateModel.STATE_MAIN );
//			trace( "MAIN : checkEasterEggs() : _stateModel.state is "+_stateModel.state );
//			var id : uint = contentModel.getContentItemByName(id)

			if(id == SiteConstants.EGG_KONAMI)
			{
				contentModel.hotspotName = id;
				dto = contentModel.getContentItemByName(id) as ContentDTO;
				contentModel.addUnlockedEgg(dto.id);

				TrackingManager.gi.trackCustom(TrackingConstants.BONUS_UNLOCKED_DANCE_OFF );

				// TODO - NEED TO ACTUALLY TRIGGER EASTER EGG CONTENT
				_stateModel.state = StateModel.STATE_DANCE_OFF;

			}
//			else if(id == SiteConstants.EGG_VO
//					&& _tt.currentSpeed == TimeTracker.SPEED_SLOW 
//					&& _stateModel.state == StateModel.STATE_MAIN)
//			{
//				// TODO - REACTIVATE AFTER PRESENTATION
//				if(!_vo) _vo = new VoiceOver();
//				_vo.startVo();
//				dto = contentModel.getContentItemByName(id) as ContentDTO;
////				contentModel.addUnlockedEgg(dto.id);
//			}
		}		

		protected function onLowerNavComplete( e : Event ) : void 
		{
			lowerNavBar.removeEventListener( Event.COMPLETE, onLowerNavComplete );
			Shell.getInstance().jsBridge().revealShareFooter();
		}
		
		
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get stateModel( ) : StateModel
		{
			return _stateModel;
		}
		 
		public function get state( ) : String
		{
			return _stateModel.state;
		} 
		 
		public function get currentView( ) : AbstractView
		{
			return _currentView;
		}
		
		public static function getClass( obj : Object ) : Class 
		{
			return Class( getDefinitionByName( getQualifiedClassName( obj ) ) );
		}
		
	}
}
