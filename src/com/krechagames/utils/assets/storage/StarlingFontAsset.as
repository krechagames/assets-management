/**
 * Created with IntelliJ IDEA.
 * User: swiezy
 * Date: 11.06.2013
 * Time: 11:49
 */
package com.krechagames.utils.assets.storage {
	import com.krechagames.utils.assets.Asset;

	import flash.events.Event;

	import starling.text.BitmapFont;
	import starling.text.TextField;

	public class StarlingFontAsset extends Asset {
		private var font:BitmapFont;

		public function StarlingFontAsset(id:String = null, group:String = null, font:BitmapFont = null) {
			super(id, null, group);

			this.font = font;
		}

		override public function load(version:int = 0):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose():void {
			TextField.unregisterBitmapFont(font.name, true);

			font.dispose();
			font = null;

			dispatchEvent(new Event(Event.REMOVED));
		}

		public function get castFont():BitmapFont {
			return font;
		}
	}
}
