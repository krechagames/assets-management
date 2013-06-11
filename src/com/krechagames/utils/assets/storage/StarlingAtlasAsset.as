/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 11.06.2013
 * Time: 11:49
 */
package com.krechagames.utils.assets.storage {
	import com.krechagames.utils.assets.Asset;

	import flash.events.Event;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class StarlingAtlasAsset extends Asset {
		private var atlas:TextureAtlas;

		public function StarlingAtlasAsset(id:String = null, group:String = null, atlas:TextureAtlas = null) {
			super(id, null, group);

			this.atlas = atlas;
		}

		override public function load(version:int = 0):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose():void {
			atlas.dispose();
			atlas = null;

			dispatchEvent(new Event(Event.REMOVED));
		}

		public function get castAtlas():TextureAtlas {
			return atlas;
		}

		public function getTexutre(name:String = null):Texture {
			return atlas.getTexture(name);
		}

		public function getTextures(prefix:String):Vector.<Texture> {
			return atlas.getTextures(prefix);
		}
	}
}
