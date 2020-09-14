import 'package:flutter/material.dart';

import 'ev-disposer.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/18
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvObjectDisposer<T> {

  T object;


  EvObjectDisposer(this.object, {@required EvDisposer disposer}) {
    disposer?.register(dispose);
  }


  void dispose() {
    if (object == null)
      return;

    if (object is FocusNode) {
      (object as FocusNode).dispose();
      return;
    }

    if (object is PageController) {
      (object as PageController).dispose();
      return;
    }
  }

}
