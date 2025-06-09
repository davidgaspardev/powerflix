/// External packages
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Label
/// 
/// It's a customized [Text] Widget
class Label extends Text {

  /// Text padding [EdgeInsets]
  final EdgeInsets padding;

  // Default values (this constants is used in Input too)
  static const defaultFontSize = 16.0;
  static const defaultFontStyle = FontStyle.normal;
  static const defaultFontWeight = FontWeight.normal;
  static const defaultFontFamily = "Inter";
  static const defaultFontColor = Colors.grey;

  /// Contructor
  Label(String text, {
    Key? key,
    int? maxLines,
    double? letterSpacing,
    TextOverflow? overflow,
    // Arguments with default values
    double height = 1, /** fontSize * 1 */
    Color color = defaultFontColor,
    TextAlign textAlign = TextAlign.start,
    double fontSize = defaultFontSize,
    FontStyle fontStyle = defaultFontStyle,
    FontWeight fontWeight = defaultFontWeight,
    String fontFamily = defaultFontFamily,
    this.padding = EdgeInsets.zero,
  }): super(text, 
    key: key,
    maxLines: maxLines,
    textAlign: textAlign,
    overflow: overflow,
    // Setting style to the text
    style: TextStyle(
      decoration: TextDecoration.none,
      color: color,
      height: height,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing
    )
  );

  Label.rich(LabelSpan labelSpan, {
    Key? key,
    int? maxLines,
    double? letterSpacing,
    TextOverflow? overflow,
    // Arguments with default values
    double height = 1, /** fontSize * 1 */
    TextAlign textAlign = TextAlign.start,
    double fontSize = defaultFontSize,
    String fontFamily = defaultFontFamily,
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.normal,
    Color color = defaultFontColor,
    this.padding = EdgeInsets.zero
  }): super.rich(labelSpan,
    key: key,
    maxLines: maxLines,
    textAlign: textAlign,
    overflow: overflow,
    // Setting style to the text
    style: TextStyle(
      decoration: TextDecoration.none,
      color: color,
      height: height,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing
    ),
  );

  /// Build text
  @override
  Widget build(BuildContext context) {
    // Return widget
    return Padding(
      padding: padding,
      child: super.build(context),
    );
  }
}

/// Label Span
/// It's a customized [TextSpan] Widget
class LabelSpan extends TextSpan {

  /// Contructor
  LabelSpan(String text, {
    Key? key,
    List<LabelSpan>? children,
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    String? fontFamily,
    Function()? onTap,
  }): super(
    text: text,
    children: children,
    recognizer: onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    ),
  );
}