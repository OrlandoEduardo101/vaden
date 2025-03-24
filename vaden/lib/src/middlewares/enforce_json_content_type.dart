import 'dart:async';

import 'package:vaden/vaden.dart';

/// Middleware that ensures all responses have a JSON content type header.
///
/// This middleware checks if a response already has a content-type header, and if not,
/// adds the 'application/json' content type. This is useful for ensuring consistent
/// content type headers across all API responses, especially when working with REST APIs
/// that primarily return JSON data.
///
/// The middleware only modifies responses that don't already have a content-type header,
/// preserving any explicitly set content types for specific responses (such as file downloads
/// or other non-JSON responses).
///
/// Example usage:
/// ```dart
/// // Apply globally to all routes
/// final handler = const Pipeline()
///   .addMiddleware(EnforceJsonContentType().toMiddleware())
///   .addHandler(router);
/// ```
///
/// Or using the [@UseMiddleware] annotation:
/// ```dart
/// @Controller('/api')
/// @UseMiddleware([EnforceJsonContentType])
/// class ApiController {
///   // All responses from this controller will have JSON content type
///   // if not explicitly set to something else
/// }
/// ```
class EnforceJsonContentType extends VadenMiddleware {
  /// Handles an incoming HTTP request and ensures the response has a JSON content type.
  ///
  /// This method first passes the request to the next handler in the chain, then
  /// checks if the resulting response has a content-type header. If not, it adds
  /// the 'application/json' content type header to the response.
  ///
  /// Parameters:
  /// - [request]: The incoming HTTP request.
  /// - [handler]: The next handler in the middleware chain.
  ///
  /// Returns:
  /// - A Future that resolves to the HTTP response, potentially with an added content-type header.
  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    final response = await handler(request);

    if (!response.headers.containsKey('content-type')) {
      return response.change(headers: {
        ...response.headers,
        'content-type': 'application/json',
      });
    }
    return response;
  }
}
