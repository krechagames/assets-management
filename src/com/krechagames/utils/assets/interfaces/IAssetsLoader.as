/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 13:49
 */
package com.krechagames.utils.assets.interfaces {
	import flash.events.IEventDispatcher;

	public interface IAssetsLoader extends IEventDispatcher {
		function get storage():IAssetsStorage;
		function set storage(value:IAssetsStorage):void;
		function load(list:Vector.<IAsset>):void
		function get total():uint;
		function get current():IAsset;
		function dispose():void;
	}
}
