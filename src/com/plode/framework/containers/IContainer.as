package com.plode.framework.containers
{
	public interface IContainer
	{
		function setup() : void;
		
//		function update(... optionalArgs) : void;
		
		function show(dur : Number = .5, del : Number = 0) : void;
		
		function hide(dur : Number = .5, del : Number = 0) : void;
		
		function dispose() : void;
	}
}