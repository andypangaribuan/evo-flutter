import 'package:flutter/material.dart';

import 'ev.dart';
import 'ev-extensions.dart';


/* ============================================
	Created by andy pangaribuan on 2020/04/02
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
abstract class EvPageLogic<T> { // T must be extend from class EvPage

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool canPopPage = true;

  final pageFunc = _EvPageLogicFunc._();

  BuildContext get context => scaffoldKey.currentContext;
  T get page => pageFunc.getObject("page");

  Future<bool> onWillPop() async {
    return canPopPage;
  }

  AnimationController Function(Duration duration) createAnimationController;
  TabController Function(int length) createTabController;


  void onBuildLayout(){}

  void onLayoutLoaded(){}


  void pageBack({Object result}) =>
      ev.func.pageBack(context, result: result);

  Future<T> pageOpen<T>(Widget page) async =>
      ev.func.pageOpen(context, page);

  void pageOpenAndRemovePrevious(Widget page) =>
      ev.func.pageOpenAndRemovePrevious(context, page);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(String message, {int duration, Widget widgetRight}) =>
      ev.popup.snackBar(scaffoldKey, message, duration: duration, widgetRight: widgetRight);

  void dismissKeyboard() =>
      context.dismissKeyboard();


  void dispose(){}

}


class _EvPageLogicFunc {
  _EvPageLogicFunc._();

  Object Function(String key, [Object v1]) getObject = (_, [__]) => null;

}
