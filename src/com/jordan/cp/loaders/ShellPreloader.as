package com.jordan.cp.loaders {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.jasontighe.containers.events.ContainerEvent;
	import com.jordan.cp.assets.Logo;
	import com.jordan.cp.model.dto.ConfigDTO;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;

	/**
	 * @author jason.tighe
	 */
	public class ShellPreloader 
	extends AbstractPreloader 
	{
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		protected static const PRIMARY_LOGO				: String = "logo";
		protected static const ASSETS					: String = "assets";
		protected static const GLOW_COLOR				: uint = 0xFFFFBE;
		protected static const GLOW_ALPHA_AMOUNT		: Number = .55;
		protected static const GLOW_BLUR_AMOUNT			: uint = 6;
		protected static const LOGO_BG_COLOR			: uint = 0x131313;
		protected static const LOGO_GLOW_COLOR			: uint = 0xFFFFFF;
		protected static const GUTTER_COLOR				: uint = 0x131313;
		protected static const BAR_COLOR				: uint = 0x232323;
		protected static const BARPRELODAER_WIDTH		: uint = 220;
		protected static const BARPRELODAER_HEIGHT		: uint = 2;
		protected static const BARPRELODAER_PADDING		: uint = 25;
		//----------------------------------------------------------------------------
		// private variables
		//----------------------------------------------------------------------------
		private var _primary							: Array = new Array();
		private var _logoURL							: String;
		private var _assetsURL							: String;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var _logo								: MovieClip;
		public var _glow								: MovieClip;
		public var _barPreloader						: BarPreloader;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function ShellPreloader() 
		{
			trace( "SHELLPRELOADER : Constr" );
			super();
			init();
		}
		
		public override function init() : void
		{
//			trace( "SHELLPRELOADER : init()" );
			hide();
			
			_logoURL = getConfigUrl( PRIMARY_LOGO ) as String;
			_assetsURL = getConfigUrl( ASSETS ) as String;
//			trace( "SHELLPRELOADER : init() : _logoURL is "+_logoURL );
//			trace( "SHELLPRELOADER : init() : _assetsURL is "+_assetsURL );
		}
		
		override public function transitionIn() : void
		{
			show( .5 );
			_barPreloader.transitionIn();
		}
		
		override public function transitionOut() : void
		{
			TweenLite.to( this, 1, { alpha: 0, onComplete: transitionOutComplete } );
			_barPreloader.transitionOut();
		}
		
		public function loadLogo( ) : void
		{
//			trace( "SHELLPRELOADER : loadLogo() : _logoURL is "+_logoURL );
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLogoLoaded );
			loader.load( new URLRequest( _logoURL ) );
		} 
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addViews( ) : void
		{
//			trace( "SHELLPRELOADER : addViews()" );
			_logo = new MovieClip();
			_glow = new MovieClip();
			addChild( _logo );
			addChild( _glow );
			
			var logo : Logo = new Logo();
			var logoBitmap : Bitmap = getBitmap( logo.width, logo.height, logo );
			var glowBitmap : Bitmap = getBitmap( logo.width, logo.height, logo );
			
			TweenMax.to( logoBitmap, 0, {tint: LOGO_BG_COLOR } );
			TweenMax.to( glowBitmap, 0, {tint: LOGO_GLOW_COLOR } );
			
			var glowFilter : GlowFilter = getGlowFilter();
			_glow.filters = [glowFilter];
			
			_logo.addChild( logoBitmap );
			_glow.addChild( glowBitmap );
			
			_glow.alpha = 0;
//			_glow.x = _glow.y = 200;
			
//			show();
		}
		
		protected function addBarPreloader() : void
		{
//			trace( "SHELLPRELOADER : addBarPreloader()" );
			_barPreloader = new BarPreloader();
//			SINCE WE'RE USING A THROTTLED SHOWPERCENT TO UPDATE THE BAR, THERES NO NEED TO THROTTLE IT AGAIN
			_barPreloader.isThrottled = false;
			_barPreloader.setWidth( _logo.width );
			_barPreloader.setHeight( BARPRELODAER_HEIGHT );
			_barPreloader.gutterColor = GUTTER_COLOR;
			_barPreloader.barColor = BAR_COLOR;
			_barPreloader.init();
			_barPreloader.x = _logo.x;
			_barPreloader.y = _logo.y + _logo.height + BARPRELODAER_PADDING;
			addChild(_barPreloader );
		}
		
		override protected function updateDisplay() : void
		{
			_barPreloader.update( _showPercent );
			
			var curAlpha : Number;
			
			if( _showPercent < 1 )
			{
				_glow.alpha = _showPercent;
			}
		}
		
		override protected function doLoadComplete() : void
		{
//            trace( "SHELLPRELOADER : doLoadComplete()" );
			_glow.alpha = 1;
			_barPreloader.update( _showPercent );
			
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
			reset();
		}
		
		protected override function transitionOutComplete() : void
		{
			dispatchEvent( new ContainerEvent( ContainerEvent.HIDE)) ;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onLogoLoaded( e : Event ) : void
		{
//			trace( "SHELLPRELOADER : onLogoLoaded() " );
//			addChild( _logoLoader );
			addViews();
//			tintTexts();
			addBarPreloader();
			
			dispatchEvent( new Event( Event.COMPLETE ) ) ;
		}
	
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set primary( value : Array ) : void
		{
//			trace( "SHELLPRELOADER : set primary() is "+value );
			_primary = value;
		}
		
		public function get logoURL( ) : String
		{
			return _logoURL;
		}
		
		public function get assetsURL( ) : String
		{
			return _assetsURL;
		}
		
		protected function getConfigUrl( name : String ) : String
		{
			var url : String;
			var i : uint = 0;
			var I : uint = _primary.length;
			for( i; i < I; i++ )
			{
				var dto : ConfigDTO = _primary[ i ] as ConfigDTO;
				if ( name == dto.name ) url = dto.url;
			}
			
			return url;
		}
		
		protected function getBitmap( w : Number, h : Number, mc : MovieClip ) : Bitmap
		{
			var bitmapData : BitmapData = new BitmapData ( w, h, true, 0);
			bitmapData.draw ( mc );
			var bitmap : Bitmap = new Bitmap ( bitmapData );
			bitmap.smoothing = true;
			return bitmap;
		}
		
		protected function getGlowFilter() : GlowFilter
		{
			var glowFilter : GlowFilter = new GlowFilter(); 
			glowFilter.color = GLOW_COLOR; 
			glowFilter.alpha = GLOW_ALPHA_AMOUNT;
			glowFilter.blurX = GLOW_BLUR_AMOUNT; 
			glowFilter.blurY = GLOW_BLUR_AMOUNT; 
			glowFilter.strength = 3;
			glowFilter.quality = 3;
			glowFilter.inner = false; 
			glowFilter.knockout = false; 
			return glowFilter;
		}
	}
}
