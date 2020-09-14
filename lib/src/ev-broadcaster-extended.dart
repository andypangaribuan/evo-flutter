import 'package:flutter/material.dart';

import 'ev-broadcaster.dart';
import 'ev-cancelable-delayed.dart';
import 'ev-disposer.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/24
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvBroadcasterError<A, B> {
  final EvBroadcaster<A> broadcaster;
  final EvBroadcaster<B> errorBroadcaster;

  EvBroadcasterError({@required this.broadcaster, @required this.errorBroadcaster, EvDisposer disposer}) {
    disposer?.register(dispose);
  }

  void dispose() {
    broadcaster?.dispose();
    errorBroadcaster?.dispose();
  }
}


class EvBroadcasterErrorDelayed<A, B> {
  final EvBroadcaster<A> broadcaster;
  final EvBroadcaster<B> errorBroadcaster;
  final EvCancelableDelayed delayed;

  EvBroadcasterErrorDelayed({@required this.broadcaster, @required this.errorBroadcaster, @required this.delayed, EvDisposer disposer}) {
    disposer?.register(dispose);
  }

  void dispose() {
    broadcaster?.dispose();
    errorBroadcaster?.dispose();
    delayed?.dispose();
  }
}
