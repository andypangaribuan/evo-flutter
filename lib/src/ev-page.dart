import 'package:flutter/material.dart';

import 'ev-global-event.dart';
import 'ev.dart';
import 'ev-disposer.dart';
import 'ev-extensions.dart';
import 'ev-page-logic.dart';


/* ============================================
	Created by andy pangaribuan on 2020/04/02
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
abstract class EvPage<T extends EvPageLogic> extends StatefulWidget {

  final _func = _EvPageFunc();
  final _globalEvent = EvGlobalEvent();
  final evSize = _EvSize();
  final evConf = _EvConf();

  T get logic => _func.pageLogic;
  BuildContext get context => _func.getObject("context", null);
  EvDisposer get disposer => EvDisposer(this);


  EvPage() {
    evSize._page = () => this;
    _func.evConf = evConf;
  }


  @override
  State<StatefulWidget> createState() => _EvPageState();

  @protected
  void initState(){}

  @protected
  void layoutLoaded(){}

  @protected
  Widget buildLayout(BuildContext context);

  @protected
  void setLogic(T logic) {
    _func.pageLogic = logic;
    _func.pageLogic.createAnimationController = (duration) => _func.getObject("create-animation-controller", duration);
    _func.pageLogic.createTabController = (length) => _func.getObject("create-tab-controller", length);
    _func.pageLogic.pageFunc.getObject = (key, [v1]) {
      switch (key) {
        case "page": return this;
      }
      return null;
    };
  }


  @protected
  Widget globalEvent(Widget Function() listener) => _globalEvent.onUpdate(listener);

  void dismissKeyboard() => context.dismissKeyboard();

  void registerBroadcastDisposer(void Function() event) => _func.broadcastDisposerEvent = event;


  void dispose(){}

}



class _EvPageState<T extends StatefulWidget> extends State<EvPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//  class _EvPageState<T extends StatefulWidget> extends State<EvPage> with SingleTickerProviderStateMixin {

  EvPage get page => widget;


  @override
  void initState() {
    super.initState();
    page.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      page._func.pageLogic.onLayoutLoaded();
      page.layoutLoaded();
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    loadEv(context);

    page._func.getObject = (key, v1) {
      switch (key) {
        case "context": return context;
        case "create-animation-controller": return AnimationController(duration: v1, vsync: this);
        case "create-tab-controller": return TabController(length: v1, vsync: this);
        default: return null;
      }
    };

    page._func.pageLogic.onBuildLayout();
    return page.buildLayout(context);
  }


  void loadEv(BuildContext context) {
    if (ev.size.screenHeight == 0) {
      final mq = MediaQuery.of(context);
      ev.size.screenWidth = mq.size.width;
      ev.size.screenHeight = mq.size.height;
    }
  }


  @override
  void dispose() {
    page._func.broadcastDisposerEvent?.call();
    page.dispose();
    page._func.pageLogic?.dispose();
    super.dispose();
  }


  @override
  bool get wantKeepAlive => page._func.evConf.keepPageAlive;

}



class _EvPageFunc {


  void Function() broadcastDisposerEvent;
  Object Function(String key, Object v1) getObject = (_, __) => null;
  EvPageLogic pageLogic;
  _EvConf evConf;

}


class _EvSize {
  EvPage Function() _page;

  double get paddingTop => MediaQuery.of(_page().context).padding.top;
  double get paddingBottom => MediaQuery.of(_page().context).padding.bottom;
}



class _EvConf {

  bool keepPageAlive = false;

}
