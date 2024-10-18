class UserEntity {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });
}
