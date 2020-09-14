import 'ev-page.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/17
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvDisposer {

  final _disposers = <void Function()>[];


  EvDisposer(EvPage page) {
    page.registerBroadcastDisposer(_dispose);
  }


  void register(void Function() event) {
    _disposers.add(event);
  }

  void _dispose() {
    _disposers.forEach((e) => e());
    _disposers.clear();
  }

}
