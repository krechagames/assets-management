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
	import com.krechagames.utils.assets.loaders.concrete.ImageAsset;
	import com.krechagames.utils.assets.loaders.concrete.RawDataAsset;
	import com.krechagames.utils.assets.loaders.concrete.TextAsset;

	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class StarlingStorage extends AssetsStorage {
		protected var atlasStorage:Dictionary;

		protected var fontStorage:Dictionary;

		public var scale:Number;

		public function StarlingStorage(scale:Number = 1) {
			this.scale = scale;

			this.atlasStorage = new Dictionary(true);
			this.fontStorage = new Dictionary(true);
		}

		public function prepareAtlas(atlasName:String, atlasXML:String = null, disposeAssets:Boolean = true):TextureAtlas {
			if (!hasAtlas (atlasName)) {
				var texture:Texture;

				var asset:IAsset = getAsset (atlasName);

				if (asset is RawDataAsset) {				
					texture = Texture.fromAtfData(RawDataAsset(asset).castBytes, scale);
				}else {
					texture = Texture.fromBitmap(ImageAsset(asset).castBitmap, true, false, scale);
				}

				var atlas:TextureAtlas = new TextureAtlas( texture,
					atlasXML == null ? null : TextAsset(getAsset(atlasXML)).castXML
				)

				atlas.addRegion(atlasName, new Rectangle(0, 0, texture.nativeWidth/scale, texture.nativeHeight/scale));

				atlasStorage[atlasName] = atlas;

				if(disposeAssets){
					if ( atlasXML ) removeAsset(atlasXML);
					removeAsset(atlasName)
				}
			}		
			return getAtlas(atlasName);
		}

		public function prepareFont( texture:Texture, fontXML:String, disposeAssets:Boolean = true):BitmapFont {
			var font:BitmapFont = new BitmapFont (texture, TextAsset (getAsset (fontXML)).castXML);
			TextField.registerBitmapFont (font);
			
			fontStorage[font.name] = font;

			if(disposeAssets){
				removeAsset(fontXML);
			}

			return getBitmapFont(font.name);
		}

		public function hasAtlas(name:String):Boolean {
			return !(atlasStorage[name] == null);
		}

		public function hasFont(name:String):Boolean {
			return !(fontStorage[name] == null);
		}

		public function getBitmapFont(fontName:String):BitmapFont {
			return hasFont(fontName) ? BitmapFont(fontStorage[fontName]) : null;
		}

		public function getAtlas(atlasName:String):TextureAtlas {
			return hasAtlas(atlasName) ? TextureAtlas(atlasStorage[atlasName]) : null;
		}

		public function getTexture(atlasName:String, textureName:String = null):Texture {
			return hasAtlas(atlasName) ? getAtlas(atlasName).getTexture(textureName == null ? atlasName : textureName) : null;
		}

		public function getTextures(atlasName:String, texturesName:String):Vector.<Texture> {
			return hasAtlas(atlasName) ? getAtlas(atlasName).getTextures(texturesName) : null;
		}

		override public function dispose():void {
			var i:String;

			for(i in fontStorage){
				TextField.unregisterBitmapFont(BitmapFont(fontStorage[i]).name, true);
				BitmapFont(fontStorage[i]).dispose();

				delete fontStorage[i];
			}

			for(i in atlasStorage){
				TextureAtlas(atlasStorage[i]).dispose();

				delete atlasStorage[i];
			}

			super.dispose();
		}
	}
}
