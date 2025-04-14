import 'dart:async';

import 'package:vaden/vaden.dart';

/// The `CommonModule` abstract class defines the structure for creating modules
/// that can register their own dependency injections and route configurations.
/// This allows for modularization and better organization of code in a Vaden-based
/// application.
abstract class CommonModule {
  /// The `register` method is responsible for defining the routes that
  /// the module provides. This method should be implemented by subclasses
  /// to define the specific routes required by the module. The `router`
  /// parameter is an instance of `Router` that can be used to register the
  /// routes. The `injector` parameter is an instance of `Injector` that can
  /// be used to resolve dependencies for the routes.
  FutureOr<void> register(Router router, AutoInjector injector);
}
