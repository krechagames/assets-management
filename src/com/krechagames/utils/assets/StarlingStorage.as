/*
 * Copyright 2013 Krecha Games (www.krecha-games.com)
 */

/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 18.12.2012
 * Time: 16:40
 */
package com.krechagames.utils.assets {
	import com.krechagames.utils.assets.interfaces.IAsset;
	import com.krechagames.utils.assets.loaders.ImageAsset;
	import com.krechagames.utils.assets.loaders.RawDataAsset;
	import com.krechagames.utils.assets.loaders.TextAsset;
	import com.krechagames.utils.assets.storage.StarlingAtlasAsset;
	import com.krechagames.utils.assets.storage.StarlingFontAsset;

	import flash.geom.Rectangle;

	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class StarlingStorage extends AssetsStorage {
		public var scale:Number;

		public var generateMipMaps:Boolean;
		public var optimizeForRenderTexture:Boolean;

		public function StarlingStorage(scale:Number = 1) {
			this.scale = scale;

			this.generateMipMaps = true;
			this.optimizeForRenderTexture = false;
		}

		public function prepareAtlas(atlasName:String, atlasXML:String = null):TextureAtlas {
			if (!hasAtlas (atlasName)) {
				var texture:Texture;

				var asset:IAsset = getAsset (atlasName);

				if (asset is RawDataAsset) {				
					texture = Texture.fromAtfData(RawDataAsset(asset).castBytes, scale);
				}else {
					texture = Texture.fromBitmap(ImageAsset(asset).castBitmap, generateMipMaps, optimizeForRenderTexture, scale);
				}

				var atlas:TextureAtlas = new TextureAtlas( texture,
					atlasXML == null ? null : TextAsset(getAsset(atlasXML)).castXML
				)

				atlas.addRegion(atlasName, new Rectangle(0, 0, texture.nativeWidth/scale, texture.nativeHeight/scale));

				if ( atlasXML ) removeAsset(atlasXML);
				removeAsset(atlasName)

				setAsset(new StarlingAtlasAsset(atlasName, asset.group, atlas))
			}
			return getAtlas(atlasName);
		}

		public function prepareFont( texture:Texture, fontXML:String):BitmapFont {
			var asset:TextAsset = TextAsset (getAsset (fontXML));

			var font:BitmapFont = new BitmapFont (texture, asset.castXML);
			TextField.registerBitmapFont (font);
			
			removeAsset(fontXML);

			setAsset(new StarlingFontAsset(font.name, asset.group, font))

			return getBitmapFont(font.name);
		}

		public function hasAtlas(name:String):Boolean {
			return !(hasAsset(name) == null) && getAsset(name) is StarlingAtlasAsset;
		}

		public function hasFont(name:String):Boolean {
			return !(hasAsset(name) == null) && getAsset(name) is StarlingFontAsset;
		}

		public function getBitmapFont(fontName:String):BitmapFont {
			return hasFont(fontName) ? StarlingFontAsset(getAsset(fontName)).castFont : null;
		}

		public function getAtlas(atlasName:String):TextureAtlas {
			return hasAtlas(atlasName) ? StarlingAtlasAsset(getAsset(atlasName)).castAtlas : null;
		}

		public function getTexture(atlasName:String, textureName:String = null):Texture {
			return hasAtlas(atlasName) ? getAtlas(atlasName).getTexture(textureName == null ? atlasName : textureName) : null;
		}

		public function getTextures(atlasName:String, texturesName:String):Vector.<Texture> {
			return hasAtlas(atlasName) ? getAtlas(atlasName).getTextures(texturesName) : null;
		}
	}
}
