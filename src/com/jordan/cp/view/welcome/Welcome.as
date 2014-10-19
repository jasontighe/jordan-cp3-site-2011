package com.jordan.cp.view.welcome 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.assets.Logo;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.managers.BandwidthManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.jordan.cp.view.events.ViewEvent;
	import com.jordan.cp.view.landing.BandwidthNavItem;
	import com.plode.framework.events.ParamEvent;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author jsuntai
	 */
	public class Welcome 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected constants
		//----------------------------------------------------------------------------
		protected const HIGH_BANDWIDTH					: String = "HIGH BANDWIDTH";
		protected const LOW_BANDWIDTH					: String = "LOW BANDWIDTH";
//		protected const BG_Y							: uint = 91;
//		protected const BG_HEIGHT						: uint = 245;
		protected const MARGIN							: uint = 10;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nav								: Nav;
		protected var _bandwidthManager					: BandwidthManager = BandwidthManager.gi;
		protected var displayArray						: Array = new Array();
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
//		public var preloader							: WelcomePreloader;
		public var preloader							: HelpPreloader;
		public var logo									: Logo;
		public var titleTxt								: AutoTextContainer;
		public var descTxt								: AutoTextContainer;
		public var chooseTxt							: AutoTextContainer;
		public var hr									: MovieClip;
		public var high									: BandwidthNavItem;
		public var low									: BandwidthNavItem;
		public var grid									: MovieClip;
		public var blackBg								: MovieClip;
		public var topHolder							: MovieClip;
		public var bottomHolder							: MovieClip;
		private var _gridMask 							: DisplayObject;

		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Welcome() 
		{
			trace( "WELCOME : Constr" );
			super();
		}
		
		public override function init() : void
		{
			trace( "WELCOME : init()" );
			visible = false;
			displayArray = [ logo, titleTxt, descTxt, hr, chooseTxt, high, low ];
//			displayArray = [ topHolder, hr, bottomHolder ];
			
			_gridMask = new Box( blackBg.width, blackBg.height );
			addChild( _gridMask );
			grid.mask = _gridMask;

			preloader = new HelpPreloader();
			preloader.x = blackBg.width/2;
			preloader.y = blackBg.height/2;
			preloader.hide();
			preloader.addEventListener(HelpPreloader.RESIZE_BG, onResizeBg);
			preloader.addEventListener( ViewEvent.START_EXPLORING, onStartExploring );
			addChild(preloader);
			
			addHolders();
			addCopy();
			addNav();
		}

		public function transitionIn() : void
		{
			trace( "WELCOME : transitionIn()" );
			visible = true;
			var time : Number = SiteConstants.NAV_TIME_IN;
			var delay : Number = time;
//			var offset : Number = time * .5;
			
			TweenLite.from( grid, time, { alpha: 0, ease: Quad.easeOut } );
			TweenLite.from( blackBg, time, { alpha: 0, delay: delay, ease: Quad.easeOut } );
			
			delay += time;
			TweenLite.from( topHolder, time, { alpha: 0, delay: delay, ease: Quad.easeOut } );
			
			delay += time;
			var hrX : int = Math.round( ( hr.x + hr.width) * .5 );
			TweenLite.from( hr, time, { x: hrX, width: 0, delay: delay, ease: Quad.easeOut } );
			
			delay += time;
			TweenLite.from( chooseTxt, time, { alpha: 0, delay: delay, ease: Quad.easeOut } );
			TweenLite.from( low, time, { alpha: 0, delay: delay, ease: Quad.easeOut } );
			TweenLite.from( high, time, { alpha: 0, delay: delay, ease: Quad.easeOut, onComplete: transitionInComplete } );
//			TweenLite.from( bottomHolder, time, { alpha: 0, delay: delay, ease: Quad.easeOut, onComplete: transitionInComplete } );
		}
				
		public function updatePercent( percent : Number ) : void
		{
//			trace( "WELCOME : updatePercent() : percent is "+percent );
			preloader.percent = percent;
		}
		
//		public function autoUpdate( ) : void
//		{
//			// THIS FIRES WHEN EVERYTHING IS ALREADY LOADED BY THE TIME PRELOADER ANIMATION IS TOLD TO PLAY?
//			trace( "WELCOME : autoUpdate()" );
//			var delay : Number = 1;
//			preloader.autoUpdate( delay );
//		}
		
//		public function activate() : void
//		{
//			_nav.enable();
//		}
//		
//		public function deactivate() : void
//		{
//			_nav.disable();
//		}
		
		public function showComplete() : void 
		{
			if(!preloader.complete) preloader.complete = true;
		}


		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addHolders() : void
		{
			// ADD VIEWS TO SEPARATE HOLDERS FOR TRANSITIONS
			trace( "WELCOME : addHolders()" );
			topHolder = new MovieClip();
			addChild( topHolder );
			topHolder.addChild( logo );
			
			bottomHolder = new MovieClip();
			addChild( bottomHolder );
			bottomHolder.addChild( high );
			bottomHolder.addChild( low );
		}
		
		protected function addCopy() : void
		{
			trace( "WELCOME : addCopy()" );
			var welcomeId : String = "welcome-title"
			var titleWidth : uint = blackBg.width - ( 2 * MARGIN );
			var titleDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( welcomeId ) as CopyDTO;
			titleTxt = new AutoTextContainer( );
			titleTxt.setWidth( titleWidth );
			titleTxt.populate( titleDTO, welcomeId, true, true );
			topHolder.addChild( titleTxt );
			
			var descId : String = "welcome-desc"
			var descWidth : uint = blackBg.width - ( 2 * MARGIN );
			var descDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( descId ) as CopyDTO;
			descTxt = new AutoTextContainer( );
			descTxt.setWidth( descWidth );
			descTxt.populate( descDTO, descId, true, true );
			topHolder.addChild( descTxt );
			
			var chooseId : String = "welcome-choose"
			var chooseWidth : uint = blackBg.width - ( 2 * MARGIN );
			var chooseDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( chooseId ) as CopyDTO;
			chooseTxt = new AutoTextContainer( );
			chooseTxt.setWidth( chooseWidth );
			chooseTxt.populate( chooseDTO, chooseId, true, true );
			bottomHolder.addChild( chooseTxt );
		}
		
		protected function addNav() : void
		{
			trace( "WELCOME : addNav()" );
			var navItems : Array = new Array( high, low );
			var navTextArray : Array = new Array( HIGH_BANDWIDTH, LOW_BANDWIDTH );
			_nav = new Nav();
			var item : BandwidthNavItem;
			var last : BandwidthNavItem;
			var i : uint = 0;
			var I : uint = navItems.length;
			var lastItem : uint = I - 1;
			
			for( i; i < I; i++ )
			{
				item = navItems[ i ];
				item.setIndex( i );
				item.init();
				item.setOutState();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
//				item.setOutState(); 
				var text : String =  navTextArray[ i ];
				item.copyTxt.tf.htmlText = text;
				
				_nav.add( item );
				_nav.addChild( item );
			}
			
			_nav.disable();			
//			_nav.enable();

			_nav.init();
			addChild( _nav );
		}
		
		protected function transitionInComplete() : void
		{
			trace( "WELCOME : transitionInComplete()" );
			activate();
		}
		
		protected function activate() : void
		{
			trace( "WELCOME : activate()" );
			_nav.enable();
		}
		
		protected function setBandwidth( n : uint ) : void
		{
			if( n == 0 )
			{
				_bandwidthManager.speed = BandwidthManager.HIGH;
			}
			else
			{
				_bandwidthManager.speed = BandwidthManager.LOW;
			}
		}
		
		protected function showPreloader() : void
		{
			trace( "WELCOME : showPreloader()" );
			var time : Number = SiteConstants.NAV_TIME_OUT;
//			var bgTime : Number = time * 2;
			
//			var i : uint = 0;
//			var I : uint = displayArray.length;
//			for( i; i < I; i++ )
//			{
////				trace( "WELCOME : showPreloader() : i is "+i );
//				var object : * = displayArray[ i ];
//				TweenLite.to( object, time, { alpha: 0, ease: Quad.easeOut } );
//			}

			TweenLite.to( topHolder, time, { alpha: 0, ease: Quad.easeOut } );
//			TweenLite.to( titleTxt, time, { alpha: 0, ease: Quad.easeOut } );
//			TweenLite.to( descTxt, time, { alpha: 0, ease: Quad.easeOut } );
			TweenLite.to( hr, time, { alpha: 0, ease: Quad.easeOut } );
//			TweenLite.to( bottomHolder, time, { alpha: 0, ease: Quad.easeOut } );
			TweenLite.to( chooseTxt, time, { alpha: 0, ease: Quad.easeOut } );
			TweenLite.to( low, time, { alpha: 0, ease: Quad.easeOut } );
			TweenLite.to( high, time, { alpha: 0, ease: Quad.easeOut, onComplete: onWelcomeOut } );

			
//			preloader.isThrottled = true;
//preloader.isThrottled = false;


			preloader.show( time, time );
			
			
//			var gridMask : Box = new Box( blackBg.width, blackBg.height );
//			addChild( gridMask );
//			grid.mask = gridMask;
//			
//			TweenMax.to( gridMask, bgTime, { y: BG_Y, height: BG_HEIGHT, ease:Quad.easeOut, onComplete: onShowPreloaderComplete } );
//			TweenMax.to( blackBg, bgTime, { y: BG_Y, height: BG_HEIGHT, ease:Quad.easeOut } );
		}
		
		private function onResizeBg(event : ParamEvent) : void 
		{
			resizeBg(event.params.tarY, event.params.tarH);
		}

		public function resizeBg(tarY : Number, tarH : Number) : void
		{
			var bgTime : Number = SiteConstants.NAV_TIME_OUT * 2;

			TweenMax.to( _gridMask, bgTime, { x: HelpPreloader.BG_X, y: tarY, height: tarH, width: HelpPreloader.BG_W, ease:Quad.easeOut });
			TweenMax.to( grid, bgTime, { x: HelpPreloader.BG_X, y: tarY, ease:Quad.easeOut });
			TweenMax.to( blackBg, bgTime, { x: HelpPreloader.BG_X, y: tarY, height: tarH, width: HelpPreloader.BG_W, ease:Quad.easeOut });
		}

		//		protected function onShowPreloaderComplete() : void
//		{
//			preloader.transitionIn();
//		}
		
		protected function dispatchCompleteEvent( ) : void
		{
//			trace( "BANDWIDTHWINDOW : dispatchCompleteEvent()" );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onWelcomeOut( ) : void
		{
			trace( "WELCOME : onWelcomeOut()" );
			removeChild( topHolder );
			removeChild( hr );
			removeChild( bottomHolder );
//			removeChild( high );
//			removeChild( low );
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : BandwidthNavItem = e.target as BandwidthNavItem;
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : BandwidthNavItem = e.target as BandwidthNavItem;
			item.setOverState();
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			trace( "WELCOME : onNavItemClick()" );
			var item : BandwidthNavItem = e.target as BandwidthNavItem;
//			trace( "WELCOME : setActiveState() : item.getIndex() is "+item.getIndex() );
			var index : uint = item.getIndex()
			setBandwidth( index );
			_nav.setActiveItem( item );
//			item.setActiveState();	
			_nav.disable();	
			showPreloader();	
			var to : Number = setTimeout( dispatchCompleteEvent, 1000 );
		}
		
		protected function onStartExploring( e : ViewEvent ) : void
		{
			trace( "WELCOME : onStartExploring()" );
			
			// NOTIFIED BY CTA CLICK IN HELPPRELOADER
			preloader.removeEventListener( ViewEvent.START_EXPLORING, onStartExploring );

			// DISPATCHES TO SHELL
			dispatchEvent( new ViewEvent(ViewEvent.START_EXPLORING) ); 

			// HIDE BG
			var bgTime : Number = SiteConstants.NAV_TIME_OUT * 2;
			TweenLite.to( grid, bgTime, { alpha: 0, ease:Quad.easeOut } );
			TweenLite.to( blackBg, bgTime, { autoAlpha: 0, ease:Quad.easeOut } );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
//		public function set bandwidthManager( object : BandwidthManager ) : void
//		{
//			_bandwidthManager = object;
//		}

	}
}
