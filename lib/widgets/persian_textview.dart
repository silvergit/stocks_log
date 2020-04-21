import 'package:flutter/material.dart';

class TextFa extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlignFa;
  final TextAlign textAlignEn;
  final Color fontColor;
  final bool moneyFormat;

  TextFa(this.text,
      {this.fontSize,
      this.textAlignFa = TextAlign.center,
      this.textAlignEn = TextAlign.center,
      this.fontColor,
      this.moneyFormat = false});

  @override
  Widget build(BuildContext context) {
    return moneyFormat
        ? Text(
            text,
            style: TextStyle(
                fontFamily: 'vazir', fontSize: fontSize, color: fontColor),
            textDirection: TextDirection.ltr,
            textAlign: textAlignFa,
          )
        : Text(
            text,
            style: TextStyle(
                fontFamily: 'vazir', fontSize: fontSize, color: fontColor),
            textDirection: TextDirection.ltr,
            textAlign: textAlignFa,
          );
  }
}
