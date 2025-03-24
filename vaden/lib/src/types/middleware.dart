import 'dart:async';

import 'package:vaden/vaden.dart';

/// Base class for creating middleware in the Vaden framework.
///
/// Middleware in Vaden allows you to intercept and modify HTTP requests and responses
/// as they flow through the application. Middleware can be used for various purposes,
/// such as authentication, logging, error handling, CORS support, and more.
///
/// To create a custom middleware, extend this abstract class and implement the
/// [handler] method. The middleware can then be applied to controllers or specific
/// endpoints using the [@UseMiddleware] annotation.
///
/// Example:
/// ```dart
/// @Component()
/// class LoggingMiddleware extends VadenMiddleware {
///   @override
///   FutureOr<Response> handler(Request request, Handler handler) async {
///     print('Incoming request: ${request.method} ${request.url}');
///     final stopwatch = Stopwatch()..start();
///     
///     // Call the next handler in the chain
///     final response = await handler(request);
///     
///     stopwatch.stop();
///     print('Response: ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)');
///     
///     return response;
///   }
/// }
/// ```
///
/// Usage:
/// ```dart
/// @Controller('/api')
/// @UseMiddleware([LoggingMiddleware])
/// class ApiController {
///   // All endpoints in this controller will use the LoggingMiddleware
/// }
/// ```
abstract class VadenMiddleware {
  /// Handles an incoming HTTP request.
  ///
  /// This method is called for each request that passes through the middleware.
  /// It receives the current request and a handler function that represents the
  /// next middleware or controller in the chain.
  ///
  /// The middleware can:
  /// - Modify the request before passing it to the next handler
  /// - Call the next handler to get the response
  /// - Modify the response before returning it
  /// - Short-circuit the chain by returning a response without calling the next handler
  /// - Handle exceptions thrown by the next handler
  ///
  /// Parameters:
  /// - [request]: The incoming HTTP request.
  /// - [handler]: The next handler in the middleware chain.
  ///
  /// Returns:
  /// - A Future that resolves to the HTTP response, which may be modified by this middleware.
  FutureOr<Response> handler(Request request, Handler handler);

  /// Converts this VadenMiddleware to a shelf Middleware.
  ///
  /// This method adapts the VadenMiddleware to the shelf Middleware format,
  /// allowing it to be used with the shelf server. This conversion is typically
  /// handled automatically by the Vaden framework.
  ///
  /// Returns:
  /// - A shelf Middleware function that wraps this VadenMiddleware.
  Middleware toMiddleware() {
    return (h) {
      return (request) {
        return handler(request, h);
      };
    };
  }
}
