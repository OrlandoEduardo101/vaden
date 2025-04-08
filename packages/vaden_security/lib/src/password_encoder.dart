import 'package:bcrypt/bcrypt.dart';

/// Interface for password encoding and matching.
/// This is used to hash passwords and verify them against raw passwords.
/// It is a common practice to store hashed passwords in databases
/// instead of plain text passwords.
abstract class PasswordEncoder {
  /// Checks if the raw password matches the encoded password.
  ///
  /// Returns `true` if the passwords match, `false` otherwise.
  /// This method is used to verify user credentials during login.
  /// It is important to use a secure hashing algorithm to protect
  /// against brute-force attacks and rainbow table attacks.
  /// The [encodedPassword] should be the hashed version of the password
  /// stored in the database.
  bool matches(String rawPassword, String encodedPassword);

  /// Encodes the raw password into a secure format.
  ///
  /// This method is used to hash passwords before storing them in a database.
  /// It is important to use a secure hashing algorithm to protect
  /// against brute-force attacks and rainbow table attacks.
  String encode(String rawPassword);
}

/// Implementation that uses the 'bcrypt' package to hash and verify passwords.
///
/// Default cost of [BCrypt.gensalt()] is 10, but it can be configured.
class BCryptPasswordEncoder implements PasswordEncoder {
  final int cost;

  /// [cost] controls the complexity factor of hashing (the higher, the more secure and slower).
  /// By default, the value 10 is reasonable for many cases.
  BCryptPasswordEncoder({this.cost = 10});

  @override
  String encode(String rawPassword) {
    final salt = BCrypt.gensalt(logRounds: cost);
    return BCrypt.hashpw(rawPassword, salt);
  }

  @override
  bool matches(String rawPassword, String encodedPassword) {
    return BCrypt.checkpw(rawPassword, encodedPassword);
  }
}
