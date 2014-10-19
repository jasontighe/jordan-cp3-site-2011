package com.jordan.cp.view.menu_lower {
	import com.jasontighe.containers.AutoTextContainer;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;

	/**DisplayContainer
	 * @author jason.tighe
	 */
	public class SettingsEmail 
	extends SettingsSocialNavItem 
	{
		//----------------------------------------------------------------------------
		// protected constants
		//----------------------------------------------------------------------------
		protected const ICON_COLOR_OVER						: uint = 0xD7270A;
		protected const ICON_COLOR_OUT						: uint = 0x464646;
		protected const TEXT_COLOR_OVER						: uint = 0xFFFFFF;
		protected const TEXT_COLOR_OUT						: uint = 0x464646;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function SettingsEmail() 
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
			
			var id : String = "send-an-email-title"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			copyTxt = new AutoTextContainer( );
			copyTxt.populate( dto, id );
			addChild( copyTxt );
		}
	}
}
