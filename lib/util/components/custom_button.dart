import 'package:flutter/material.dart';

import '../../config/constants.dart';

enum CustomButtonStyle { filled48, filled32, outline48, outline32 }

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.customButtonStyle,
    required this.text,
    this.color,
    this.width,
    this.isOk = true,
    this.borderRadius,
    required this.onTap,
  }) : super(key: key);

  final CustomButtonStyle customButtonStyle;
  final String text;
  final Color? color;
  final double? width;
  final bool isOk;
  final BorderRadius? borderRadius;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isOk ? this.color ?? $style.colors.primary : $style.colors.grey;
    Color borderColor = color;

    late final Color fillColor;
    late final Color fontColor;
    late final double fontSize;
    FontWeight? fontWeight;
    late final double height;

    switch (customButtonStyle) {
      case CustomButtonStyle.filled48:
        fillColor = color;
        fontColor = Colors.white;
        fontSize = 16 * sizeUnit;
        height = 48 * sizeUnit;
        break;
      case CustomButtonStyle.filled32:
        fillColor = color;
        fontColor = Colors.white;
        fontSize = 13 * sizeUnit;
        height = 32 * sizeUnit;
        break;
      case CustomButtonStyle.outline48:
        fillColor = Colors.white;
        fontColor = color;
        fontSize = 16 * sizeUnit;
        if (color == $style.colors.grey) {
          fontWeight = FontWeight.w500;
          borderColor = $style.colors.grey;
        }
        height = 48 * sizeUnit;
        break;
      case CustomButtonStyle.outline32:
        fillColor = Colors.white;
        fontColor = color;
        fontSize = 13 * sizeUnit;
        if (color == $style.colors.grey) {
          fontWeight = FontWeight.w500;
          borderColor = $style.colors.grey;
        }
        height = 32 * sizeUnit;
        break;
    }

    TextStyle textStyle = $style.text.headline16.copyWith(
      color: fontColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    return Theme(
      data: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: color)),
      child: TextButton(
        onPressed: isOk ? onTap : null,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular($style.corners.$8),
              side: BorderSide(color: borderColor),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(fillColor),
          minimumSize: MaterialStateProperty.all(Size(width ?? double.infinity, height)),
          fixedSize: MaterialStateProperty.all(Size(width ?? double.infinity, height)),
          alignment: Alignment.center,
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}
