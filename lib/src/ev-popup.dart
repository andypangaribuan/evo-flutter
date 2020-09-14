import 'package:flutter/material.dart';

import 'ev-broadcaster.dart';
import 'ev-enums.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/10
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvPopUp {
  EvPopUp._();

  static EvPopUp _instance;
  static EvPopUp get instance {
    if (_instance == null)
      _instance = EvPopUp._();
    return _instance;
  }





  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(GlobalKey<ScaffoldState> scaffoldKey, String message, {int duration, Widget widgetRight}) {
    message = message ?? "";
    duration = duration ?? 4000;

    SnackBar snackBar;
    if (widgetRight == null) {
      snackBar = SnackBar(
        duration: Duration(milliseconds: duration),
        content: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Text(message),
        ),
      );
    }
    else {
      snackBar = SnackBar(
        duration: Duration(milliseconds: duration),
        content: Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(message),
              ),
              widgetRight,
            ],
          ),
        ),
      );
    }

    return scaffoldKey.currentState.showSnackBar(snackBar);
  }



  Future<T> container<T>({
    @required BuildContext context,
    barrierDismissible: false, //prevent closing on outside touch
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    Function onWillPop,
    @required Widget child,
    EvPopupContainerAlignment alignment = EvPopupContainerAlignment.Center,
    Color barrierColor,
    EvBroadcaster<bool> hideBroadcaster,
  }) async {
    hideBroadcaster ??= EvBroadcaster<bool>(initValue: false);

    Widget spacer() => Expanded(
      child: GestureDetector(
        child: Container(),
        onTap: () {
          if (barrierDismissible)
            Navigator.pop(context);
        },
      ),
    );


    Widget content() => hideBroadcaster.onUpdate((hidden) => hidden ? Container() : GestureDetector(
      child: Container(
        color: barrierColor ?? Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Builder(
            builder: (context) => Dialog(
              elevation: 0,
              insetPadding: margin,
              backgroundColor: Colors.transparent,
              child: (){
                switch (alignment) {
                  case EvPopupContainerAlignment.Top: return Column(children: [child, spacer()]);
                  case EvPopupContainerAlignment.Center: return child;
                  case EvPopupContainerAlignment.Bottom: return Column(children: [spacer(), child]);
                }
                return child;
              }(),
            ),
          ),
        ),
      ),
      onTap: () {
        if (barrierDismissible)
          Navigator.pop(context);
      },
    ));


    final result = await showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) => content(),
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );


    hideBroadcaster.dispose();
    onWillPop?.call();
    return result;
  }

}
