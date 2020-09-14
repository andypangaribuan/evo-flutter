import 'dart:async';

import 'ev-disposer.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/18
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvCancelableDelayed {

  Timer _timer;


  EvCancelableDelayed({EvDisposer disposer}) {
    disposer?.register(dispose);
  }


  void delay(Duration duration, void Function() callback) {
    cancel();
    if (duration != null)
      _timer = Timer(duration, callback);
  }


  void cancel() => dispose();

  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

}
