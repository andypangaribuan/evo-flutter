import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'ev-animation-controller.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/10
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvUI {
  EvUI._();

  static EvUI _instance;
  static EvUI get instance {
    _instance ??= EvUI._();
    return _instance;
  }



  Widget contentSwitcher({
    @required Widget content1,
    @required Widget content2,
    AnimationController anim,
    EvAnimationController evAnim,
    CustomClipper<Path> clipper,
    Offset forwardPosition,
    Offset reversePosition,
    List<Offset> Function(AnimationController controller, Offset forwardPosition, Offset reversePosition) onBuild,
  }) {
    final animController = anim ?? evAnim?.controller;

    Offset animPosition() {
      final animStatus = animController.status;
      var position = Offset(0, 0);

      if (animStatus == AnimationStatus.forward && forwardPosition != null) {
        position = forwardPosition;
      }
      else if (animStatus == AnimationStatus.reverse && reversePosition != null) {
        position = reversePosition;
      }
      return position;
    }


    return Stack(
      children: [

        content1,

        AnimatedBuilder(
          animation: animController,
          child: content2,
          builder: (_, child) {
            if (onBuild != null) {
              final positions = onBuild(animController, forwardPosition, reversePosition);
              if (positions != null && positions.length == 2) {
                forwardPosition = positions[0];
                reversePosition = positions[1];
              }
            }

            return ClipPath(
              child: child,
              clipper: clipper ?? _ContentSwitcherClipper(
                sizeRate: animController.value,
                offset: animPosition(),
              ),
            );
          },
        ),

      ],
    );
  }


//  Widget noGestureAllowed({@required Widget child}) => GestureDetector(
//    onTap: (){},
//    onDoubleTap: (){},
//    onVerticalDragStart: (_){},
//    onHorizontalDragStart: (_){},
//    onForcePressStart: (_){},
//    onLongPressStart: (_){},
//    child: child,
//  );

  Widget noGestureAllowed({@required Widget child}) => AbsorbPointer(child: child,);


  Widget colorFilterGrayScale(Widget child) {
    final greyscale = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);

    return ColorFiltered(
      colorFilter: greyscale,
      child: child,
    );
  }


  Widget colorFilterSepia(Widget child) {
    final sepia = ColorFilter.matrix(<double>[
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0,     0,     0,     1, 0,
    ]);

    return ColorFiltered(
      colorFilter: sepia,
      child: child,
    );
  }

}






class _ContentSwitcherClipper extends CustomClipper<Path> {

  final double sizeRate;
  final Offset offset;

  _ContentSwitcherClipper({this.sizeRate, this.offset});


  @override
  Path getClip(Size size) {
    var path = Path()
      ..addOval(
        Rect.fromCircle(
          center: offset,
          radius: lerpDouble(0, _calcMaxRadius(size, offset), sizeRate),
        ),
      );

    return path;
  }


  static double _calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }


  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}
