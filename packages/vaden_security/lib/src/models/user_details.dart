import 'package:vaden/vaden.dart';

/// Represents the details of an authenticated user.
/// - [username]: name (or identifier) of the user
/// - [password]: stored password (typically already encoded/hashed)
/// - [roles]: list of roles or assigned permissions
///
/// You can extend this class to include more information,
/// such as account locked flags, expiration date, etc.
@DTO()
class UserDetails {
  final String username;
  @JsonIgnore()
  final String password;
  final List<String> roles;

  UserDetails({
    required this.username,
    required this.password,
    required this.roles,
  });
}
