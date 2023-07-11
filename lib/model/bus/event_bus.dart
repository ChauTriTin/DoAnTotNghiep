import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnBackPress {
  String className;

  OnBackPress(this.className);
}

class OnRateSuccess {
  String className;

  OnRateSuccess(this.className);
}

const String mapScreen = "mapScreen";
const String mainScreen = "mainScreen";
