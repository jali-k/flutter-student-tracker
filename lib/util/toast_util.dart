


import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

class ToastUtil{

  static void showErrorToast(BuildContext context, String errorMessage, String errorDescription,{
    Alignment alignment = Alignment.bottomCenter,
  }){
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(errorMessage),
      description: Text(errorDescription),
      alignment: alignment,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

}