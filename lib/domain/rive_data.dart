import 'package:rive/rive.dart';

class RiveData {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveData(
      this.src, {
        required this.artboard,
        required this.stateMachineName,
        required this.title,
        this.input,
      });

  set setInput(SMIBool status) {
    input = status;
  }
}