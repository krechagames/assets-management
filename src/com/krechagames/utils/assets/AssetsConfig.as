/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 15:16
 */
package com.krechagames.utils.assets {
	import com.krechagames.utils.assets.interfaces.IAsset;
	import com.krechagames.utils.assets.loaders.concrete.ImageAsset;
	import com.krechagames.utils.assets.loaders.concrete.RawDataAsset;
	import com.krechagames.utils.assets.loaders.concrete.SoundAsset;
	import com.krechagames.utils.assets.loaders.concrete.TextAsset;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class AssetsConfig extends TextAsset {
		private var _groups:Vector.<String>;

		private var _list:Vector.<IAsset>;

		private var _types:Dictionary;

		public function AssetsConfig(id:String, url:String, groups:Vector.<String> = null) {
			super(id, url);

			_groups = groups;
			_list = new Vector.<IAsset>();
			_types = new Dictionary(true);

			registerType("image", ImageAsset);
			registerType("text", TextAsset);
			registerType("sound", SoundAsset);
			registerType("raw", RawDataAsset);
		}

		public function registerType(type:String, loaderClass:Class):void {
			_types[type] = loaderClass;
		}

		override protected function loadEventHandler(e:Event):void {
			if(e.type == Event.COMPLETE){
				parse();
			}

			super.loadEventHandler(e);
		}

		protected function parse():void {
			var xml:XML = castXML;
			var group:XML;
			var asset:IAsset;

			var skip:Boolean = false;

			var j:int;
			var i:int = -1;
			while(++i < xml.group.length()){
				group = xml.group[i];

				if(_groups){
					skip = true;

					j = -1;
					while(++j < _groups.length){
						if(_groups[j] == group.@name){
							skip = false;
							break;
						}
					}
				}

				if(!skip){
					j = -1;
					while(++j < group.asset.length()){
						asset = createAsset(group.asset[j].@type);
						asset.id = group.asset[j].@id;
						asset.url = group.asset[j].@url;
						asset.group = group.@name;

						_list.push(asset);
					}
				}

			}
		}

		protected function createAsset(type:String):IAsset {
			var loaderClass:Class = _types[type];

			if(loaderClass == null){
				throw new IOError("Error: Asset type '"+type+"' is unknown.");
			}else {
				return IAsset(new loaderClass);
			}
		}

		public function get list():Vector.<IAsset> {
			return _list;
		}

		override public function dispose():void {
			_list = null;
			_groups = null;
			_types = null;

			super.dispose();
		}
	}
}
