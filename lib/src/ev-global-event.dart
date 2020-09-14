import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


/* ============================================
	Created by andy pangaribuan on 2020/04/02
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvGlobalEvent {

  // ignore: close_sinks
  static final _broadcaster = BehaviorSubject();

  static void fire() => _broadcaster.sink.add(null);

  Widget onUpdate(Widget Function() listener) {
    return StreamBuilder(
      stream: _broadcaster.stream,
      builder: (_, __) => listener(),
    );
  }

}