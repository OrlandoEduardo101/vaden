import 'package:shelf/shelf.dart';

/// Creates a middleware that handles Cross-Origin Resource Sharing (CORS).
///
/// CORS is a security feature implemented by browsers that restricts web pages from
/// making requests to a different domain than the one that served the original page.
/// This middleware allows you to configure which origins, methods, and headers are
/// allowed when your API receives cross-origin requests.
///
/// The middleware handles both preflight requests (OPTIONS method) and actual requests
/// by adding the appropriate CORS headers to the responses.
///
/// Example usage:
/// ```dart
/// // Basic usage with default settings (allows all origins)
/// final handler = const Pipeline()
///   .addMiddleware(cors())
///   .addHandler(router);
///
/// // Restricted to specific origins
/// final handler = const Pipeline()
///   .addMiddleware(cors(
///     allowedOrigins: ['https://example.com', 'https://app.example.com'],
///     allowMethods: ['GET', 'POST'],
///     allowHeaders: ['Origin', 'Content-Type', 'Authorization'],
///   ))
///   .addHandler(router);
/// ```
///
/// Parameters:
/// - [allowedOrigins]: List of origins that are allowed to access the resources.
///   Default is `['*']` which allows any origin.
/// - [allowMethods]: List of HTTP methods that are allowed when accessing the resources.
///   Default is `['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']`.
/// - [allowHeaders]: List of HTTP headers that can be used when making the actual request.
///   Default is `['Origin', 'Content-Type', 'Accept']`.
///
/// Returns:
/// - A middleware that adds CORS headers to responses.
Middleware cors({
  List<String> allowedOrigins = const ['*'],
  List<String> allowMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  List<String> allowHeaders = const ['Origin', 'Content-Type', 'Accept'],
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final requestOrigin = request.headers['Origin'];

      String? allowOriginHeader;
      if (allowedOrigins.contains('*')) {
        allowOriginHeader = '*';
      } else if (requestOrigin != null &&
          allowedOrigins.contains(requestOrigin)) {
        allowOriginHeader = requestOrigin;
      }

      if (request.method.toUpperCase() == 'OPTIONS') {
        var headers = <String, String>{
          if (allowOriginHeader != null)
            'Access-Control-Allow-Origin': allowOriginHeader,
          'Access-Control-Allow-Methods': allowMethods.join(', '),
          'Access-Control-Allow-Headers': allowHeaders.join(', '),
        };
        return Response.ok('', headers: headers);
      }

      final response = await innerHandler(request);

      var headers = <String, String>{
        if (allowOriginHeader != null)
          'Access-Control-Allow-Origin': allowOriginHeader,
        'Access-Control-Allow-Methods': allowMethods.join(', '),
        'Access-Control-Allow-Headers': allowHeaders.join(', '),
      };
      return response.change(headers: headers);
    };
  };
}
