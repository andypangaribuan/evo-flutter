import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ev-models.dart';
import 'ev-store.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/09
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
//region Context extension
extension ContextExt on BuildContext {

  void dismissKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

}
//endregion Context extension


//region Object extension
extension ObjectExt<T> on T {

  R let<R>(R Function(T it) op) => op(this);

}
//endregion Object extension


//region String Parsing extension
extension StringParsing on String {

  /// opacity ranges from 0.0 to 1.0
  Color hexColor({double opacity}) {
    final hexColor = this.replaceAll("#", "");
    var color = Color(int.parse("0xFF$hexColor"));
    color = opacity == null ? color : color.withOpacity(opacity);
    return color;
  }

}
//endregion String Parsing extension


//region String extension
extension StringExt on String {

  Future<void> get launchUrl async {
    if (await canLaunch(this)) {
      await launch(this);
    }
  }


  bool get isEmail => EvStore.regexEmail.hasMatch(toLowerCase());


  bool get isNullOrEmpty {
    if (this == null)
      return true;
    return trim().length == 0;
  }


  String get capitalCase {
    if (this == null || isEmpty || substring(0,1) == " ")
      return this;
    return "${substring(0,1).toUpperCase()}${length == 1 ? "" : substring(1)}";
  }


  String get titleCase {
    if (this == null)
      return this;

    final arr = <String>[];
    var temp = "";
    var last = "";

    for (var ch in split('')) {
      if (temp == "") {
        temp = ch;
      }
      else if ((last == " " && ch != " ") || (last != " " && ch == " ")) {
        arr.add(temp);
        temp = ch;
      }
      else {
        temp += ch;
      }

      last = ch;
    }

    if (temp != "")
      arr.add(temp);

    return arr.map((e) => e.capitalCase).join();
  }


  String get base64Encode {
    final b = utf8.fuse(base64);
    return b.encode(this);
  }


  String get base64Decode {
    final b = utf8.fuse(base64);
    return b.decode(this);
  }

}
//endregion String extension


//region Int Duration extension
extension IntDuration on int {

  Duration get millis => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);

}
//endregion Int Duration extension


//region Duration Extension
extension DurationExt on Duration {

  Future<void> delayed([void Function() callback]) => Future.delayed(this, callback);

}
//endregion Duration Extension


//region GlobalKey Extension
extension GlobalKeyExt on GlobalKey {

  EvSizePosition get sizePosition {
    RenderBox box = currentContext?.findRenderObject();
    final size = box?.size;
    final position = box?.localToGlobal(Offset.zero);

    return box == null ? null : EvSizePosition(
      width: size.width,
      height: size.height,
      dx: position.dx,
      dy: position.dy,
    );
  }
}
//endregion GlobalKey Extension


//region Map Extension
extension MapExt on Map {

  List<List<String>> toListListString(String key) {
    List<List<String>> data;

    List<dynamic> list = this[key];
    if (list != null) {
      data = List<List<String>>();
      for (var e in list) {
        final l = List<String>.from(e);
        data.add(l);
      }
    }

    return data;
  }

  double toDouble(String key) {
    double value;

    final v = this[key];
    if (v != null) {
      value = v is int ? v.toDouble() : v;
    }

    return value;
  }

}
//endregion Map Extension



//region DOUBLE EXTENSION
extension DoubleExt on double {

  String toMoney(int decimal, String thousandSeparator, String decimalSeparator, {String symbol}) {
    var res = "";
    final arr = this.toStringAsFixed(decimal).split(".");

    final n = arr[0].length;
    var count = 0;
    for (int i=n-1; i>=0; i--) {
      count++;
      res = arr[0].substring(i, i+1) + res;
      if (i>0 && count == 3) {
        count = 0;
        res = thousandSeparator + res;
      }
    }

    if (decimal > 0) {
      res += decimalSeparator + arr[1];
    }

    if (!symbol.isNullOrEmpty)
      res = "$symbol $res";

    return res;
  }

}
//endregion