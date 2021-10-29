import 'package:flutter/material.dart';

InputDecoration ProfileFormTextInputDecoration(
    {required String forhintText, required String forlabelText}) {
  return InputDecoration(
    hintText: forhintText,
    labelText: forlabelText,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
          color: Colors.lightBlueAccent, width: 1.0, style: BorderStyle.solid),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
          color: Colors.lightBlue, width: 2.0, style: BorderStyle.solid),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
          color: Colors.redAccent, width: 1.0, style: BorderStyle.solid),
    ),
  );
}
