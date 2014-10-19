package com.jordan.cp.view.menu_lower {
	import com.jasontighe.containers.AutoTextContainer;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;

	/**
	 * @author jason.tighe
	 */
	public class Help 
	extends UserNavItem 
	{
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function Help() 
		{
			super();
//			init();
		}

		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init() : void
		{
			background.alpha = 0;
			
			var id : String = "help-title"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			copyTxt = new AutoTextContainer( );
			copyTxt.populate( dto, id );
			addChild( copyTxt );
		}
	}
}
