import 'package:vaden_security/src/glob.dart';
import 'package:vaden_security/src/http_method.dart';

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
  final HttpMethod method;

  RequestMatcher(String path, [this.method = HttpMethod.any])
      : path = Glob(path);

  AuthorizeRequest permitAll() => _PermitAllAuthorizeRequest(path, method);

  AuthorizeRequest hasRole(String role) =>
      _HasRoleAuthorizeRequest(path, role, method);

  AuthorizeRequest hasAnyRole(List<String> roles) =>
      _HasAnyRoleAuthorizeRequest(path, roles, method);

  AuthorizeRequest denyAll() => _DenyAllAuthorizeRequest(path, method);

  AuthorizeRequest authenticated() => _AuthenticatedRequest(path, method);
}

class AnyRequest {
  AuthorizeRequest permitAll() =>
      _PermitAllAuthorizeRequest(Glob('/**'), HttpMethod.any);

  AuthorizeRequest authenticated() =>
      _AuthenticatedRequest(Glob('/**'), HttpMethod.any);
}

sealed class AuthorizeRequest {
  final Glob path;
  final HttpMethod method;
  const AuthorizeRequest(this.path, this.method);

  bool matches(String path, HttpMethod method) {
    if (this.method == HttpMethod.any) {
      return this.path.matches(path);
    }
    if (this.method != method) {
      return false;
    }

    return this.path.matches(path);
  }

  bool autheticated() => false;
  bool isDenyAll() => false;
  bool hasRole(List<String> roles) => true;
}

class _AuthenticatedRequest extends AuthorizeRequest {
  const _AuthenticatedRequest(super.path, super.method);

  @override
  bool autheticated() => true;
}

class _DenyAllAuthorizeRequest extends AuthorizeRequest {
  const _DenyAllAuthorizeRequest(super.path, super.method);

  @override
  bool isDenyAll() => true;
}

class _PermitAllAuthorizeRequest extends AuthorizeRequest {
  const _PermitAllAuthorizeRequest(super.path, super.method);
}

class _HasRoleAuthorizeRequest extends AuthorizeRequest {
  final String role;

  const _HasRoleAuthorizeRequest(super.path, this.role, super.method);

  @override
  bool autheticated() => true;

  @override
  bool hasRole(List<String> roles) => roles.contains(role);
}

class _HasAnyRoleAuthorizeRequest extends AuthorizeRequest {
  final List<String> roles;

  const _HasAnyRoleAuthorizeRequest(super.path, this.roles, super.method);

  @override
  bool autheticated() => true;

  @override
  bool hasRole(List<String> roles) {
    for (var role in roles) {
      if (this.roles.contains(role)) {
        return true;
      }
    }
    return false;
  }
}
