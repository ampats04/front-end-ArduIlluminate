import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainController extends GetxController {
  //final isPowerOn = false.obs;
  final bathroomSliderValue = 20.0.obs;

  final isBathroomPowerOn = false.obs;
  final bathroomSecondsRemaining = 0.obs;
  final bathroomTimeSet = false.obs;
  final bathroomPaused = false.obs;
  final bathroomStarted = false.obs;
  Timer? bathroomCountDownTimer;

  final isBedroomPowerOn = false.obs;
  final bedroomSecondsRemaining = 0.obs;
  final bedroomSliderValue = 20.0.obs;
  final bedroomTimeSet = false.obs;
  final bedroomPaused = false.obs;
  final bedroomStarted = false.obs;
  Timer? bedroomCountDownTimer;
}
