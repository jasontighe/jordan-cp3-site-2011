package com.jordan.cp.view.locks {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.AutoTextContainer;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.StateModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jsuntai
	 */
	public class Locks 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var PADDING						: uint = 4;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _contentModel							: ContentModel;
		protected var _stateModel							: StateModel;
		protected var _lockedX								: uint;
		protected var _lockedY								: uint;
		protected var _unlockedX							: uint;
		protected var _unlockedY							: uint;
		protected var _arrowY								: uint;
		protected var _yPosUp								: int;
		protected var _yPosDown							: int;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var lockMask									: MovieClip;
		public var locked									: MovieClip;
		public var unlocked									: MovieClip;
		public var arrowRed									: MovieClip;
		public var arrowWhite								: MovieClip;
		public var redBg									: MovieClip;
		public var greyBg									: MovieClip;
		public var background								: MovieClip;
		public var locksAsset								: MovieClip;
		public var statsBox									: Box;
		public var bonusBox									: Box;
		public var arrowRedBox								: Box;
		public var arrowWhiteBox							: Box;
		
		public var bonusTxt									: AutoTextContainer;
		public var statsTxt									: AutoTextContainer;
		public var unlockedTxt								: AutoTextContainer;
		public var slashTxt									: AutoTextContainer;
		public var totalTxt									: AutoTextContainer;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Locks() 
		{
			trace( "LOCKS : Constr" );
			super();
		}
		 
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		 public override function init() : void
		 {
			trace( "LOCKS : init()" );
		 	addLockAsset();
		 	setVariables();
		 	addCopy();
		 	hideUnlocked();
		 	addContentModelListener();
		 	addMasks();
		 	activate();
		 }
		
		public function activate() : void
		{
			trace( "LOCKS : activate()" );
			 addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			 addEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = true;
			 useHandCursor = true;
			 mouseEnabled = true;
			 mouseChildren = false;
		}
		
		public function deactivate() : void
		{
			 removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			 removeEventListener (MouseEvent.MOUSE_OUT, onMouseOut );
			 removeEventListener( MouseEvent.CLICK, onClick );
			 
			 buttonMode = false;
			 useHandCursor = false;
			 mouseEnabled = false;
			 mouseChildren = false;
		}

		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addLockAsset() : void
		{
//			trace( "LOCKS : addLockAsset()" );
			locksAsset = MovieClip( AssetManager.gi.getAsset( "LocksAsset", SiteConstants.ASSETS_ID ) );
			addChild( locksAsset );
			
			lockMask = locksAsset.lockMask;
			locked = locksAsset.locked;
			unlocked = locksAsset.unlocked;
			arrowRed = locksAsset.arrowRed;
			arrowWhite = locksAsset.arrowWhite;
			redBg = locksAsset.redBg;
			greyBg = locksAsset.greyBg;
			background = locksAsset.background;
			
			background.alpha = 0;
			_arrowY = arrowRed.y;
		}
		
		protected function setVariables() : void
		{
			_lockedX = locked.x;
			_lockedY = locked.y;
			_unlockedX = unlocked.x;
			_unlockedY = unlocked.y;
		}
		
		protected function addCopy() : void
		{
//			trace( "LOCKS : addCopy()" );
			var bonusId : String = "locks-bonus-content";
			var bonusDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( bonusId ) as CopyDTO;
			bonusTxt = new AutoTextContainer( );
			bonusTxt.populate( bonusDTO, bonusId );
			addChild( bonusTxt );
			
			var statsId : String = "locks-see-stats";
			var statsDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( statsId ) as CopyDTO;
			statsTxt = new AutoTextContainer( );
			statsTxt.populate( statsDTO, statsId);
			addChild( statsTxt );
			
			var unlockedId : String = "locks-unlocked";
			var unlockedDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( unlockedId ) as CopyDTO;
			unlockedTxt = new AutoTextContainer( );
			unlockedTxt.populate( unlockedDTO, unlockedId );
			addChild( unlockedTxt );
//			trace( "LOCKS : addCopy() : _contentModel is "+_contentModel );
//			trace( "LOCKS : addCopy() : _contentModel.unlockedContent.length is "+_contentModel.unlockedContent.length );
			var unlockedLength : uint = _contentModel.unlockedContent.length as uint;
			var unlocked : String = String( unlockedLength );
			unlockedTxt.update( unlocked );
			
			var slashId : String = "locks-slash";
			var slashDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( slashId ) as CopyDTO;
			slashTxt = new AutoTextContainer( );
			slashTxt.populate( slashDTO, slashId );
			addChild( slashTxt );
			
			var totalId : String = "locks-total";
			var totalDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( totalId ) as CopyDTO;
			totalTxt = new AutoTextContainer( );
			totalTxt.populate( totalDTO, totalId );
			addChild( totalTxt );
//			trace( "LOCKS : addCopy() : _contentModel is "+_contentModel );
//			trace( "LOCKS : addCopy() : _contentModel.content.length is "+_contentModel.content.length );
			var totalLength : uint = _contentModel.content.length as uint;
			var total : String = String( totalLength );
			totalTxt.update( total );
			
			_yPosUp = Math.round( statsTxt.y  - statsTxt.height - PADDING );
			_yPosDown = Math.round( statsTxt.y  + statsTxt.height + PADDING );
		}
		
		protected function addMasks() : void
		{
			statsBox = new Box( statsTxt.width, statsTxt.height );
			statsBox.x = statsTxt.x;
			statsBox.y = statsTxt.y;
			statsBox.alpha = .1;
			addChild( statsBox );
			statsTxt.mask = statsBox;

			bonusBox = new Box( bonusTxt.width, bonusTxt.height );
			bonusBox.x = bonusTxt.x;
			bonusBox.y = bonusTxt.y;
			bonusBox.alpha = .1;
			addChild( bonusBox );
			bonusTxt.mask = bonusBox;

			arrowRedBox = new Box( bonusTxt.height, bonusTxt.height );
			arrowRedBox.x = arrowRed.x;
			arrowRedBox.y = bonusTxt.y;
			arrowRedBox.alpha = .1;
			addChild( arrowRedBox );
			arrowRed.mask = arrowRedBox;

			arrowWhiteBox = new Box( bonusTxt.height, bonusTxt.height );
			arrowWhiteBox.x = arrowWhite.x;
			arrowWhiteBox.y = bonusTxt.y;
			arrowWhiteBox.alpha = .1;
			addChild( arrowWhiteBox );
			arrowWhite.mask = arrowWhiteBox;

			statsTxt.y = _yPosUp;
			arrowWhite.y = _yPosDown;
		}
		
		protected function hideUnlocked() : void
		{
//			trace( "LOCKS : hideUnlocked()" );
//			statsTxt.alpha = 0;
			unlocked.alpha = 0;
			redBg.alpha = 0;
		}
		
		protected function addContentModelListener() : void
		{
//			trace( "LOCKS : addContentModelListener()" );
			_contentModel.addEventListener( Event.COMPLETE, onContentModelUpdate );
		}
		
		protected function updateCount() : void
		{
//			trace( "LOCKS : updateCount()" );
			var unlockedLength : uint = _contentModel.unlockedContent.length as uint;
			var unlocked : String = String( unlockedLength );
			unlockedTxt.update( unlocked );
		}
		
		protected function lockAnimationAutoplay() : void
		{
		 	killDelayedTweens();
			resetElements();
			
			var time : Number = SiteConstants.NAV_TIME_IN * .5;
			var delay : Number = time * 4;
			
			//slide locked to left
			var lockedX : int = lockMask.x - locked.width - PADDING;
			TweenLite.to( locked, time, { x: lockedX, ease: Quad.easeOut } );
			
			//slide unlocked up
			unlocked.alpha = 1;
			var unlockedY : int = lockMask.y + lockMask.height + PADDING;
			TweenLite.from( unlocked, time, { y: unlockedY, ease: Quad.easeOut } );
			
			//fade bg
			TweenLite.to( redBg, time, { alpha: 1, ease: Quad.easeOut } );
			TweenLite.to( greyBg, time, { alpha: 0, ease: Quad.easeOut } );
			
			//****
			//slide locked back
			TweenLite.to( locked, time, { x: _lockedX, delay: delay, ease: Quad.easeIn } );
			
			var unlockedOutY : int = lockMask.y - unlocked.height - PADDING;
			TweenLite.to( unlocked, time, { y: unlockedOutY, delay: delay, ease: Quad.easeIn } );
			
			//fade bg
			TweenLite.to( redBg, time, { alpha: 0, delay: delay, ease: Quad.easeIn } );
			TweenLite.to( greyBg, time, { alpha: 1, delay: delay, ease: Quad.easeIn } );
			
		}
		
		protected function lockAnimationIn() : void
		{
		 	killDelayedTweens();
			resetElements();
			
			var time : Number = SiteConstants.NAV_TIME_IN * .5;
//			var delay : Number = time * 4;
			
			//slide locked to left
			var lockedX : int = lockMask.x - locked.width - PADDING;
			TweenLite.to( locked, time, { x: lockedX, ease: Quad.easeOut } );
			
			//slide unlocked up
			unlocked.alpha = 1;
			var unlockedY : int = lockMask.y + lockMask.height + PADDING;
			TweenLite.from( unlocked, time, { y: unlockedY, ease: Quad.easeOut } );
			
			//fade bg
			TweenLite.to( redBg, time, { alpha: 1, ease: Quad.easeOut } );
			TweenLite.to( greyBg, time, { alpha: 0, ease: Quad.easeOut } );
		}
		
		protected function lockAnimationOut() : void
		{
			var time : Number = SiteConstants.NAV_TIME_IN * .5;
			
			//****
			//slide locked back
			TweenLite.to( locked, time, { x: _lockedX, ease: Quad.easeIn } );
			
			var unlockedOutY : int = lockMask.y - unlocked.height - PADDING;
			TweenLite.to( unlocked, time, { y: unlockedOutY, ease: Quad.easeIn } );
			
			//fade bg
			TweenLite.to( redBg, time, { alpha: 0, ease: Quad.easeIn } );
			TweenLite.to( greyBg, time, { alpha: 1, ease: Quad.easeIn } );
		}
		
		protected function killDelayedTweens() : void
		{
		 	TweenLite.killDelayedCallsTo( locked );
		 	TweenLite.killDelayedCallsTo( unlocked );
		 	TweenLite.killDelayedCallsTo( redBg );
		 	TweenLite.killDelayedCallsTo( greyBg );
		}
		
		protected function resetElements() : void
		{
			locked.x = _lockedX;
			locked.y = _lockedY;
			unlocked.x = _unlockedX;
			unlocked.y = _unlockedY;
			redBg.alpha = 0;
			greyBg.alpha = 1;
		}
		 
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onContentModelUpdate( e : Event ) : void
		{
//			trace( "LOCKS : onContentModelUpdate() ............................................" );
			updateCount();
			lockAnimationAutoplay();
		}
		
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.5;
//			lockAnimationAutoplay();
			lockAnimationIn();
			
		 	killTweens();
		 	
			TweenLite.to( statsTxt, time, { y: statsBox.y, ease: Quad.easeOut } );
			TweenLite.to( bonusTxt, time, { y: _yPosDown, ease: Quad.easeOut } );
			TweenLite.to( arrowRed, time, { y: _yPosUp, ease: Quad.easeOut } );
			TweenLite.to( arrowWhite, time, { y: _arrowY, ease: Quad.easeOut } );
//			TweenLite.to( arrow, time, { tint: SiteConstants.COLOR_WHITE, ease: Quad.easeOut } );
			
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
			var time : Number = SiteConstants.NAV_TIME_OUT;
		 	killTweens();
			lockAnimationOut();
		 	
			TweenLite.to( statsTxt, time, { y: _yPosUp, ease: Quad.easeOut } );
			TweenLite.to( bonusTxt, time, { y: statsBox.y, ease: Quad.easeOut } );
			TweenLite.to( arrowRed, time, { y: _arrowY, ease: Quad.easeOut } );
			TweenLite.to( arrowWhite, time, { y: _yPosDown, ease: Quad.easeOut } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
			_stateModel.state = StateModel.STATE_SUMMARY;
		}
		 
		 protected function killTweens() : void
		 {	
		 	TweenLite.killTweensOf( bonusTxt );
		 	TweenLite.killTweensOf( statsBox );
		 	TweenLite.killTweensOf( arrowRed );
		 	TweenLite.killTweensOf( arrowWhite );
		 }
		 
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public function set contentModel( object : ContentModel ) : void
		{
			_contentModel = object;
		}
		
		public function set stateModel( object : StateModel ) : void
		{
			_stateModel = object;
		}
	}
}
