import 'dart:developer' as developer;

import 'package:encrypt/encrypt.dart' as ecy;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'ev-global-event.dart';
import 'ev-net.dart';
import 'ev-popup.dart';
import 'ev-ui.dart';


/* ============================================
	Created by andy pangaribuan on 2020/04/02
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
final ev = _EvMain._();


class _EvMain {
  _EvMain._();

  final _logger = _Logger._();

  final size = _Size._();
  final func = _Func._();
  final time = _Time._();
  final net = EvNet.instance;
  final ui = EvUI.instance;
  final popup = EvPopUp.instance;
  final globalEvent = _GlobalEvent._();
  final security = _Security._();
  final uuid = _UUID._();


  /*
  * install "grep console" plugin for android studio or intellij ide
  * in your console, click "pen icon" with white and red color on left top corner
  * click button "new group", give the name "evo"
  * add the expressions:
  * - .*─.*
  * - .*│.*
  * set the background color: #004444
  * set the foreground color: #FFFFFF
  * tick only on: whole line, continue matching, background and foreground
  **/
  void log(List<String> messages) => _logger.log(messages);

}




//region GLOBAL EVENT
class _GlobalEvent {
  _GlobalEvent._();

  void fire() => EvGlobalEvent.fire();
}
//endregion GLOBAL EVENT




//region SIZE
class _Size {
  _Size._();

  final double toolbarHeight = kToolbarHeight;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  final double buttonHeight = 40.0;

  double _safeAreaHeight = 0.0;
  double get safeAreaHeight => _safeAreaHeight;
  set safeAreaHeight(double value) {
    if (value > _safeAreaHeight)
      _safeAreaHeight = value;
  }

}
//endregion SIZE





//region FUNC
class _IsInstanceTypeOf<T> {}

class _Func {
  _Func._();


  bool isTypeOf<ThisType, OfType>() => _IsInstanceTypeOf<ThisType>() is _IsInstanceTypeOf<OfType>;

  void forceDismissKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.hide');

  void pageBack(BuildContext context, {Object result}) => Navigator.of(context).pop(result);

  Future<T> pageOpen<T>(BuildContext context, Widget page) async =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void pageOpenAndRemovePrevious(BuildContext context, Widget page) =>
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), ModalRoute.withName(''));

}
//endregion FUNC





//region LOGGER
class _Logger {
  _Logger._();

  static final _deviceStackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
  static final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');


  void log(List<String> messages) => developer.log(_getLogMessage(messages));


  String _getLogMessage(List<String> messages) {
    int maxLength = 0;
    final arr = <String>[];
    arr.add("      " + ev.time.millis.toStr(DateTime.now()));
    maxLength = arr[0].length;

    final mc = methodCaller(StackTrace.current);
    if (mc != null) {
      final m = "│ ▶ " + mc;
      arr.add(m);
      if (m.length > maxLength) {
        maxLength = m.length;
      }
    }

    for (var msg in messages) {
      final m = "│ ◈ " + msg;
      arr.add(m);
      if (m.length > maxLength) {
        maxLength = m.length;
      }
    }
    maxLength += 3;


    // characters: https://en.wikipedia.org/wiki/List_of_Unicode_characters
    var log = "";
    for (int i=0; i<arr.length; i++) {
      if (i == 0) {
        var ch = _addChar(arr[i] + " ", "─", maxLength - 1) + "┐";
        log += ch.trim();
      }
      else if (arr[i].contains("│ ▶ ")) {
        log += _addChar("\n" + arr[i] + " ", " ", maxLength) + "│";
      }
      else {
        final ch = arr[i];
        final chs = ch.split("\n");
        for (var c in chs) {
          final first = c.contains("│ ◈ ") ? "\n" : "\n│   ";
          log += _addChar(first + c + " ", " ", maxLength) + "│";
        }
      }
    }
    log += "\n" + _addChar("└", "─", maxLength - 1) + "┘";

    return log;
  }

  String _addChar(String value, String ch, int maxLength) {
    var v = value;
    while (true) {
      if (v.length >= maxLength)
        break;
      v += ch;
    }
    return v;
  }

  String methodCaller(StackTrace stackTrace) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    var methodCount = 1;
    var skip = 3;

    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) || _discardWebStacktraceLine(line)) {
        continue;
      }

      if (skip > 0) {
        skip--;
      } else {
        formatted.add(line.replaceFirst(RegExp(r'#\d+\s+'), ''));
        if (++count == methodCount) {
          break;
        }
      }
    }

    if (formatted.length > 0) {
      return formatted[0];
    }
    return null;
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2).startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1).startsWith('packages/logger') || match.group(1).startsWith('dart-sdk/lib');
  }

}
//endregion LOGGER





//region TIME
class _Time {
  _Time._();

  final _util = _TimeUtil();

  final date = _TimeUtil().._format = "yyyy-MM-dd";
  final time = _TimeUtil().._format = "HH:mm:ss";
  final dt = _TimeUtil().._format = "yyyy-MM-dd HH:mm:ss";
  final millis = _TimeUtil().._format = "yyyy-MM-dd HH:mm:ss.SSS";
  final micros = _TimeUtil().._format = "yyyy-MM-dd HH:mm:ss.SSSSSS";


  DateTime get now => DateTime.now();
  DateTime get nowUtc => DateTime.parse(DateTime.now().toUtc().toString().replaceAll("Z", "").replaceAll("z", ""));


  String toStr(String format, DateTime dt) => _util._toStr(format, dt);

}


class _TimeUtil {

  static final mapDateFormat = Map<String, DateFormat>();
  String _format;


  DateTime toTime(String dt) => dt == null ? null : DateTime.parse(dt.replaceAll("T", " ").replaceAll("Z", "").replaceAll("z", ""));

  String toStr(DateTime dt) => dt == null ? null : _toStr(_format, dt);

  String _toStr(String format, DateTime dt) {
    final msCount = countMs(format);
    if (msCount == 0) {
      if (!mapDateFormat.containsKey(format)) {
        mapDateFormat[format] = DateFormat(format);
      }
      return mapDateFormat[format].format(dt);
    }

    final date = dt.toIso8601String().replaceAll("T", " ").replaceAll("Z", "").replaceAll("z", "");
    final arr = date.split(".");
    var ms = "";
    if (arr.length == 2) {
      ms = arr[1];
    }

    if (ms.length > msCount) {
      ms = ms.substring(0, msCount);
    }

    while (true) {
      if (ms.length == msCount)
        break;
      ms += "0";
    }

    return arr[0] + "." + ms;
  }

  int countMs(String format) {
    var msCount = 0;

    final fs = format.split(".");
    if (fs.length == 2) {
      final f = fs[1];
      for (int i=0; i<f.length; i++) {
        final ch = f.substring(i, i+1);
        if (ch == "S") {
          msCount++;
        }
      }
    }

    return msCount;
  }

}
//endregion TIME





//region SECURITY
class _Security {
  _Security._();

  final aes = _SecurityAES._();
}


class _SecurityAES {
  _SecurityAES._();

  final Map<String, ecy.Encrypter> encrypters = {};

  /// key must be 32 length
  ecy.Encrypter _encrypter(String key) {
    var encrypter = encrypters[key];
    if (encrypter == null) {
      encrypter = ecy.Encrypter(ecy.AES(ecy.Key.fromUtf8(key), mode: ecy.AESMode.sic));
      encrypters[key] = encrypter;
    }
    return encrypter;
  }

  /// key must be 32 length
  ecy.Encrypted encrypt(String key, String value) {
    return _encrypter(key).encrypt(value);
  }

}
//endregion SECURITY





//region UUID
class _UUID {
  _UUID._();
  final _uuid = Uuid();

  String v4() => _uuid.v4();

}
//endregion UUID
