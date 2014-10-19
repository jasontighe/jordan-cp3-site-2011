package com.jordan.cp.view.locks {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.INavItem;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.plode.framework.containers.TextContainer;

	import flash.events.Event;

	/**
	 * @author jsuntai
	 */
	public class LocksOld 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// protected static variables
		//----------------------------------------------------------------------------
		protected static var BONUS_TXT_X					: uint = 6;
		protected static var BONUS_TXT_Y					: uint = 1;
		protected static var NAME_TXT_X						: uint = 158;
		protected static var NAME_TXT_Y						: uint = 1;
		protected static var NAME_TXT_OFFSET				: uint = 30;
		protected static var HR_WIDTH						: uint = 1;
		protected static var HR_HEIGHT						: uint = 19;
		protected static var HR_X							: uint = 145;
		protected static var HR_Y							: uint = 0;
		protected static var NAME_TXT_PAUSE					: uint = 3;
		protected static var LOCKED							: String = "Locked";
		protected static var BONUS_CONTENT					: String = "Bonus Content";
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var locksArray 							: Array = new Array();
		protected var _content 								: Array = new Array();
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var bonusTxt									: TextContainer;
		public var hr										: Box;
		public var nameTxt									: TextContainer;
		public var nameMask									: Box;
		public var locksNav									: Nav;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function LocksOld() 
		{
			super();
		}
		 
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		 public override function init() : void
		 {
		 	addCopy();
		 	addBoxes();
		 	setMask();
		 	addLocksNav();
		 }
		 
		 public function unlock( id : uint ) : void
		 {
			var id : uint = id;
			var lock : INavItem = locksNav.getItemAt( id);
			lock.setOverState();
			TweenMax.to( lock, .35, { alpha: 1 } );
			
			var name : String = _content[ id ].shortTitle;
		 	updateCopy( name );
		 	
			showText();
		}

		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addCopy() : void
		{
            var bonusCopy : String = BONUS_CONTENT.toUpperCase();
			bonusTxt = new TextContainer();
			bonusTxt.populate( bonusCopy, 'locks-title');
            bonusTxt.x = BONUS_TXT_X;
            bonusTxt.y = BONUS_TXT_Y;
			addChild( bonusTxt );
			
            var nameCopy : String = LOCKED.toUpperCase();
			nameTxt = new TextContainer();
			nameTxt.populate( nameCopy, 'locks-title');
            nameTxt.x = NAME_TXT_X;
            nameTxt.y = NAME_TXT_Y;
            nameTxt.alpha = 0;
			addChild( nameTxt );
		}
		
		protected function addBoxes() : void
		{
			hr = new Box( HR_WIDTH, HR_HEIGHT, SiteConstants.COLOR_RED );
			hr.x = HR_X;
			hr.y = HR_Y;
			hr.alpha = 0;
			addChild( hr );
			
		 	nameMask = new Box( 150, 20 );
		 	nameMask.x = nameTxt.x;
		 	nameMask.y = nameTxt.y;
		 	nameMask.alpha = .1;
		 	addChild( nameMask );
		}
		
		protected function setMask() : void
		{
			nameTxt.mask = nameMask;
		}

		
		protected function addLocksNav() : void
		{
			locksNav = new Nav();
			
			var item : Lock;
			var last : Lock;
			var i : uint = 0;
		 	var I : uint = _content.length;
			var lastItem : uint = I - 1;
			
		 	var totalRows : uint = SiteConstants.LOCKED_TOTAL_ROWS;
		 	var totalColumns : uint = _content.length / totalRows;
		 	var lockedX : uint = SiteConstants.LOCKED_X;
		 	var lockedY : uint = SiteConstants.LOCKED_Y;
		 	var xSpace : uint = SiteConstants.LOCKED_X_SPACE;
		 	var ySpace : uint = SiteConstants.LOCKED_Y_SPACE;
			
			for( i; i < I; i++)
			{	
				var row : uint;
				var col : uint;
				var itemX : uint;
				var itemY : uint;
				
				row = Math.floor( i / totalColumns );
				col = i - ( row * totalColumns );
				var xPos : Number = lockedX + ( col * xSpace );	
				var yPos : Number = lockedY + ( row * ySpace );
				
		 		var lock : Lock = new Lock();
				lock = new Lock();
				lock.setIndex( i );
				
				lock.setOutEventHandler( onLockItemOut );
				lock.setOverEventHandler( onLockOver );
				lock.setClickEventHandler( onLockClick );
				
		 		locksArray.push( lock );
				
		 		lock.x = xPos
		 		lock.y = yPos;
				
				locksNav.add( lock );
				locksNav.addChild( lock );
			}
			
			locksNav.init();
			addChild( locksNav );
			
		 	setWidth( width );
		 	setHeight( height );
		}
		
		protected function updateCopy( s : String ) : void
		{
		 	nameTxt.update( s );
		}
		
		
		protected function showText() : void
		{
		 	nameTxt.x = NAME_TXT_X - nameTxt.width - NAME_TXT_OFFSET;
		 	nameTxt.alpha = 1;
		 	
		 	TweenMax.killDelayedCallsTo( hr );
		 	TweenMax.killDelayedCallsTo( nameTxt );
		 	
			TweenMax.to( hr, SiteConstants.NAV_TIME_OUT, { alpha: 1 } );
		 	TweenMax.to( nameTxt, SiteConstants.NAV_TIME_IN, { x: NAME_TXT_X, ease: Quad.easeOut } );
		 	
		 	var delay : Number = NAME_TXT_PAUSE + SiteConstants.NAV_TIME_OUT;
		 	TweenMax.to( nameTxt, SiteConstants.NAV_TIME_IN, { alpha: 0, delay: delay } );
		 	TweenMax.to( hr, SiteConstants.NAV_TIME_IN, { alpha: 0, delay: delay } );
		}
		 
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onLockItemOut( e : Event ) : void
		{
//			var lock : Locks = e.target as Locks; 
//			lock.setOutState();
		}
		
		protected function onLockOver( e : Event ) : void
		{
//			var lock : Locks = e.target as Locks; 
//			lock.setOverState();
		}
		
		protected function onLockClick( e : Event ) : void
		{
			var lock : Lock = e.target as Lock; 
			var id : uint = lock.getIndex();
			
			var isUnlockedContent : Boolean = Shell.getInstance().getContentModel().isUnlockedContent( id );
			var name : String;
			if( isUnlockedContent )
			{
				name = _content[ id ].shortTitle;
		 		updateCopy( name.toUpperCase() );
			}
			else
			{
				name = LOCKED.toUpperCase();
			}
			
			updateCopy( name );
			showText();
		}
		 
		//----------------------------------------------------------------------------
		// getter/setters
		//----------------------------------------------------------------------------
		public function set content( array : Array ) : void
		{
			_content = array;
		}
	}
}
