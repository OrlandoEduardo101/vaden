part of 'extensions.dart';

/// Extension on the shelf [Pipeline] class to provide convenient methods for adding
/// Vaden-specific middleware and guards.
///
/// The PipelineExtension simplifies the process of adding Vaden middleware and guards
/// to a shelf pipeline by providing dedicated methods that handle the conversion from
/// Vaden's middleware types to shelf's middleware format.
///
/// Example usage:
/// ```dart
/// final handler = const Pipeline()
///   .addGuard(AuthGuard())
///   .addVadenMiddleware(LoggingMiddleware())
///   .addMiddleware(cors())
///   .addHandler(router);
/// ```
extension PipelineExtension on Pipeline {
  /// Adds a Vaden guard to the pipeline.
  ///
  /// This method converts the [VadenGuard] to a shelf middleware using the
  /// [toMiddleware] method and adds it to the pipeline.
  ///
  /// Guards are specialized middleware that protect routes by determining whether
  /// a request should be allowed to proceed based on authentication or authorization rules.
  ///
  /// Parameters:
  /// - [guard]: The Vaden guard to add to the pipeline.
  ///
  /// Returns:
  /// - A new pipeline with the guard added.
  Pipeline addGuard(VadenGuard guard) {
    return addMiddleware(guard.toMiddleware());
  }

  /// Adds a Vaden middleware to the pipeline.
  ///
  /// This method converts the [VadenMiddleware] to a shelf middleware using the
  /// [toMiddleware] method and adds it to the pipeline.
  ///
  /// Middleware can intercept and modify HTTP requests and responses as they flow
  /// through the application, enabling features like logging, error handling, and more.
  ///
  /// Parameters:
  /// - [middleware]: The Vaden middleware to add to the pipeline.
  ///
  /// Returns:
  /// - A new pipeline with the middleware added.
  Pipeline addVadenMiddleware(VadenMiddleware middleware) {
    return addMiddleware(middleware.toMiddleware());
  }
}
