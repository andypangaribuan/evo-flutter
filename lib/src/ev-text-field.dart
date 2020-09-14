import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/15
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvTextField extends StatelessWidget {

  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final BoxShadow boxShadow;

  final EdgeInsetsGeometry textMargin;
  final EdgeInsetsGeometry textPadding;
  final TextStyle style;
  final TextAlign textAlign;
  final bool obscureText;
  final Text hintText;
  final int maxLength;
  final int maxLines;
  final bool expanded;
  final double expandedMaxHeight;

  final TextInputType keyboardType;
  final TextInputFormatter inputFormatter;
  final bool enabled;
  final FocusNode focusNode;

  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;

  final Widget leftInnerChild;
  final Widget rightInnerChild;
  final Widget topOuterChild;
  final Widget bottomOuterChild;


  EvTextField({
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,

    this.textMargin,
    this.textPadding = const EdgeInsets.only(top: 10.0, bottom: 10.0),
    this.style,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.expanded = false,
    this.expandedMaxHeight,

    this.keyboardType,
    this.inputFormatter,
    this.enabled = true,
    this.focusNode,

    this.onChanged,
    this.textEditingController,

    this.leftInnerChild,
    this.rightInnerChild,
    this.topOuterChild,
    this.bottomOuterChild,
  });


  @override
  Widget build(BuildContext context) {
    Widget getTextField() => Container(
      margin: textMargin,
      child: TextField(
        enabled: enabled,
        textAlign: textAlign,
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: expanded ? null : maxLines,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatter == null ? null : [inputFormatter],
        style: style,

        decoration: InputDecoration(
          contentPadding: textPadding,
          isDense: true,
          border: InputBorder.none,
          hintText: hintText?.data,
          hintStyle: hintText?.style,
          counterText: maxLength != null ? '' : null,
        ),

        onChanged: onChanged,
        controller: textEditingController,
      ),
    );


    Widget getContent() => Container(
      width: double.infinity,
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (leftInnerChild != null)
            leftInnerChild,

          Expanded(
            child: expandedMaxHeight == null ? getTextField() : ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: expandedMaxHeight,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: getTextField(),
                ),
              ),
            ),
          ),

          if (rightInnerChild != null)
            rightInnerChild,

        ],
      ),
    );


    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [

          if (topOuterChild != null)
            topOuterChild,

          borderRadius == null ? getContent() : Container(
            decoration: boxShadow == null ? null : BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              boxShadow: [boxShadow],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: getContent(),
            ),
          ),

          if (bottomOuterChild != null)
            bottomOuterChild,

        ],
      ),
    );
  }

}