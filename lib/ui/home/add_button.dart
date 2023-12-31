import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/main_button.dart';

class AddButton extends MainButton {
  AddButton({super.key}) : super(image: Icons.add, description: "Add") ;

  @override
  void onTap() {
    super.onTap();

    log("custom tapping");
  }
}