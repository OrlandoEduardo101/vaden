import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

@Service()
class UserDetailsServiceImpl implements UserDetailsService {
  @override
  Future<UserDetails?> loadUserByUsername(String username) async {
    if (username == 'vaden@vaden.dev') {
      return User(
        id: '1',
        name: 'Vaden',
        username: username,
        password:
            r'$2a$10$ApYjJBHnp4a/sQAfAlT.9ufcss.8PxNykdid5ZweKRB.XRhXoM1qq', // 123456
        roles: ['ADMIN'],
      );
    }
    return null;
  }
}

@DTO()
class User extends UserDetails {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
    required super.username,
    required super.password,
    required super.roles,
  });
}
