import 'package:rive/rive.dart';

class RiveModel {
  final String artboard, src, stateMachineName;
  late SMIBool? status;

  RiveModel(
      {required this.artboard,
      required this.src,
      required this.stateMachineName,
      this.status});
  set setStatus(SMIBool state) {
    status = state;
  }
}
