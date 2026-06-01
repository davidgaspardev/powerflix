import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Label extends Text {
  final EdgeInsets padding;

  static const defaultFontSize = 16.0;
  static const defaultFontStyle = FontStyle.normal;
  static const defaultFontWeight = FontWeight.normal;
  static const defaultFontFamily = 'Inter';
  static const defaultFontColor = Colors.grey;

  Label(
    super.text, {
    super.key,
    super.maxLines,
    double? letterSpacing,
    super.overflow,
    double height = 1,
    Color color = defaultFontColor,
    TextAlign textAlign = TextAlign.start,
    double fontSize = defaultFontSize,
    FontStyle fontStyle = defaultFontStyle,
    FontWeight fontWeight = defaultFontWeight,
    String fontFamily = defaultFontFamily,
    this.padding = EdgeInsets.zero,
  }) : super(
          textAlign: textAlign,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: color,
            height: height,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontStyle: fontStyle,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
          ),
        );

  Label.rich(
    super.textSpan, {
    super.key,
    super.maxLines,
    double? letterSpacing,
    super.overflow,
    double height = 1,
    TextAlign textAlign = TextAlign.start,
    double fontSize = defaultFontSize,
    String fontFamily = defaultFontFamily,
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.normal,
    Color color = defaultFontColor,
    this.padding = EdgeInsets.zero,
  }) : super.rich(
          textAlign: textAlign,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: color,
            height: height,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontStyle: fontStyle,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: super.build(context));
  }
}

class LabelSpan extends TextSpan {
  LabelSpan(
    String text, {
    List<LabelSpan>? children,
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    String? fontFamily,
    Function()? onTap,
  }) : super(
          text: text,
          children: children,
          recognizer:
              onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontStyle: fontStyle,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ),
        );
}
