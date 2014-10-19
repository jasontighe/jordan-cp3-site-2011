package com.jordan.cp.view.email {
	import com.greensock.TweenLite;
	import com.jasontighe.containers.DisplayContainer;
	import com.jasontighe.util.Box;
	import com.jordan.cp.Shell;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.ContentModel;
	import com.jordan.cp.model.dto.CopyDTO;
	import com.plode.framework.containers.TextContainer;

	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.system.System;
	import flash.utils.setTimeout;

	/**
	 * @author jsuntai
	 */
	public class CopyLinkButton 
	extends DisplayContainer 
	{
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var copyTxt								: TextContainer;
		public var box									: Box;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CopyLinkButton() 
		{
			super();
		}
		
		//----------------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------------
		public override function init( ) : void
		{
			addViews();
		}
	
		public function activate() : void
		{
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
		protected function addViews() : void
		{
			addCopy();
			addHitArea();
		}
		
		protected function addCopy() : void
		{
			var copyId : String = "email-copy"
			var copyDTO : CopyDTO = ContentModel.gi.getCopyDTOByName( copyId ) as CopyDTO;
			copyTxt = new TextContainer( );
			copyTxt.populate( copyDTO.copy, copyId );
			copyTxt.x = copyTxt.y = 0;
			addChild( copyTxt );
		}
		
		protected function addHitArea() : void
		{
			box = new Box( width, height );
			box.alpha = 0;
			addChild( box );
		}
		
		protected function copyLink() : void
		{
			var url : String = Shell.getInstance().getConfigModel().siteURL;
			System.setClipboard( url );
		}
		
		
		protected function changeLinkCopied() : void
		{
			var id : String = "email-copied"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			copyTxt.update( dto.copy );
			copyTxt.x = box.x + box.width - copyTxt.width;
			changeColor( copyTxt, 0xD7270A );
			
			var to : uint = setTimeout( changeCopyLink, 1500 );
		}
		
		protected function changeCopyLink() : void
		{
			var id : String = "email-copy"
			var dto : CopyDTO = ContentModel.gi.getCopyDTOByName( id ) as CopyDTO;
			copyTxt.update( dto.copy );
			copyTxt.x = box.x;
			changeColor( copyTxt, 0xFFFFFF );
			
			activate();
		}
		
		protected function changeColor( object : *, color : uint ) : void
		{
			var colorTransform : ColorTransform = new ColorTransform();
			colorTransform.color = color;
			object.transform.colorTransform = colorTransform;
		}
		
		//----------------------------------------------------------------------------
		// event handlers
		//----------------------------------------------------------------------------
		protected function onMouseOver( e : MouseEvent = null ) : void 
		{
			var time : Number = SiteConstants.NAV_TIME_OUT * 1.2;

			TweenLite.to( copyTxt, SiteConstants.NAV_TIME_IN, { tint: 0xFFFFFF } );
		}
		
		protected function onMouseOut( e : MouseEvent = null ) : void 
		{
			TweenLite.to( copyTxt, SiteConstants.NAV_TIME_IN, { tint: 0x464646 } );
		}
		
		protected function onClick( e : MouseEvent = null ) : void 
		{
			deactivate();
			TweenLite.to( copyTxt, 0, { tint: 0xD7270A } );
			changeLinkCopied();
			copyLink();
		}
	}
}
