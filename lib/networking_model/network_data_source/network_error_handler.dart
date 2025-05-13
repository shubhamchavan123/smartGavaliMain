
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:smart_gawali/core/error_handaling/custom_exception.dart';
import 'package:smart_gawali/core/error_handaling/error_constants.dart';

CustomException responseErrorHandler(e) {
  if(e is SocketException ) {
    debugPrint('resnponse Error handler ${e.toString()}');
    return NetworkErrorException(ErrorMessage.networkErrorExceptionMsg);
  }  if (e is TimeOutException){
    debugPrint('resnponse Error handler ${e.toString()}');
    return TimeOutException(ErrorMessage.timeOutExceptionMsg);
  }  if (e is FormatException){
    debugPrint('resnponse Error handler ${e.toString()}');
    return TimeOutException(ErrorMessage.formatExceptionMsg);
  }  if (e is CustomException){
    debugPrint('resnponse Error handler ${e.toString()}');
    return CustomException(ErrorMessage.formatExceptionMsg);
  }
  return UnKnownException(e.toString());
}