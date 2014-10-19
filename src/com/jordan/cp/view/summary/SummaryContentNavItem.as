package com.jordan.cp.view.summary {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.NavItem;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.plode.framework.containers.TextContainer;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class SummaryContentNavItem 
	extends NavItem 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var COPY_Y_SPACE				: uint = 7;
		protected static var ICON_WIDTH					: uint = 44;
		protected static var TITLE_Y_OFFSET				: int = -2;
		protected static var SCALE_OUT					: Number = .85;
		protected static var SCALE_OVER					: Number = 1.15;
		protected static var ICON_Y_OFFSET				: Number = -4;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		protected var _iconType							: String;
		protected var _isUnlocked						: Boolean = false;
//		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var titleTxt								: TextContainer;
		public var iconTxt								: TextContainer;
		public var border								: Box;
		public var keyboard								: MovieClip;
		public var shoe									: MovieClip;
		public var camera								: MovieClip;
		public var video								: MovieClip;
		public var message								: MovieClip;
		public var lock									: MovieClip;
		public var icon									: MovieClip;
		public var activeIcon							: MovieClip;
		public var background							: MovieClip;
		public var hitBox								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SummaryContentNavItem( ) 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public function addViews( ) : void
		{
			addIcon();
			addHitBox();
		}
		
		public function addCopy( dto : ContentDTO ) : void
		{
//			trace( "SUMMARYCONTENTNAVITEM : addCopy()");
			var dto : ContentDTO = dto;
			
			var icon : String = dto.category;
			iconTxt = new TextContainer();
			iconTxt.populate( icon.toUpperCase(), 'summary-active-title');
            iconTxt.x = ( ICON_WIDTH - iconTxt.width ) * .5;
            iconTxt.y = ICON_WIDTH + COPY_Y_SPACE;
			addChild( iconTxt );
			
			var shortTitle : String = dto.shortTitle;
			titleTxt = new TextContainer();
			titleTxt.populate( shortTitle.toUpperCase(), 'summary-active-type');
            titleTxt.x = ( ICON_WIDTH - titleTxt.width ) * .5;
            titleTxt.y = iconTxt.y + iconTxt.height + TITLE_Y_OFFSET;
			addChild( titleTxt );
			
			
		}

		public override function setOverState ( active : int = -1 ) : void
		{
			doOverState()
		}

		public override function setOutState () : void
		{
			doOutState()
		}

		public override function setActiveState ( active : int = -1 ) : void
		{
			doClickState();
		}

		public override function setInactiveState () : void
		{
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addIcon() : void
		{
//			trace( "\n\n");
//			trace( "SUMMARYCONTENTNAVITEM : addIcon() : _iconType is "+_iconType);
			
			icon = MovieClip( AssetManager.gi.getAsset( "SummaryContentIconAsset", SiteConstants.ASSETS_ID ) );
			addChild( icon );
			
			
			video = icon.video;
		 	message = icon.message;
			lock = icon.lock;
			keyboard = icon.keyboard;
			shoe = icon.shoe;
			camera = icon.camera;
			background = icon.background;
			
			setType();
		}
		
		
		protected function setType( ) : void
		{
//			trace( "SUMMARYCONTENTNAVITEM : setType() : _iconType is "+_iconType);
			var iconArray : Array = new Array( video, message, lock, keyboard, camera, shoe ) ;
			var i : uint = 0;
			var I : uint = iconArray.length;
			for( i; i < I; i++ )
			{
				var mc : MovieClip = iconArray[ i ];
				var name : String = mc.name as String;
				if( _iconType != name )
				{
					mc.visible = false;
				}
				else
				{
					activeIcon = mc;
					activeIcon.scaleX = activeIcon.scaleY = SCALE_OUT;
				}
			}
		}
		
		protected function addHitBox( ) : void
		{
			hitBox = new Box( width, height );
			var xPos : Number;
			xPos = Math.min( titleTxt.x, iconTxt.x );
			hitBox.x = xPos;
			hitBox.alpha = 0;
			addChild( hitBox );
		}
		
		protected function doOverState( ) : void
		{
			if( iconTxt && contains ( iconTxt ) ) 
				TweenMax.to( iconTxt, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED });
				TweenMax.to( icon, SiteConstants.NAV_TIME_IN * .5, { y: ICON_Y_OFFSET, ease: Quad.easeOut } );
				TweenMax.to( activeIcon, SiteConstants.NAV_TIME_IN * .6, { scaleX: SCALE_OVER, scaleY: SCALE_OVER, ease: Quad.easeOut } );
		}

		protected function doOutState( ) : void
		{
			if( iconTxt && contains ( iconTxt ) ) 
				TweenMax.to( iconTxt, SiteConstants.NAV_TIME_OUT, { tint: 0xFFFFFF } );
				TweenMax.to( icon, SiteConstants.NAV_TIME_IN * .5, { y: 0, ease: Quad.easeOut } );
				TweenMax.to( activeIcon, SiteConstants.NAV_TIME_OUT, { scaleX: SCALE_OUT, scaleY: SCALE_OUT, ease: Quad.easeOut } );
		}
		
		protected function doClickState( ) : void
		{
			if( iconTxt && contains ( iconTxt ) ) 
				TweenMax.to( iconTxt, 0, { tint: SiteConstants.COLOR_RED } );
				TweenMax.to( activeIcon, 0, { scaleX: SCALE_OUT, scaleY: SCALE_OUT } );
		}
		
		protected function scaleIconOut( ) : void
		{
			if( iconTxt && contains ( iconTxt ) ) 
				TweenMax.to( iconTxt, SiteConstants.NAV_TIME_IN, { tint: SiteConstants.COLOR_RED } );
		}

		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function set iconType( s : String ) : void
		{
			_iconType = s;
		}
		
		public function set isUnlocked( boolean : Boolean ) : void
		{
//			trace( "SUMMARYCONTENTNAVITEM : set isUnlocked()" );
			_isUnlocked = boolean;
		}
	}
}