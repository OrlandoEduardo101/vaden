import 'dart:async';

import 'package:vaden/vaden.dart';

/// Base class for creating guards in the Vaden framework.
///
/// Guards are specialized middleware that protect routes by determining whether
/// a request should be allowed to proceed to the controller. They are typically
/// used for authentication and authorization purposes.
///
/// To create a custom guard, extend this abstract class and implement the
/// [canActivate] method. The guard can then be applied to controllers or specific
/// endpoints using the [@UseGuards] annotation.
///
/// Example:
/// ```dart
/// @Component()
/// class AuthGuard extends VadenGuard {
///   final AuthService _authService;
///
///   AuthGuard(this._authService);
///
///   @override
///   FutureOr<bool> canActivate(Request request) {
///     final authHeader = request.headers['Authorization'];
///     if (authHeader == null) return false;
///
///     final token = authHeader.replaceFirst('Bearer ', '');
///     return _authService.validateToken(token);
///   }
/// }
/// ```
///
/// Usage:
/// ```dart
/// @Controller('/api/admin')
/// @UseGuards([AuthGuard])
/// class AdminController {
///   // All endpoints in this controller will be protected by the AuthGuard
///
///   @Get('/dashboard')
///   Future<Response> getDashboard(Request request) {
///     // This endpoint will only be accessible if the AuthGuard allows it
///   }
///
///   @Get('/public')
///   @UseGuards([]) // Override to remove guards for this specific endpoint
///   Future<Response> getPublicInfo(Request request) {
///     // This endpoint will be accessible without authentication
///   }
/// }
/// ```
abstract class VadenGuard extends VadenMiddleware {
  /// Determines whether a request should be allowed to proceed.
  ///
  /// This method is called for each request that passes through the guard.
  /// It should return true if the request is allowed to proceed to the controller,
  /// or false if it should be rejected.
  ///
  /// Guards can use information from the request, such as headers, query parameters,
  /// or cookies, to make this determination. They can also inject services to
  /// perform more complex validation, such as checking a database or an external
  /// authentication service.
  ///
  /// Parameters:
  /// - [request]: The incoming HTTP request.
  ///
  /// Returns:
  /// - A Future that resolves to true if the request is allowed, or false if it should be rejected.
  FutureOr<bool> canActivate(Request request);

  /// Handles an incoming HTTP request by checking if it can be activated.
  ///
  /// This method implements the [VadenMiddleware.handler] method by calling
  /// [canActivate] and either allowing the request to proceed or returning
  /// a forbidden response.
  ///
  /// Parameters:
  /// - [request]: The incoming HTTP request.
  /// - [handler]: The next handler in the middleware chain.
  ///
  /// Returns:
  /// - A Future that resolves to the HTTP response, which may be a forbidden
  ///   response if the guard rejects the request.
  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    final result = await canActivate(request);

    if (result) {
      return handler(request);
    }

    return Response.forbidden('Forbidden: $runtimeType');
  }
}
