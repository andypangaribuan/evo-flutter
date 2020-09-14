import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


/* ============================================
	Created by andy pangaribuan on 2020/04/09
	Copyright (c) andypangaribuan. All rights reserved.
   ============================================ */
class EvImageView {

  static Widget svg(String path, {double width, double height, BoxFit fit, Color color, Alignment alignment}) {
    return SvgPicture.asset(path,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: fit ?? BoxFit.contain,
      color: color,
      alignment: alignment ?? Alignment.center,
    );
  }


  static Widget file(File file, {double width, double height, BoxFit fit, Color color, Alignment alignment}) {
    return Image.file(file,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: fit ?? BoxFit.contain,
      color: color,
      alignment: alignment ?? Alignment.center,
    );
  }


  static Widget asset(String path, {double width, double height, BoxFit fit, Color color, Alignment alignment, BlendMode colorBlendMode}) {
    return Image.asset(path,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: fit ?? BoxFit.contain,
      color: color,
      alignment: alignment ?? Alignment.center,
      colorBlendMode: colorBlendMode,
    );
  }


  static Widget network(String url, {double width, double height, BoxFit fit, Color color, Alignment alignment, Widget errorIcon}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: fit ?? BoxFit.contain,
      color: color,
      alignment: alignment ?? Alignment.center,
      placeholder: errorIcon == null ? null : (context, url) => CircularProgressIndicator(),
      errorWidget: errorIcon == null ? null : (context, url, error) => errorIcon,
    );
  }

}