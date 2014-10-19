package com.jordan.cp 
{
	import com.greensock.plugins.BlurFilterPlugin;	
	import com.greensock.plugins.GlowFilterPlugin;	
	
	import deng.fzip.FZip;

	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.OverwriteManager;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.jasontighe.common.SimpleCookieManager;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jasontighe.loaders.QueueLoadItem;
	import com.jasontighe.loaders.QueueLoader;
	import com.jasontighe.loaders.events.QueueLoadItemEvent;
	import com.jasontighe.util.BandwidthTester;
	import com.jasontighe.util.Box;
	import com.jasontighe.util.JSBridge;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.loaders.LoaderDebug;
	import com.jordan.cp.managers.BandwidthManager;
	import com.jordan.cp.managers.ConnectionErrorManager;
	import com.jordan.cp.managers.StateManager;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.CameraPannerModel;
	import com.jordan.cp.model.ConfigModel;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.HotspotModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.VideoModel;
	import com.jordan.cp.model.dto.ConfigDTO;
	import com.jordan.cp.view.Main;
	import com.jordan.cp.view.error.ConnectionErrorOverlay;
	import com.jordan.cp.view.events.ViewEvent;
	import com.jordan.cp.view.interactionmap.MediaConnector;
	import com.jordan.cp.view.landing.Landing;
	import com.jordan.cp.view.welcome.Welcome;
	import com.plode.framework.managers.AssetManager;
	import com.plode.framework.managers.FontManager;
	import com.plode.framework.managers.PlodeStyleManager;
	import com.plode.framework.managers.sound.PlodeSoundManager;
	import com.plode.framework.utils.RightClickVersion;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;

	/**
	 * @author jason.tighe
	 */


	public class Shell 
	extends MovieClip 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//---------------------------------------------------------------------------- 
		protected static var _instance						: Shell;
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		private static const VERSION						: String = "Jordan CP Player : version 1.0.0";
		private static const CONFIG_URL						: String = "flash/xml/config.xml";
		private static const CONTENT_URL					: String = "flash/xml/content.xml";
		private static const HOTSPOT_URL					: String = "flash/xml/hotspots.xml";
		private static const WELCOME_URL					: String = "flash/swf/Welcome.swf";
		private static const ASSETS_URL						: String = "flash/swf/Assets.swf";
		private static const FONTS_US_URL					: String = "flash/swf/FontsUS.swf";
		private static const FONTS_CH_URL					: String = "flash/swf/FontsCH.swf";
		private static const COOKIE_URL						: String = "flash/swf/SharedObjectGateway.swf";
		private static const STYLES_URL						: String = "flash/css/jordan_flash_styles.css";
		private static const SOUNDS_URL						: String = "flash/swf/cp_soundAssets.swf";
		private static const BACKGROUND_COLOR				: uint = 0x070707;
		private static const PRELOADER_PAUSE				: uint = 1000;
		private static const FAKE_BANDWIDTH					: uint = 1000;
		private static const COOKIE_MILISECONDS				: uint = 180000;
		//----------------------------------------------------------------------------
		// public static constants
		//----------------------------------------------------------------------------
		public static const COOKIE_INSTRUCTIONS_VIEWED		: String = "jordanCPInstructionsViewed";
		public static const COOKIE_UNLOCKED_SCENES			: String = "jordanCPUnlockedScenes";
		public static const COOKIE_UNLOCKED_CONTENT			: String = "jordanCPUnlockedContent";
		public static const COOKIE_UNLOCKED_EGGS			: String = "jordanCPUnlockedEggs";
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		private var _holder 								: Sprite;
		protected var _stageW								: uint;
		protected var _stageH								: uint;
		protected var _navHOffset							: uint = 0;
		protected var _flashvars							: Object;
		protected var _configXML							: XML;
		protected var _configModel							: ConfigModel;
		protected var _contentModel							: ContentModel;
		protected var _hotspotModel 						: HotspotModel;
		protected var _videoModel							: VideoModel;
		protected var _jsBridge								: JSBridge;
		protected var _zipArray								: Array = new Array();
		protected var _stateManager							: StateManager;
		protected var _bandwidthManager						: BandwidthManager = BandwidthManager.gi;
		protected var _assetManager							: AssetManager;
		protected var _soundManager							: PlodeSoundManager = PlodeSoundManager.gi;
		protected var _trackingManager						: TrackingManager;
		protected var _simpleCookie							: SimpleCookieManager;
		protected var _fontManager							: FontManager;
		protected var _welcome								: Welcome;
		protected var _queueLoader							: QueueLoader;
		protected var _zipLoader							: QueueLoader;
		protected var _mediaConnector						: MediaConnector;
		protected var _bandwidthTester						: BandwidthTester;
		protected var _serviceConnected						: Boolean = false;
		protected var _zipsLoaded							: Boolean = false;
		protected var _welcomeLoaded						: Boolean = false;
		protected var _queueLoaded							: Boolean = false;
		protected var _bandwidthChosen						: Boolean = false;
		protected var _siteCached							: Boolean = false;
		protected var _instructionsViewed					: Boolean = false;
		protected var _unlockedContent						: Array = new Array();
		protected var _unlockedScene						: Array = new Array();
		protected var _unlockedEggs							: Array = new Array();
		protected var _cookieId								: Object = 0;
		protected var _cookieMS								: uint = 0;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var background								: Box;
//		public var preloader								: ShellPreloader;
		public var main										: Main;
		public var errorOverlay								: ConnectionErrorOverlay;

		public var loaderDebug								: LoaderDebug;
//		public static const BANDWIDTH_CHANGED 				: String = "BANDWIDTH_CHANGED";

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Shell() 
		{
			trace("\n\n\n\n");
			trace("****************************************");
			trace("*                                      *");
			trace("*           Wieden+Kennedy             *");
			trace("*              New York                *");
			trace("*               © 2011                 *");
			trace("*                                      *");
			trace("****************************************");
			trace("****************************************");
			trace("****************************************");
//			trace( "SHELL : Constr" );

			
			if( _instance ) throw IllegalOperationError( "Only one instance of Shell can exist." );
			
			_instance = this;
			
			// CROSSDOMAIN SECURITY
			//in order to successfully connect to our policy
			Security.allowDomain("*");
//			Security.allowDomain("localhost"); 
			Security.loadPolicyFile("localhost/crossdomain.xml"); 
			Security.loadPolicyFile("http://cp.dev.nyc.wk.com/crossdomain.xml");
			Security.loadPolicyFile("http://plode.com/crossdomain.xml");
			// GET POLICY FILE FROM BRIGHTCOVE
			Security.loadPolicyFile("http://cp103290.edgefcs.net/ondemand/videos/crossdomain.xml");
			
			_flashvars = loaderInfo.parameters;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			buttonMode = false;
			mouseEnabled = false;
			useHandCursor = false;
			
			var rcv : RightClickVersion = new RightClickVersion(this, VERSION);

			// MONSTER DEBUGGER
            // Start the MonsterDebugger
            MonsterDebugger.initialize(this);
            MonsterDebugger.trace(this, "Hello World!");
 			MonsterDebugger.breakpoint(this);
 
			// TWEENMAX STUFF
			OverwriteManager.init();
			TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin, BlurFilterPlugin ] );
			
			addEventListener(Event.ADDED_TO_STAGE, init );
			stage.addEventListener( Event.RESIZE, onStageResize );
			stage.stageFocusRect = false;
		}		
		
//		public function setCookie()
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function init( e : Event = null ) : void	
		{
			trace( "SHELL : init()" );
			removeEventListener(Event.ADDED_TO_STAGE, init );
			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;
			
			_holder = new Sprite();
			addChild(_holder);
			
			addErrorOverlay();
			loadConfig();
			addJSBridge();
		} 

		private function addErrorOverlay() : void 
		{
			errorOverlay = new ConnectionErrorOverlay();
			errorOverlay.visible = false;
			addChild(errorOverlay);
		}

		protected function loadConfig( ) : void
		{
			trace( "SHELL : loadConfig()" );
			var loader : URLLoader = new URLLoader();
			var url : String = _flashvars.CONFIG || CONFIG_URL;
			loader.addEventListener( Event.COMPLETE, onConfigLoaded );
			loader.load( new URLRequest( url ) );
		}
		
		protected function addJSBridge( ) : void
		{
			trace( "SHELL : addJSBridge()" );
			_jsBridge = new JSBridge();
		}
				
		protected function addBackground( ) : void
		{
			trace( "SHELL : addBackground()" );
			var color : uint = _configModel.bgColor || BACKGROUND_COLOR;
			background = new Box( _stageW, _stageH, color );
			_holder.addChild( background );
		}
		
		protected function startQueueLoader( ) : void
		{
			trace( "SHELL : startQueueLoader()" );
			_queueLoader = new QueueLoader();
			_bandwidthTester = new BandwidthTester();
			
			var cookieURL : String = _configModel.cookieURL || COOKIE_URL;
			var cookieLoadItem : QueueLoadItem = new QueueLoadItem( cookieURL, onCookieLoadComplete );
			_queueLoader.add( cookieLoadItem );
			
			// One swf contains both US fonts
			var fontsUSURL : String = _configModel.fontsUSURL || FONTS_US_URL;
			var fontsUSLoadItem : QueueLoadItem = new QueueLoadItem( fontsUSURL, onFontsLoadComplete );
			_queueLoader.add( fontsUSLoadItem );
			
			var stylesURL : String = _configModel.stylesURL || STYLES_URL;
			var stylesLoadItem : QueueLoadItem = new QueueLoadItem( stylesURL, onStylesLoadComplete );
			_queueLoader.add( stylesLoadItem );
			
			var contentURL : String = _configModel.contentURL || CONTENT_URL;
			var contentLoadItem : QueueLoadItem = new QueueLoadItem( contentURL, onContentLoadComplete );
			_queueLoader.add( contentLoadItem );
			
			var welcomeURL : String = _configModel.welcomeURL || WELCOME_URL;
			var welcomeLoadItem : QueueLoadItem = new QueueLoadItem( welcomeURL, onWelcomeLoadComplete );
			_queueLoader.add( welcomeLoadItem );
			
			var assetsURL : String = _configModel.assetsURL || ASSETS_URL;
			var assetsLoadItem : QueueLoadItem = new QueueLoadItem( assetsURL, onAssetsLoadComplete );
			_queueLoader.add( assetsLoadItem );
			
			var hotspotURL : String = _configModel.hotspotURL || HOTSPOT_URL;
			var hotspotLoadItem : QueueLoadItem = new QueueLoadItem( hotspotURL, onHotspotLoadComplete );
			_queueLoader.add( hotspotLoadItem );
			
			var soundURL : String = _configModel.soundURL || SOUNDS_URL;
			var soundLoadItem : QueueLoadItem = new QueueLoadItem( soundURL, onSoundLoadComplete );
			_queueLoader.add( soundLoadItem );
			
			// COPMMENTED OUT FOR TESTING
			var zipImages : Array = _configModel.zipImages;
			var j : uint = 0;
			var J : uint = zipImages.length;
			for( j; j < J; j++ )
			{
				var zipDTO : ConfigDTO = zipImages[ j ];
				var zipURL : String = zipDTO.url;
				var zipLoadItem : QueueLoadItem = new QueueLoadItem( zipURL, onZipLoadComplete );
				zipLoadItem.setId( j );
				_queueLoader.add( zipLoadItem);
			}
			
			_queueLoader.setLoadProgressEventHandler( onQueueLoaderProgress );
			_queueLoader.setLoadCompleteEventHandler( onQueueLoaderComplete );
			_queueLoader.load();

//            _bandwidthTester.addEventListener( BandwidthTester.BAND_TESTED, onBandwidthTested );
////            _bandwidthTester.addEventListener( BandwidthTester.TEST, bandwidthTest );
//			_bandwidthTester.start();
			
//			var to : Number = setTimeout( showProgress, 1000 );
		}

		protected function addConfigModel( xml : XML ) : void
		{
			trace( "SHELL : addConfigModel()" );
			_configModel = ConfigModel.gi;
			_configModel.addData( xml );
//			_configModel = new ConfigModel( xml );
		}
		
		protected function addContentModel( xml : XML ) : void
		{
			trace( "SHELL : addConfigModel()" );
			_contentModel = ContentModel.gi;
			_contentModel.addData( xml );
			
			// ADD COOKIED ARRAYS FOR UNLOCKED BONUS CONTENT
			if( _unlockedScene.length > 0 )		_contentModel.unlockedScene = _unlockedScene;
			if( _unlockedContent.length > 0 )	_contentModel.unlockedContent = _unlockedContent;
			if( _unlockedEggs.length > 0 )		_contentModel.unlockedEggs = _unlockedEggs;
		}
		
		protected function addHotspotModel( xml : XML ) : void
		{
			trace( "SHELL : addHotspotModel()" );
			_hotspotModel = HotspotModel.gi;
			_hotspotModel.xml = xml;
		}
		
		protected function addManagers( ) : void
		{
//			trace( "SHELL : addManagers()" );
			_assetManager = AssetManager.gi;
			
//			_bandwidthManager = new BandwidthManager();
//			_bandwidthManager.setBandwidth( FAKE_BANDWIDTH );
//			_bandwidthManager.addEventListener(Event.COMPLETE, onBandwidthChanged);
			
			_trackingManager = TrackingManager.gi;
			_trackingManager.trackPage( TrackingConstants.HOME_LOADED );
		}		

//		private function onBandwidthChanged(event : Event) : void 
//		{
//			// TODO - NOTIFY TIMETRACKER OF BANDWIDTH CHANGE
//			dispatchEvent(new Event(BANDWIDTH_CHANGED));
//		}

		protected function checkForCookies( ) : void
		{
			trace( "\n" );
			trace( "SHELL : checkForCookies()" );
			
			var cookieInstructionsViewed : Object = _simpleCookie.getCookie( COOKIE_INSTRUCTIONS_VIEWED );
			_instructionsViewed = cookieInstructionsViewed as Boolean
			trace( "SHELL : checkForCookies() : cookieInstructionsViewed is "+cookieInstructionsViewed );
//			trace( "SHELL : checkForCookies() : _instructionsViewed is "+_instructionsViewed );
			
			var cookieUnlockedScenes : Object = _simpleCookie.getCookie( COOKIE_UNLOCKED_SCENES );
			if( cookieUnlockedScenes != null )	_unlockedScene = cookieUnlockedScenes as Array;
			trace( "SHELL : checkForCookies() : cookieUnlockedScenes is "+cookieUnlockedScenes );
//			trace( "SHELL : checkForCookies() : _unlockedScene.length is "+_unlockedScene.length );
			
			var cookieUnlockedContent : Object = _simpleCookie.getCookie( COOKIE_UNLOCKED_CONTENT );
			if( cookieUnlockedContent != null )	_unlockedContent = cookieUnlockedContent as Array;
			trace( "SHELL : checkForCookies() : cookieUnlockedContent is "+cookieUnlockedContent );
//			trace( "SHELL : checkForCookies() : _unlockedContent.length is "+_unlockedContent.length );
			
			var cookieUnlockedEggs : Object = _simpleCookie.getCookie( COOKIE_UNLOCKED_EGGS );
			if( cookieUnlockedEggs != null )	_unlockedEggs = cookieUnlockedEggs as Array;
			trace( "SHELL : checkForCookies() : cookieUnlockedEggs is "+cookieUnlockedEggs );
//			trace( "SHELL : checkForCookies() : _unlockedEggs.length is "+_unlockedEggs.length );
		}
		
		public function setCookie( name : String, obj : Object ) : void
		{
			trace( "SHELL : setCookie() : name is "+name );
			trace( "SHELL : setCookie() : obj is "+obj );
			trace( "SHELL : setCookie() : _cookieMS is "+_cookieMS );
			_simpleCookie.setCookie( name, obj, _cookieMS );
		}

		protected function addFontManager( fontSwf : MovieClip) : void
		{
			trace("SHELL : addFontManager()" );
//			_fontManager = new FontManager();
//			_fontManager.init();
			
			// ALTERNATE FONT MANAGER! TIED TO PLODE TEXTCONTAINER
			_fontManager = FontManager.gi;
			_fontManager.add('global', fontSwf);
		}
		
		protected function addViews( e : ContainerEvent = null ) : void
		{
			trace( "SHELL : addViews()" );
//			preloader.removeEventListener( ContainerEvent.HIDE, addViews );
			main = new Main();
			main.init();
			_holder.addChild( main );
			
			main.stateModel.state = StateModel.STATE_LANDING;
		}

		protected function updateBackground( ) : void
		{
			background.width = _stageW;
			background.height = _stageH;
		}

		protected function updateMain( ) : void
		{
			main.updateViews(stageW, stageH);
		}

		protected function addLoaderDebug( ) : void
		{
			loaderDebug = new LoaderDebug();
			_holder.addChild( loaderDebug );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onStageResize( e : Event = null ) : void
		{
//			trace( "SHELL : onStageResize()" );
			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;
			
			if( background && contains( background ) )	updateBackground();
//			if( preloader && contains( preloader ) )	centerPreloader();
			if( main && contains( main ) )	updateMain();
			if(errorOverlay) errorOverlay.resize();
		}
		
		protected function onConfigLoaded( e : Event ) : void
		{
			trace( "SHELL : onConfigLoaded() : CONFIG XML LOADED" );
			var xml : XML = XML( e.target.data );
			addConfigModel( xml );
			
//			addShellPreloader();
			_cookieMS = _configModel.cookieMS;
			addBackground();
			connectToService();
			addManagers();
			startQueueLoader();
//			startZipLoader();

			

		}
		
		protected function connectToService() : void 
		{
			trace( "SHELL : connectToService()" );
			//
			// ADD MEDIA CONNECTOR
			//
			_mediaConnector = new MediaConnector();
			_mediaConnector.addEventListener(MediaConnector.CONNECTION_ESTABLISHED, onServiceConnected );
			_mediaConnector.authenticate();
		}
		
		protected function onServiceConnected( e : Event ) : void 
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace( "SHELL : onServiceConnected() : SERVICE IS CONNECTED" );
			_mediaConnector.removeEventListener(MediaConnector.CONNECTION_ESTABLISHED, onServiceConnected );
			_videoModel = _mediaConnector.videoModel;
			_serviceConnected = true;
			
//			checkForQueueLoader();
			
			// IF WELCOME VIEW HAS LOADED PRIOR TO SERVICE CONNECTION
			if( main && main.state == StateModel.STATE_LANDING )
			{
				trace("Shell.onServiceConnected(e) : WELCOME ALREADY EXISTS - START BG VID LOOP");
				var landing : Landing = Landing( main.currentView );
				landing.nc = _videoModel.nc;
				var url : String = _videoModel.getLandingUrl();	
				landing.playVideo( url ); 	
			}
//			checkAssetsLoaded();
			trace('----------------------------------------------------------\n\n\n\n\n\n');
		}
		
		protected function stopLoaderDebug() : void
		{
			trace( "SHELL : stopLoaderDebug()" );
			loaderDebug.stopTimer();
			loaderDebug.addEventListener( Event.COMPLETE, onLoaderDebugOut );
//			loaderDebug.buttonMode = true;
//			loaderDebug.useHandCursor = true;
//			loaderDebug.mouseEnabled = true;
//			loaderDebug.mouseChildren = false;
		}
		
		protected function onQueueLoaderProgress( e : Event ) : void
		{
//			trace( "SHELL : onQueueLoaderProgress()" );
//			var bl : Number = _queueLoader._bytesLoaded;
//			var bl : Number = _queueLoader._bytesTotal;
			var percent : Number = _queueLoader.percentLoaded;
//			trace( "SHELL : onQueueLoaderProgress() : percent is "+percent );
			if( _bandwidthChosen )	_welcome.updatePercent( percent );
//			This is at Preloader Complete now sucka!
		}
		
		protected function onQueueLoaderComplete( e : Event ) : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace( "SHELL : onQueueLoaderComplete() :  **** QUEUE LOADING IS COMPLETED" );
//			This is at Preloader Complete now sucka!
			_queueLoaded = true;
//			main.stateModel.state = StateModel.STATE_MAIN;
			trace( "SHELL : onQueueLoaderComplete() : _bandwidthChosen is "+_bandwidthChosen );
			trace( "SHELL : onQueueLoaderComplete() : main.state is "+main.state );
			trace('----------------------------------------------------------\n\n\n\n\n\n');
			if( !_bandwidthChosen && main.state == StateModel.STATE_LANDING )
			{	
				var landing : Landing = Landing( main.currentView );
				landing.addEventListener( ViewEvent.BANDWIDTH_SELECTED, onBandwidthSelected ); 	
			}
//			else
//			{
////				showMain();
//			}

			CameraPannerModel.gi.addZips( _zipArray );
			_welcome.showComplete();
		}
		
		protected function onBandwidthSelected( e : ViewEvent = null ) : void
		{
			trace( "SHELL : onBandwidthSelected() : e.target is "+e.target );
			var landing : Landing = e.target as Landing;
			landing.removeEventListener( ViewEvent.BANDWIDTH_SELECTED, onBandwidthSelected ); 
		}
		
		protected function onCookieLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace( "SHELL : onCookieLoadComplete() :  **** COOKIE MANAGER LOADED" );
			trace( "SHELL : onCookieLoadComplete() :  e.loadItem.content is "+e.loadItem.content );
			_simpleCookie = SimpleCookieManager( e.loadItem.content ) as SimpleCookieManager;
			checkForCookies();	
		}
		
		protected function onContentLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace( "SHELL : onContentLoadComplete() :  **** CONTENT XML LOADED" );
			addContentModel( XML( e.loadItem ) );
		}
		
		protected function onHotspotLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace( "SHELL : onContentLoadComplete() :  **** CONTENT XML LOADED" );
			addHotspotModel( XML( e.loadItem ) );
		}
		
		protected function onFontsLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace( "SHELL : onFontsLoadComplete() :     **** US FONTS LOADED");
			addFontManager(e.loadItem.content);
		}
		
		protected function onWelcomeLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace('\n\n\n\n\n\n----------------------------------------------------------');
			trace( "SHELL : onWelcomeLoadComplete() :  **** WELCOME SWF LOADED" );

			_welcome = Welcome( e.loadItem.content );
			_welcome.addEventListener(ViewEvent.START_EXPLORING, onStartExploring);
			_assetManager.add( SiteConstants.WELCOME_ID, MovieClip(e.loadItem.content));
			
			addViews();
			_welcomeLoaded = true;
//			checkForQueueLoader();


			// IF WELCOME VIEW HAS LOADED AFTER TO SERVICE CONNECTION
			if(_videoModel)
			{
				trace("Shell.onWelcomeLoadComplete(e) : SETUP LANDING BG VIDEO LOOP");
				
				var landing : Landing = Landing( main.currentView );
				landing.nc = _videoModel.nc;
				var url : String = _videoModel.getLandingUrl();	
				landing.playVideo( url ); 	
			}
			trace('----------------------------------------------------------\n\n\n\n\n\n');
		}

		private function onStartExploring(event : ViewEvent) : void 
		{
			_welcome.removeEventListener(ViewEvent.START_EXPLORING, onStartExploring);
			
			// TELL LANDING TO ADVANCE BG VIDEO LOOP AND CHANGE STATE
			var landing : Landing = Landing( main.currentView );
			landing.killLoop();
		}

		protected function onAssetsLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace( "SHELL : onAssetsLoadComplete() :   **** ASSETS SWF LOADED" );
			var assets : MovieClip = MovieClip( e.loadItem.content );
			_assetManager.add( SiteConstants.ASSETS_ID, assets );
		}
		
		protected function onZipLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace( "SHELL : onZipLoadComplete() :      **** IMAGE ZIP LOADED");
			var zip : FZip = e.loadItem as FZip;
			_zipArray.push( zip );
		}
		
		protected function onStylesLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace("SHELL : onStylesLoadComplete(e) :      **** CSS LOADED");
			PlodeStyleManager.gi.parse(e.loadItem);
		}
		
		protected function onSoundLoadComplete( e : QueueLoadItemEvent ) : void
		{
			trace("SHELL : onSoundLoadComplete :		**** SOUND LOADED");
			var soundSwf : MovieClip = MovieClip( e.loadItem.content );
			_soundManager.addSwf( soundSwf );
		}
		
		protected function onLoaderDebugOut( e : Event ) : void
		{
			trace( "SHELL : onLoaderDebugOut()");
			loaderDebug.removeEventListener( MouseEvent.CLICK, onLoaderDebugOut );
			removeChild( loaderDebug );
			loaderDebug = null;
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public static function getInstance( ) : Shell
		{
			return _instance;
		}
		
		public function getConfigModel( ) : ConfigModel
		{
			return _configModel;	
		}
		
		public function getContentModel( ) : ContentModel
		{
			return _contentModel;	
		}
		
		public function getVideoModel( ) : VideoModel
		{
			return _videoModel;	
		}
		
		public function get zipArray( ) : Array
		{
			return _zipArray;	
		}
		
		public function get masterStage() : Stage 
		{
			return stage;
		}
		
		public function get stageW( ) : uint
		{
			return _stageW;	
		}
		
		public function get stageH( ) : uint
		{
			return _stageH;	
		}
		
		public function jsBridge( ) : JSBridge
		{
			return _jsBridge;	
		}
		
		public function get fontManager( ) : FontManager
		{
			return _fontManager;	
		}
		
		public function get zipsLoaded( ) : Boolean
		{
			return _zipsLoaded;	
		}
		
		public function get instructionsViewed( ) : Boolean
		{
			return _instructionsViewed;	
		}
		
		public function get welcome() : Welcome 
		{
			return _welcome;
		}
		
		public function set bandwidthChosen( b : Boolean ) : void
		{
			_bandwidthChosen = b;
		}
	}
}
