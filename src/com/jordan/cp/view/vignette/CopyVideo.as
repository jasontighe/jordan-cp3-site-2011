package com.jordan.cp.view.vignette {
	import com.jordan.cp.model.dto.ContentDTO;

	/**
	 * @author jason.tighe
	 */
	public class CopyVideo 
	extends AbstractVignette 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		//----------------------------------------------------------------------------
		// public variables
		//----------------------------------------------------------------------------
		public var videoPanel							: CopyVideoPanel;
		public var textPanel							: CopyTextPanel;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function CopyVideo() 
		{
			super();
		}
		//----------------------------------------------------------------------------
		// public methods 
		//----------------------------------------------------------------------------
		public override function init() : void
		{
		}
		
		public override function populateByDTO( dto : ContentDTO ) : void
		{
			
		}
		
		//----------------------------------------------------------------------------
		// protected methods
		//----------------------------------------------------------------------------
	}
}
