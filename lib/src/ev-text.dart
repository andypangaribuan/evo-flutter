import 'package:flutter/material.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/15
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvText extends StatelessWidget {

  final String text;
  final double width;
  final EdgeInsetsGeometry margin;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;


  EvText(
    this.text,
    {
      this.width,
      this.margin,
      this.style,
      this.textAlign,
      this.maxLines,
    });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: Text(text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }

}