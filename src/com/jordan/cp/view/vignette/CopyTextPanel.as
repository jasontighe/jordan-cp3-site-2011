package com.jordan.cp.view.vignette {
	import com.greensock.TweenLite;
	import com.jasontighe.containers.DisplayContainer;
	import com.jordan.cp.constants.SiteConstants;
	import com.jordan.cp.model.dto.ContentDTO;
	import com.plode.framework.containers.TextContainer;

	import flash.display.MovieClip;

	/**
	 * @author jason.tighe
	 */
	public class CopyTextPanel 
	extends DisplayContainer
	{
		protected static const AREA_WIDTH					: uint = 340;
		protected static const TITLE_X						: uint = 10;
		protected static const TITLE_Y						: uint = 94;
		protected static const DESC_X						: uint = 10;
		protected static const DESC_Y						: uint = 122;
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _dto									: ContentDTO;
		protected var _id									: uint;
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var icon										: CopyIconShoe;
		public var titleTxt									: TextContainer;
		public var descTxt									: TextContainer;
		public var background								: MovieClip;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CopyTextPanel()
		{
			super();
			init();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
		}
		
		public function populateByDTO( dto : ContentDTO ) : void
		{
			_dto = dto;
			
			titleTxt = new TextContainer();
			var title : String = _dto.getNavItemAt( _id ).title.toUpperCase();
			titleTxt.populate( title, 'image-viewer-title', true );
			titleTxt.tf.width = AREA_WIDTH;
			titleTxt.x = TITLE_X;
			titleTxt.y = TITLE_Y;
			addChild( titleTxt );
			
			descTxt = new TextContainer();
			var desc : String = _dto.getNavItemAt( _id ).desc.toUpperCase();
			descTxt.populate( desc, 'image-viewer-desc', true );
			descTxt.tf.width = AREA_WIDTH;
			descTxt.x = DESC_X;
			descTxt.y = DESC_Y;
			addChild( descTxt );
		}
		
		public function transitionCopy( n : uint ) : void
		{
			_id = n;
			transitionOutCopy();
		}
		
		//----------------------------------------------------------------------------
		// protected methods 
		//----------------------------------------------------------------------------
		protected function transitionOutCopy() : void
		{
			TweenLite.to( titleTxt, 0, { alpha: 0, onComplete: transitionOutCopyComplete } );
			TweenLite.to( descTxt, 0, { alpha: 0 } );
		}

		protected function transitionOutCopyComplete() : void
		{
			updateCopy();
			transitionInCopy();
		}
		
		protected function updateCopy( ) : void
		{
			var title : String = _dto.getNavItemAt( _id ).title.toUpperCase();
			titleTxt.update( title );
			
			var desc : String = _dto.getNavItemAt( _id ).desc.toUpperCase();
			descTxt.update( desc );
		}
		
		protected function transitionInCopy() : void
		{
			TweenLite.to( titleTxt, SiteConstants.NAV_TIME_IN, { alpha: 1 } );
			TweenLite.to( descTxt, SiteConstants.NAV_TIME_IN, { alpha: 1 } );
		}
		
		//----------------------------------------------------------------------------
		// getters/setters 
		//----------------------------------------------------------------------------
		public function set id( n : uint ) : void
		{
			_id = n;
		}
	}
}
