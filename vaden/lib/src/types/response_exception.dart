import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:vaden/src/types/dson.dart';

/// Exception class for handling HTTP responses with error states.
///
/// The ResponseException class is used to throw exceptions that can be automatically
/// converted into HTTP responses with appropriate status codes, body content, and headers.
/// This allows for a consistent approach to error handling across the application.
///
/// ResponseException is typically used in service or repository layers to signal
/// error conditions that should be propagated to the client as HTTP responses.
/// The exception is caught by the framework's exception handling middleware and
/// converted into an appropriate HTTP response.
///
/// Example:
/// ```dart
/// @Service()
/// class UserService {
///   Future<UserDTO> getUserById(String id) async {
///     final user = await userRepository.findById(id);
///     if (user == null) {
///       throw ResponseException(404, {'error': 'User not found'});
///     }
///     return user;
///   }
/// }
/// ```
///
/// In the example above, if a user is not found, a ResponseException is thrown
/// with a 404 status code and a JSON body containing an error message. This will
/// be automatically converted into an HTTP response with the same status code and body.
class ResponseException<W> implements Exception {
  /// The body content of the response.
  ///
  /// This can be of various types, including:
  /// - String: For plain text responses
  /// - List<int>: For binary data
  /// - Map<String, dynamic>: For JSON objects
  /// - Custom DTO classes: Will be serialized to JSON using the DSON system
  /// - Lists of the above types
  final W body;

  /// The HTTP status code for the response.
  ///
  /// Common status codes include:
  /// - 400: Bad Request
  /// - 401: Unauthorized
  /// - 403: Forbidden
  /// - 404: Not Found
  /// - 409: Conflict
  /// - 422: Unprocessable Entity
  /// - 500: Internal Server Error
  final int code;

  /// Additional HTTP headers to include in the response.
  ///
  /// These headers will be merged with the default headers set by the framework.
  /// If a Content-Type header is not provided, it will be automatically set based
  /// on the type of the body content.
  final Map<String, String> headers;

  /// Creates a new ResponseException with the specified status code, body, and headers.
  ///
  /// Parameters:
  /// - [code]: The HTTP status code for the response.
  /// - [body]: The body content of the response.
  /// - [headers]: Additional HTTP headers to include in the response (optional).
  const ResponseException(this.code, this.body, {this.headers = const {}});

  factory ResponseException.internalServerError(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(500, message, headers: headers);
  }

  factory ResponseException.notFound(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(404, message, headers: headers);
  }
  factory ResponseException.badRequest(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(400, message, headers: headers);
  }
  factory ResponseException.unauthorized(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(401, message, headers: headers);
  }
  factory ResponseException.forbidden(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(403, message, headers: headers);
  }
  factory ResponseException.conflict(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(409, message, headers: headers);
  }
  factory ResponseException.unprocessableEntity(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(422, message, headers: headers);
  }
  factory ResponseException.notAcceptable(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(406, message, headers: headers);
  }
  factory ResponseException.notImplemented(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(501, message, headers: headers);
  }
  factory ResponseException.serviceUnavailable(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(503, message, headers: headers);
  }
  factory ResponseException.gatewayTimeout(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(504, message, headers: headers);
  }
  factory ResponseException.tooManyRequests(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(429, message, headers: headers);
  }
  factory ResponseException.notModified(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(304, message, headers: headers);
  }
  factory ResponseException.methodNotAllowed(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(405, message, headers: headers);
  }

  factory ResponseException.requestTimeout(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(408, message, headers: headers);
  }
  factory ResponseException.preconditionFailed(W message, {Map<String, String> headers = const {}}) {
    return ResponseException(412, message, headers: headers);
  }

  /// Generates a shelf Response object from this exception.
  ///
  /// This method converts the exception into a shelf Response object that can be
  /// returned from a controller method or middleware. The conversion process depends
  /// on the type of the body content:
  /// - String: Returned as plain text
  /// - List<int>: Returned as binary data
  /// - Map<String, dynamic> and similar map types: Encoded as JSON
  /// - Custom DTO classes: Serialized to JSON using the provided DSON instance
  /// - Lists of the above types: Processed accordingly
  ///
  /// Parameters:
  /// - [dson]: The DSON instance to use for serializing custom DTO classes.
  ///
  /// Returns:
  /// - A shelf Response object with the appropriate status code, body, and headers.
  Response generateResponse(DSON dson) {
    if (body is String) {
      return Response(code, body: body, headers: _enforceContentType(headers, 'text/plain'));
    } else if (body is List<int>) {
      return Response(code, body: body, headers: _enforceContentType(headers, 'application/octet-stream'));
    } else if (body is Map<String, dynamic>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is Map<String, Object>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is Map<String, String>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, dynamic>>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, String>>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, Object>>) {
      return Response(code, body: jsonEncode(body), headers: _enforceContentType(headers, 'application/json'));
    } else {
      if (body is List) {
        final json = (body as List).map((e) => dson.toJson(e)).toList();
        return Response(code, body: jsonEncode(json), headers: _enforceContentType(headers, 'application/json'));
      }
      return Response(code, body: jsonEncode(dson.toJson(body)), headers: _enforceContentType(headers, 'application/json'));
    }
  }

  /// Ensures that the response headers include a Content-Type header.
  ///
  /// This private method adds a Content-Type header to the response headers if one
  /// is not already present. This ensures that the client knows how to interpret
  /// the response body.
  ///
  /// Parameters:
  /// - [headers]: The original headers map.
  /// - [contentType]: The content type to set if none is present.
  ///
  /// Returns:
  /// - A new headers map with the Content-Type header added if necessary.
  Map<String, String> _enforceContentType(Map<String, String> headers, String contentType) {
    final Map<String, String> enforcedHeaders = Map<String, String>.from(headers);

    if (enforcedHeaders['content-type'] == null && enforcedHeaders['Content-Type'] == null) {
      enforcedHeaders['Content-Type'] = contentType;
    }

    return enforcedHeaders;
  }

  /// Returns a string representation of this exception.
  ///
  /// This method is useful for debugging and logging purposes. It includes the
  /// exception's body content and status code.
  ///
  /// Returns:
  /// - A string representation of this exception.
  @override
  String toString() {
    return 'ResponseException{message: $body, code: $code}';
  }
}
