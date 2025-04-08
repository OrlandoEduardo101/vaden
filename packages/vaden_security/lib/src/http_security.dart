import 'package:vaden_security/src/glob.dart';

class HttpSecurity {
  final List<AuthorizeRequest> authorizeRequests;

  HttpSecurity(this.authorizeRequests) {
    authorizeRequests.sort((a, b) {
      if (a.path == Glob('/**')) {
        return 1;
      }
      if (b.path == Glob('/**')) {
        return -1;
      }
      return 0;
    });
  }
}

class RequestMatcher {
  final Glob path;

  RequestMatcher(String path) : path = Glob(path);

  AuthorizeRequest permitAll() => _PermitAllAuthorizeRequest(path);

  AuthorizeRequest hasRole(String role) => _HasRoleAuthorizeRequest(path, role);

  AuthorizeRequest hasAuthority(String authority) => _HasAuthorityAuthorizeRequest(path, authority);

  AuthorizeRequest authenticated() => _AuthenticatedRequest(path);
}

class AnyRequest {
  AuthorizeRequest permitAll() => _PermitAllAuthorizeRequest(Glob('/**'));

  AuthorizeRequest authenticated() => _AuthenticatedRequest(Glob('/**'));
}

sealed class AuthorizeRequest {
  final Glob path;
  const AuthorizeRequest(this.path);

  bool matches(String path) => this.path.matches(path);

  bool autheticated() => false;
  bool hasRole(List<String> roles) => true;
  bool hasAuthority(String authority) => true;
}

class _AuthenticatedRequest extends AuthorizeRequest {
  const _AuthenticatedRequest(super.path);

  @override
  bool autheticated() => true;
}

class _PermitAllAuthorizeRequest extends AuthorizeRequest {
  const _PermitAllAuthorizeRequest(super.path);
}

class _HasRoleAuthorizeRequest extends AuthorizeRequest {
  final String role;

  const _HasRoleAuthorizeRequest(super.path, this.role);

  @override
  bool autheticated() => true;

  @override
  bool hasRole(List<String> roles) => roles.contains(role);
}

class _HasAuthorityAuthorizeRequest extends AuthorizeRequest {
  final String authority;

  const _HasAuthorityAuthorizeRequest(super.path, this.authority);

  @override
  bool autheticated() => true;

  @override
  bool hasAuthority(String authority) => this.authority == authority;
}
