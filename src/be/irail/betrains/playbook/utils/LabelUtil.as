package be.irail.betrains.playbook.utils {

	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextLineMetrics;

	import mx.core.FlexGlobals;
	import mx.core.UITextFormat;
	import mx.styles.CSSStyleDeclaration;

	import spark.components.Label;

	public class LabelUtil {

		public static function constrainTextToWidth(label:Label):void {
			var fontSize:Number = label.getStyle("fontSize") as Number;
			label.setStyle("fontSize", fontSize);

			label.invalidateSize();
			label.validateNow();

			while ((getTextWidth(label.text, fontSize, label.styleDeclaration) > label.width) && fontSize > 0) {
				fontSize = fontSize - 0.5;
				label.setStyle("fontSize", fontSize);
			}

		}

		public static function getTextWidth(text:String, fontSize:Number, style:CSSStyleDeclaration):Number {
			var textFormat:UITextFormat = new UITextFormat(FlexGlobals.topLevelApplication.systemManager,
														   style.getStyle("fontFamily"),
														   fontSize,
														   style.getStyle("color"),
														   style.getStyle("fontWeight") == "bold",
														   style.getStyle("fontStyle") == "italic",
														   null,
														   null,
														   null,
														   style.getStyle("textAlign"),
														   style.getStyle("paddingLeft"),
														   style.getStyle("paddingRight"),
														   style.getStyle("textIndent"),
														   null);

			textFormat.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			textFormat.gridFitType = flash.text.GridFitType.PIXEL;

			var textMetrics:TextLineMetrics = textFormat.measureText(text);
			return textMetrics.width + 20;
		}
	}
}