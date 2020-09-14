import 'package:flutter/material.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/09
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvContainer extends StatelessWidget {

  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final Widget child;
  final void Function() onTap;
  final Color backgroundColor;
  final Color splashColor;
  final Color highlightColor;
  final BorderRadius borderRadius;
  final alignment;
  final BoxShadow boxShadow;


  EvContainer({
    Key key,

    this.margin,
    this.padding,
    this.width,
    this.height,
    this.child,
    this.onTap,
    this.backgroundColor,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
    this.alignment,
    this.boxShadow,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Widget build() {
      return Container(
        width: width,
        height: height,
        margin: margin,
        color: borderRadius != null ? null : backgroundColor,
        decoration: borderRadius == null ? null : BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: boxShadow == null ? null : [boxShadow],
        ),
        child: Stack(
          children: [

            borderRadius == null
              ? Container(
                  color: backgroundColor,
                  padding: padding,
                  child: child,
                )
              : Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius,
                  ),
                  child: child == null ? null : ClipRRect(
                    borderRadius: borderRadius,
                    child: child,
                  ),
                ),

            if (onTap != null)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  borderRadius: borderRadius,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: splashColor ?? Theme.of(context).splashColor,
                    highlightColor: highlightColor ?? Theme.of(context).highlightColor,
                  ),
                )
              ),

          ],
        ),
      );
    }


    return alignment == null ? build() : Align(
      alignment: alignment,
      child: build(),
    );
  }

}