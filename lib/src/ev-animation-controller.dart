import 'dart:async';

import 'package:flutter/animation.dart';

import 'ev-disposer.dart';
import 'ev-page-logic.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/17
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvAnimationController {

  AnimationController controller;
  bool isBusy = false;
  AnimationStatusListener listener;


  EvAnimationController(EvPageLogic pageLogic, Duration duration, {EvDisposer disposer}) {
    disposer?.register(dispose);
    controller = pageLogic.createAnimationController(duration);
    controller.addStatusListener((status) {
      isBusy = status == AnimationStatus.reverse || status == AnimationStatus.forward;
      if (listener != null)
        listener(status);
    });
  }


  void addStatusListener(AnimationStatusListener listener) => this.listener = listener;

  Future<void> startAnimation() async {
    isBusy = true;
    final c = Completer();

    final animStatus = controller.status;
    if (animStatus == AnimationStatus.forward || animStatus == AnimationStatus.completed) {
      controller.reverse().whenCompleteOrCancel(() {
        c.complete();
      });
    } else {
      controller.forward().whenCompleteOrCancel(() {
        c.complete();
      });
    }

    return c.future;
  }


  void dispose() {
    controller.dispose();
  }

}
