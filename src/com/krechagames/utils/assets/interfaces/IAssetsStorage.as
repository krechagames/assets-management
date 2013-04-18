/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 14:59
 */
package com.krechagames.utils.assets.interfaces {
	public interface IAssetsStorage {
		function setAsset(asset:IAsset):void;
		function getAsset(id:String):IAsset;
		function removeAsset(id:String):void;
		function dispose():void;
	}
}
