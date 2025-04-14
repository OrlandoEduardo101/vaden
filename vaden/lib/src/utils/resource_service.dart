import 'dart:async';

import 'package:shelf_static/shelf_static.dart';
import 'package:vaden/vaden.dart';

/// A service for serving static files in a Vaden application.
///
/// The ResourceService class provides a simple way to serve static files (such as HTML,
/// CSS, JavaScript, images, etc.) from a specified directory on the file system. This is
/// useful for serving frontend assets, documentation, or other static content alongside
/// your API endpoints.
///
/// The service is implemented as a callable class that can be used directly as a handler
/// for requests, or mounted at a specific path using the [@Mount] annotation.
///
/// Example usage:
/// ```dart
/// // Serve static files from the 'public' directory at the root path
/// @Controller('/')
/// class StaticController {
///   @Mount('/')
///   ResourceService get staticFiles => ResourceService(
///     fileSystemPath: 'public',
///     defaultDocument: 'index.html',
///   );
/// }
/// ```
///
/// Or using the Pipeline API:
/// ```dart
/// void main() async {
///   final staticHandler = ResourceService(
///     fileSystemPath: 'public',
///     defaultDocument: 'index.html',
///   );
///
///   final handler = const Pipeline()
///     .addMiddleware(logRequests())
///     .addHandler((request) {
///       if (request.url.path.startsWith('assets')) {
///         return staticHandler(request);
///       }
///       return router(request);
///     });
///
///   await serve(handler, 'localhost', 8080);
/// }
/// ```
class ResourceService {
  /// The path to the directory on the file system containing the static files to serve.
  ///
  /// This path can be absolute or relative to the current working directory.
  final String fileSystemPath;

  /// The default document to serve when a directory is requested.
  ///
  /// When a request is made for a directory (e.g., '/'), the server will attempt to serve
  /// this document from that directory. Typically set to 'index.html'.
  final String defaultDocument;

  /// Whether to list the contents of directories when no default document is found.
  ///
  /// If true and a directory is requested that doesn't contain the default document,
  /// a directory listing will be generated and returned. If false, a 404 response will
  /// be returned instead.
  ///
  /// Default is false for security reasons.
  final bool listDirectories;

  /// Whether to use the header bytes of a file to determine its content type.
  ///
  /// If true, the server will examine the first few bytes of a file to determine its
  /// content type, which can be more accurate for certain file types. If false, the
  /// content type will be determined solely based on the file extension.
  ///
  /// Default is false for performance reasons.
  final bool useHeaderBytesForContentType;

  /// Creates a new ResourceService for serving static files.
  ///
  /// Parameters:
  /// - [fileSystemPath]: The path to the directory containing the static files to serve.
  /// - [defaultDocument]: The default document to serve when a directory is requested.
  /// - [listDirectories]: Whether to list directory contents when no default document is found.
  /// - [useHeaderBytesForContentType]: Whether to use header bytes to determine content type.
  ResourceService({
    required this.fileSystemPath,
    required this.defaultDocument,
    this.listDirectories = false,
    this.useHeaderBytesForContentType = false,
  });

  /// Handles an HTTP request by serving a static file.
  ///
  /// This method creates a static file handler using the shelf_static package and delegates
  /// the request handling to it. The handler will attempt to serve a file from the specified
  /// directory that matches the path in the request URL.
  ///
  /// Parameters:
  /// - [request]: The HTTP request to handle.
  ///
  /// Returns:
  /// - A Future that resolves to an HTTP response containing the requested file,
  ///   or a 404 response if the file is not found.
  FutureOr<Response> call(Request request) {
    return createStaticHandler(
      fileSystemPath,
      defaultDocument: defaultDocument,
      listDirectories: listDirectories,
      useHeaderBytesForContentType: useHeaderBytesForContentType,
    ).call(request);
  }
}
