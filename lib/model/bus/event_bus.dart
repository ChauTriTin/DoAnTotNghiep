import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnBackPress {
  String className;

  OnBackPress(this.className);
}

const String mapScreen = "mapScreen";
