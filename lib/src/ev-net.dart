import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../ev.dart';
import 'ev-models.dart';


/* ============================================
	Created by andy pangaribuan on 2020/05/20
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvNetResult {

  final Response _response;
  final DioError _error;

  static const on200n202 = [200, 202];


  EvNetResult._(this._response, this._error);


  bool get isError => _error != null;
  DioError get error => _error;

  bool get isStatusGr => statusCode == 202;
  bool get isStatusOk => statusCode == 200;
  int get statusCode => _response?.statusCode ?? -1;

  dynamic get data => _response?.data ?? null;


  Future<void> onError(callback(int code, DioError error)) async {
    if (isError || !on200n202.contains(statusCode))
      await callback(statusCode, _error);
  }

  Future<void> onGR(callback(EvNetGR gr)) async {
    if (!isError && isStatusGr)
      await callback(EvNetGR(map: data));
  }

  Future<void> onSuccess(callback(dynamic data)) async {
    if (!isError && isStatusOk)
      await callback(data);
  }

}



class EvNet {
  EvNet._();

  static EvNet _instance;
  static EvNet get instance {
    _instance ??= EvNet._();
    return _instance;
  }

  static final _mapCancelToken = Map<String, CancelToken>();
  static var _cancelAllNetwork = false;

  final connectTimeout = 1 * 10 * 1000; // 10s
  final receiveTimeout = 1 * 10 * 1000; // 10s


  Dio _dio(int connectTimeout, int receiveTimeout) {
    return Dio()
        ..options.connectTimeout = connectTimeout ?? this.connectTimeout
        ..options.receiveTimeout = receiveTimeout ?? this.receiveTimeout;
  }


  Future<void> cancelAllNetwork() async {
    _cancelAllNetwork = true;

    while (_mapCancelToken.length > 0) {
      final keys = _mapCancelToken.keys.toList();
      for (var key in keys) {
        final ct = _mapCancelToken[key];
        if (ct != null) {
          ct.cancel();
        }
      }

      for (int i=0; i<5; i++) {
        await 100.millis.delayed();
        if (_mapCancelToken.length == 0)
          break;
      }
    }

    _cancelAllNetwork = false;
  }


  Future<EvNetResult> _call(Future<Response> callback(), {CancelToken cancelToken, void Function() onFinished, List<String> onFinishedEvent}) async {
    if (_cancelAllNetwork)
      return Completer<EvNetResult>().future;

    Response res;
    DioError err;

    var ctId = "";
    while (true) {
      ctId = ev.time.micros.toStr(DateTime.now()) + " " + ev.uuid.v4();
      if (!_mapCancelToken.containsKey(ctId))
        break;
    }

    _mapCancelToken[ctId] = cancelToken;

    try {
      res = await callback();
    } on DioError catch (e) {
      err = e;
    }

    _mapCancelToken.remove(ctId);
    if (err != null && CancelToken.isCancel(err)) {
      return Completer<EvNetResult>().future;
    }

    final result = EvNetResult._(res, err);
    if (onFinished != null) {
      if (onFinishedEvent == null) {
        onFinished();
      }
      else if (onFinishedEvent.length == 0) {}
      else if (result.isError && (onFinishedEvent.contains("e") || onFinishedEvent.contains("error"))) {
        onFinished();
      }
      else if (!result.isError && result.isStatusGr && (onFinishedEvent.contains("g") || onFinishedEvent.contains("gr"))) {
        onFinished();
      }
      else if (!result.isError && result.isStatusOk && (onFinishedEvent.contains("s") || onFinishedEvent.contains("success"))) {
        onFinished();
      }
    }
    return result;
  }


  Future<EvNetResult> post({
    @required String url,
    @required dynamic data,
    Map<String, dynamic> headers,
    int connectTimeout,
    int receiveTimeout,
    bool isFormData = false,
    void Function() onFinished,
    List<String> onFinishedEvent,
  }) async {
    final cancelToken = CancelToken();
    return _call(() => _dio(connectTimeout, receiveTimeout).post(
        url,
        cancelToken: cancelToken,
        data: !isFormData ? data : FormData.fromMap(data),
        options: headers == null ? null : Options(headers: headers)),
      cancelToken: cancelToken,
      onFinished: onFinished,
      onFinishedEvent: onFinishedEvent,
    );
  }

}
