import 'package:equatable/equatable.dart';

class ResponseEntity extends Equatable {
  final bool? status;
  final String? message;

  const ResponseEntity({
    this.status,
    this.message,
  });

  @override
  List<Object?> get props {
    return [
      status,
      message,
    ];
  }
}
