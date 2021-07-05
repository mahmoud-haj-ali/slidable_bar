import 'dart:async';

class SlidableBarController {
  final bool initialStatus;

  SlidableBarController({this.initialStatus = false}) : currentStatus = initialStatus;

  bool currentStatus;
  StreamController<bool> _barStatus = StreamController<bool>.broadcast();

  Stream<bool> get statusStream => _barStatus.stream;

  hide() {
    currentStatus = false;
    _barStatus.add(currentStatus);
  }

  show() {
    currentStatus = true;
    _barStatus.add(currentStatus);
  }

  reverseStatus() {
    currentStatus = !currentStatus;
    _barStatus.add(currentStatus);
  }

  dispose() {
    _barStatus.close();
  }
}