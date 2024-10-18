// import 'dart:convert';

// import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
// import 'package:flutter/foundation.dart';

// import 'car_model.dart';

// class CarListModel extends CarListEntity {
//   final String message;
//   final List<CarModel> data;
//   CarListModel({
//     required this.message,
//     required this.data,
//   }) : super(message: '', data: []);

//   CarListModel copyWith({
//     String? message,
//     List<CarModel>? data,
//   }) {
//     return CarListModel(
//       message: message ?? this.message,
//       data: data ?? this.data,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'message': message,
//       'data': data.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory CarListModel.fromMap(Map<String, dynamic> map) {
//     return CarListModel(
//       message: map['message'] as String,
//       data: List<CarModel>.from(
//         (map['data'] as List<int>).map<CarModel>(
//           (x) => CarModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory CarListModel.fromJson(String source) =>
//       CarListModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'CarListModel(message: $message, data: $data)';

//   @override
//   bool operator ==(covariant CarListModel other) {
//     if (identical(this, other)) return true;

//     return other.message == message && listEquals(other.data, data);
//   }

//   @override
//   int get hashCode => message.hashCode ^ data.hashCode;
// }
