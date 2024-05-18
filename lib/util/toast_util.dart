


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtil{

  static void showErrorToast(BuildContext context, String errorMessage, String errorDescription,{
    Alignment alignment = Alignment.topRight,
  }){
    toastification.show(
      context: context,
      type: ToastificationType.error,
        style: ToastificationStyle.flatColored,

        title: Text(errorMessage, style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16
        )),
        description: Text(errorDescription, style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14
        )),
        alignment: alignment,
        autoCloseDuration: const Duration(seconds: 4),
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none
    );
  }

  static void showSuccessToast(BuildContext context, String successMessage, String messageDescription,{
    Alignment alignment = Alignment.topRight,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,

      title: Text(successMessage, style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 16
      )),
      description: Text(messageDescription, style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14
      )),
      alignment: alignment,
      autoCloseDuration: const Duration(seconds: 4),
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none
    );
  }

}