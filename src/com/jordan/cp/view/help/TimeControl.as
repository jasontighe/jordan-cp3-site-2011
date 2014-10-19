package com.jordan.cp.view.help {
	import com.jasontighe.containers.AutoTextContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.jordan.cp.view.video.VideoCursor;
	import com.plode.framework.managers.AssetManager;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class TimeControl 
	extends HelpSection 
	{
		//----------------------------------------------------------------------------
		// protected static constants
		//----------------------------------------------------------------------------
		protected static const CURSOR_X					: uint = 190;
		protected static const CURSOR_Y					: uint = 225;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var titleTxt								: AutoTextContainer;
		public var descTxt								: AutoTextContainer;
		public var guideTxt								: AutoTextContainer;
		public var shift								: MovieClip;
		public var plus									: MovieClip;
		public var cursor								: VideoCursor;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function TimeControl() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			trace( "TIMECONTROL : init()" );
			addViews();
//			super.init();	
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
		protected function addViews() : void
		{
			trace( "TIMECONTROL : addViews()" );
			addBackground();
			addCursor();
			addCopy();
		}
		
		protected function addBackground() : void
		{
//			trace( "TIMECONTROL : addBackground()" );
			var asset : MovieClip = MovieClip( AssetManager.gi.getAsset( "TimeControlBgAsset", SiteConstants.ASSETS_ID ) );
			addChild( asset );
			
			icon = asset .icon;
			hr = asset.hr;
			shift = asset.shift;
			plus = asset.plus;
			background = asset.background;
		}
		
		protected function addCursor() : void
		{
//			trace( "TIMECONTROL : addCursor()" );
			var cursor : VideoCursor = new VideoCursor();
			cursor.isActive = false;
			cursor.init();
			cursor.x = CURSOR_X;
			cursor.y = CURSOR_Y;
			addChild( cursor );
		}
		
		protected function addCopy() : void
		{	
//			trace( "TIMECONTROL : addCopy()" );
			var id : String;
			var textWidth : uint = background.width;
			var dto : CopyDTO;
			
			id = "help-time-title"
			dto = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			titleTxt = new AutoTextContainer( );
			titleTxt.setWidth( textWidth );
			titleTxt.populate( dto, id, true, true );
			addChild( titleTxt );
			
			id = "help-time-desc"
			dto = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			descTxt = new AutoTextContainer( );
			descTxt.setWidth( textWidth );
			descTxt.populate( dto, id, true, true );
			addChild( descTxt );
			
			id = "help-time-instruction"
			dto = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			guideTxt = new AutoTextContainer( );
//			guideTxt.setWidth( textWidth );
			guideTxt.populate( dto, id );
			addChild( guideTxt );
			
//			trace( "TIMECONTROL : addCopy() : dto.copy is "+dto.copy );
		}
	}
}