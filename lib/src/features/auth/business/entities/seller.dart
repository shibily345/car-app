class SellerEntity {
  final String id;
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final String dealershipName;
  final String location;
  final String contactNumber;

  const SellerEntity({
    required this.uid,
    required this.id,
    required this.location,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.dealershipName,
    required this.contactNumber,
  });
}
