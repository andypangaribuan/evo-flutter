import 'package:flutter/material.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/17
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvSizePosition {

  double width;
  double height;
  double dx;
  double dy;


  EvSizePosition({this.width, this.height, this.dx, this.dy});


  double get centerX {
    if (width == null || dx == null)
      return null;
    return dx + (width / 2);
  }

  double get centerY {
    if (height == null || dy == null)
      return null;
    return dy + (height / 2);
  }

  Offset get center => Offset(centerX, centerY);

}


class EvNetGR {

  int code;
  String message;
  dynamic data;

  EvNetGR({Map<String, dynamic> map}) {
    if (map != null) {
      code = map["code"];
      message = map["message"];
      data = map["data"];
    }
  }

}
