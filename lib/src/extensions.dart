import 'package:flutter/material.dart';

extension SpaceX on dynamic {
  dynamic get spaceX {
    return SizedBox(
      width: toDouble(),
    );
  }
}

extension SpaceY on dynamic {
  dynamic get spaceY {
    return SizedBox(
      height: toDouble(),
    );
  }
}
