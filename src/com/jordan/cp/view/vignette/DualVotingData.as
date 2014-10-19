package com.jordan.cp.view.vignette {
	import com.jordan.cp.constants.TrackingConstants;
	import com.jordan.cp.managers.TrackingManager;
	import com.jordan.cp.model.ContentModel;

	/**
	 * @author jason.tighe
	 */
	public class DualVotingData 
	{
		//----------------------------------------------------------------------------
		// protected variables
		//----------------------------------------------------------------------------
		protected var _status						: String;
		protected var _votedFor						: String;
		protected var _jordanCount					: uint;
		protected var _blondeCount					: uint;
		protected var _jordanPerc					: uint;
		protected var _blondePerc					: uint;
		protected var _totalVotes					: uint;
		//----------------------------------------------------------------------------
		// constructor
		//----------------------------------------------------------------------------
		public function DualVotingData( data : * )
		{
			var response : Object = data;				
			
			_status = response.status;
			_votedFor = response.user_voted_for;
			_jordanCount = response.results.raw_counts.jordan;
			_blondeCount = response.results.raw_counts.blonde;
			_jordanPerc = response.results.percentages.jordan;
			_blondePerc = response.results.percentages.blonde;
			_totalVotes = response.results.total_votes;
			
			ContentModel.gi.hasVoted = true;
			ContentModel.gi.vote = _votedFor;
			
			trace( "\n" );
			trace( "DUALVOTINGDATA : response is "+response );
			trace( "DUALVOTINGDATA : _status is "+_status );
			trace( "DUALVOTINGDATA : _votedFor is "+_votedFor );
			trace( "DUALVOTINGDATA : _jordanCount is "+_jordanCount );
			trace( "DUALVOTINGDATA : _blondeCount is "+_blondeCount );
			trace( "DUALVOTINGDATA : _jordanPerc is "+_jordanPerc );
			trace( "DUALVOTINGDATA : _blondePerc is "+_blondePerc );
			trace( "DUALVOTINGDATA : _totalVotes is "+_totalVotes );
			
			if( _votedFor == "blonde" )
			{
				TrackingManager.gi.trackCustom( TrackingConstants.DANCE_OFF_VOTE_BLONDE );
			}
			else
			{
				TrackingManager.gi.trackCustom( TrackingConstants.DANCE_OFF_VOTE_KID );
			}
			
//			{
//				"status":"success",
//				"user_voted_for":"blonde",
//				"results":
//				{
//					"raw_counts":
//					{
//						"blond":"10",
//						"blonde":"1",
//						"jordan":"9"
//					},
//					"percentages":
//					{
//						"blond":"50%",
//						"blonde":"5%",
//						"jordan":"45%"
//					},
//					"total_votes":20
//				}
//			}
			
		}
		
		//----------------------------------------------------------------------------
		// getters/setters
		//----------------------------------------------------------------------------
		public function get status() : String
		{
			return _status;
		}
		
		public function get votedFor() : String
		{
			return _votedFor;
		}
		
		public function get jordanCount() : uint
		{
			return _jordanCount;
		}
		
		public function get blondeCount() : uint
		{
			return _blondeCount;
		}
		
		public function get jordanPerc() : uint
		{
			return _jordanPerc;
		}
		
		public function get blondePerc() : uint
		{
			return _blondePerc;
		}
		
		public function get totalVotes() : uint
		{
			return _totalVotes;
		}
	}
}
