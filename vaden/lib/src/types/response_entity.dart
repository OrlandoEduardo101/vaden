import 'dart:convert';

import 'package:vaden/vaden.dart';

typedef AsyncResponseEntity<T> = Future<ResponseEntity<T>>;

class ResponseEntity<T> {
  final T body;
  final int statusCode;
  final Map<String, String> headers;
  ResponseEntity(
    this.body, {
    this.statusCode = 200,
    this.headers = const {},
  });

  /// Generates a shelf Response object from this ResponseEntity.
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
      return Response(statusCode,
          body: body, headers: _enforceContentType(headers, 'text/plain'));
    } else if (body is List<int>) {
      return Response(statusCode,
          body: body,
          headers: _enforceContentType(headers, 'application/octet-stream'));
    } else if (body is Map<String, dynamic>) {
      return Response(statusCode,
          body: jsonEncode(body),
          headers: _enforceContentType(headers, 'application/json'));
    } else if (body is Map<String, Object>) {
      return Response(statusCode,
          body: jsonEncode(body),
          headers: _enforceContentType(headers, 'application/json'));
    } else if (body is Map<String, String>) {
      return Response(statusCode,
          body: jsonEncode(body),
          headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, dynamic>>) {
      return Response(statusCode,
          body: jsonEncode(body),
          headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, String>>) {
      return Response(statusCode,
          body: jsonEncode(body),
          headers: _enforceContentType(headers, 'application/json'));
    } else if (body is List<Map<String, Object>>) {
      return Response(statusCode,
          body: jsonEncode(body),
          headers: _enforceContentType(headers, 'application/json'));
    } else {
      if (body is List) {
        final json = (body as List).map((e) => dson.toJson(e)).toList();
        return Response(statusCode,
            body: jsonEncode(json),
            headers: _enforceContentType(headers, 'application/json'));
      }
      return Response(statusCode,
          body: jsonEncode(dson.toJson(body)),
          headers: _enforceContentType(headers, 'application/json'));
    }
  }

  Map<String, String> _enforceContentType(
      Map<String, String> headers, String contentType) {
    final Map<String, String> enforcedHeaders =
        Map<String, String>.from(headers);

    if (enforcedHeaders['content-type'] == null &&
        enforcedHeaders['Content-Type'] == null) {
      enforcedHeaders['Content-Type'] = contentType;
    }

    return enforcedHeaders;
  }
}
