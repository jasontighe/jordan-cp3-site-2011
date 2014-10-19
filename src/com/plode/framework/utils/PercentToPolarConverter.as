package com.plode.framework.utils
{

	/**
	 * @author nelson.shin
	 */
	public class PercentToPolarConverter 
	{
		public static function getPolarValue(val : Number) : Number
		{
			var polar : Number = val * 2 - 1;
			return polar;
		}
	}
}
