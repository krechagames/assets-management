/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 12:26
 */
package com.krechagames.utils.assets.interfaces {
	import flash.events.IEventDispatcher;

	public interface IAsset extends IEventDispatcher {
		function get id():String;
		function set id(value:String):void;
		function get url():String;
		function set url(value:String):void;
		function load():void;
		function dispose():void;
	}
}
