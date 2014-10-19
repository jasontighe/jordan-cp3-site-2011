package com.jordan.cp.view.menu_lower {
	import com.jasontighe.containers.AutoTextContainer;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;

	/**
	 * @author jason.tighe
	 */
	public class SettingsTwitter 
	extends SettingsSocialNavItem 
	{
		//----------------------------------------------------------------------------
		// protected constants
		//----------------------------------------------------------------------------
		protected const ICON_COLOR_OVER						: uint = 0x68d9ff;
		protected const ICON_COLOR_OUT						: uint = 0x464646;
		protected const TEXT_COLOR_OVER						: uint = 0xFFFFFF;
		protected const TEXT_COLOR_OUT						: uint = 0x464646;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SettingsTwitter() 
		{
			super();
//			init();
		}

		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			_iconColorOver = ICON_COLOR_OVER;
			_iconColorOut = ICON_COLOR_OUT;
			_textColorOver = TEXT_COLOR_OVER;
			_textColorOut = TEXT_COLOR_OUT;
			
			var id : String = "twitter-title"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			copyTxt = new AutoTextContainer( );
			copyTxt.populate( dto, id );
			addChild( copyTxt );
		}
	}
}
