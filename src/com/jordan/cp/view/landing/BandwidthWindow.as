package com.jordan.cp.view.landing {
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.navigations.Nav;
	import com.jordan.cp.assets.Logo;
	import com.jordan.cp.managers.BandwidthManager;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.plode.framework.containers.TextContainer;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jason.tighe
	 */
	public class BandwidthWindow 
	extends DisplayContainer 
	{	
		//----------------------------------------------------------------------------
		// protected constants
		//----------------------------------------------------------------------------
		protected const HIGH_BANDWIDTH				: String = "HIGH BANDWIDTH";
		protected const LOW_BANDWIDTH				: String = "LOW BANDWIDTH";
		protected const TITLE_X						: uint = 217;
		protected const TITLE_Y						: uint = 18;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _nav							: Nav
		protected var _bandwidthManager				: BandwidthManager;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var logo								: Logo;
		public var titleTxt							: TextContainer;
		public var descTxt							: TextContainer;
		public var chooseTxt						: TextContainer;
		public var hr								: MovieClip;
		public var high								: BandwidthNavItem;
		public var low								: BandwidthNavItem;
		public var grid								: MovieClip;
		public var black_bg							: MovieClip;
		public var topHolder						: MovieClip;
		public var bottomHolder						: MovieClip;
		
		public function BandwidthWindow() 
		{
			trace( "BANDWIDTHWINDOW : Constr : XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" );
			super();
		}
	}
}
