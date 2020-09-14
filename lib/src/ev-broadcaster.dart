import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'ev.dart';
import 'ev-disposer.dart';
import 'ev-extensions.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/20
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvBroadcaster<T> {

  final _broadcaster = BehaviorSubject<T>();

  TextEditingController textEditingController;
  StreamSubscription _eventSubscription;

  void Function(T val) _subscriptionListener;
  var subscriptionSkippedCount = 0;
  var _disposed = false;

  Function(T) get update => _broadcaster.sink.add;
  T get value => _broadcaster.value;



  EvBroadcaster({T initValue, bool withTextEditingController = false, EvDisposer disposer}) {
    disposer?.register(dispose);
    if (initValue != null) {
      update(initValue);

      if (initValue is String && withTextEditingController) {
        textEditingController = TextEditingController(text: initValue);
      }
    }
  }



  void subscribe({@required void listener(T val), int skippedCount = 0}) {
    if (_disposed)
      return;

    _subscriptionListener = listener;
    subscriptionSkippedCount = skippedCount < 0 ? 0 : skippedCount;
    _eventSubscription?.cancel();
    _eventSubscription = _broadcaster.listen(_subscriptionEvent);
  }


  void _subscriptionEvent(T value) {
    if (_disposed)
      return;

    if (subscriptionSkippedCount == 0 && _subscriptionListener != null)
      _subscriptionListener(value);
    else if (subscriptionSkippedCount > 0)
      subscriptionSkippedCount--;
  }


  void callSubscriber() {
    if (_disposed)
      return;

    _subscriptionListener(value);
  }

  void forceCallSubscriber() {
    if (_disposed)
      return;

    _subscriptionListener?.call(value);
  }


  Widget onUpdate(Widget listener(T val)) {
    if (_disposed)
      return Container();

    return StreamBuilder<T>(
      stream: _broadcaster.stream,
      initialData: value,
      builder: (context, snap) => listener(snap.data),
    );
  }


  void updateText(String text) {
    if (_disposed)
      return;

    textEditingController?.let((it) => it
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length));

    if (ev.func.isTypeOf<T, String>())
      update(text as T);
  }


  void softUpdate(T val) {
    if (_disposed)
      return;

    if (value != val)
      update(val);
  }

  void softUpdateText(String text) {
    if (_disposed)
      return;

    if (textEditingController != null && textEditingController.text != text)
      textEditingController
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length);

    if (ev.func.isTypeOf<T, String>() && value != (text as T))
      update(text as T);
  }


  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _eventSubscription?.cancel();
      _broadcaster.close();
    }
  }

}
