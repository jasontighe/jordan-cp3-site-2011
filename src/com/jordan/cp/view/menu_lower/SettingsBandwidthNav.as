package com.jordan.cp.view.menu_lower {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.jasontighe.navigations.Nav;
	import com.jasontighe.util.Box;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.managers.BandwidthManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.view.AbstractNav;
	import com.jordan.cp.view.menu_lower.events.NavEvent;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class SettingsBandwidthNav 
	extends AbstractNav 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected const BG_COLOR						: uint = 0x181818;
		protected const BG_COLOR_INIT					: uint = 0x515151;
		protected var _nav								: Nav
		protected var navArray							: Array
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var high									: SettingsBandwidthNavItem;
		public var low									: SettingsBandwidthNavItem;
		public var background							: MovieClip;
		public var masker								: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SettingsBandwidthNav() 
		{
//			trace( "SETTINGSBANDWIDTHNAV : Constr" );
			super();
//			init();
		}
		
		public override function init() : void
		{
//			trace( "SETTINGSBANDWIDTHNAV : init()" );
			addNav();
			masker = new Box( background.width, background.height );
			addChild( masker );
			this.mask = masker;
		}
		
		public override function transitionIn() : void
		{
//			show( SiteConstants.NAV_TIME_IN );
			show();
			
			var timeOffset : Number;
			var i : uint = 0;
			var I : uint = navArray.length;
			for( i; i < I; i++ )
			{
				var navItem : SettingsBandwidthNavItem = navArray[ i ];
				navItem.hide();
				timeOffset = ( SiteConstants.NAV_TIME_IN * .4  ) * ( i + .5 );
				navItem.show( SiteConstants.NAV_TIME_IN, timeOffset );
			}
			
			TweenMax.from( masker, SiteConstants.NAV_TIME_IN, { x: -masker.width, ease:Quad.easeOut, onComplete: transitionInComplete } );
			TweenMax.from( background, SiteConstants.NAV_TIME_IN, { tint: BG_COLOR_INIT } );
		}
		
		public override function transitionOut() : void
		{
//			show( SiteConstants.NAV_TIME_OUT );
			TweenMax.to( masker, SiteConstants.NAV_TIME_IN, { x: -masker.width, ease:Quad.easeOut, onComplete: transitionOutComplete } );
			TweenMax.to( background, SiteConstants.NAV_TIME_IN, { tint: BG_COLOR_INIT } );
		}

		public override function activate() : void
		{
			trace( "SETTINGSBANDWIDTHNAV : activate()" );
//			_nav.enable();
		}
		
		public override function deactivate() : void
		{
			trace( "SETTINGSBANDWIDTHNAV : deactivate()" );
//			_nav.disable();
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addNav() : void
		{
			var highId : String = "nav-high-bandwidth"
			var highCopy : String = ContentModel.gi.getCopyDTOByName( highId ).copy;
			var lowId : String = "nav-low-bandwidth"
			var lowCopy : String = ContentModel.gi.getCopyDTOByName( lowId ).copy;
			
			var bandwidthId : uint = 0;
			var highBandwidth : Boolean = BandwidthManager.gi.highBandwidth();
			if( !highBandwidth )	bandwidthId = 1;
			
			var navCopies : Array = new Array( highCopy, lowCopy );
			
			navArray = new Array( high, low );
			_nav = new Nav();
			var item : SettingsBandwidthNavItem;
			var last : SettingsBandwidthNavItem;
			var i : uint = 0;
			var I : uint = navArray.length;
			var lastItem : uint = I - 1;
			
			for( i; i < I; i++ )
			{
				item = navArray[ i ];
				item.setIndex( i );
				
				var text : String =  navCopies[ i ];
				item.copyTxt.tf.htmlText = text;
				
				item.init();
				item.setOutEventHandler( onNavItemOut );
				item.setOverEventHandler( onNavItemOver );
				item.setClickEventHandler( onNavItemClick );
				
				if( i != bandwidthId)
					item.setOutState();
					
				_nav.add( item );
				_nav.addChild( item );
			}
			_nav.init();
			
			addChild( _nav );
			preselectBandwidth( bandwidthId ); 
		}
		
		protected override function transitionInComplete() : void
		{
		}
		
		protected function preselectBandwidth( id : uint ) : void
		{
			var item : SettingsBandwidthNavItem = _nav.getItemAt( id ) as SettingsBandwidthNavItem;
			_nav.setActiveIndex( id );
		}	
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onNavItemOut( e : Event ) : void
		{
			var item : SettingsBandwidthNavItem = e.target as SettingsBandwidthNavItem;
			item.setOutState();
		}
		
		protected function onNavItemOver( e : Event ) : void
		{
			var item : SettingsBandwidthNavItem = e.target as SettingsBandwidthNavItem;
			item.setOverState();
			dispatchEvent( new NavEvent( NavEvent.INTERACTING ) );
		}
		
		protected function onNavItemClick( e : Event ) : void
		{
			var item : SettingsBandwidthNavItem = e.target as SettingsBandwidthNavItem;
			_nav.setActiveItem( item );
			item.setActiveState();
			dispatchEvent( new Event( Event.COMPLETE ) );
			
			BandwidthManager.gi.speed = (item == high) ? BandwidthManager.HIGH : BandwidthManager.LOW;
		}
	}
}
