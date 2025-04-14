import 'dart:async';

import 'package:vaden/vaden.dart';

/// This file defines the structure and functionality for registering and managing
/// `VadenModule` instances, which are used to configure external dependencies
/// and routes for a Vaden-based application.
///
/// The `ModuleRegister` class is responsible for maintaining a list of registered
/// modules and providing methods to register their injections and routes.
///
/// The `VadenModule` abstract class serves as a blueprint for creating modules
/// that can define their own dependency injections and route configurations.
/// This allows external packages or configurations to be modularized and integrated
/// into the application seamlessly.
class ModuleRegister {
  final List<VadenModule> modules;

  /// The constructor initializes the `ModuleRegister` with an optional list
  /// of `VadenModule` instances. If no modules are provided, an empty list
  /// is created.
  ModuleRegister([List<VadenModule>? modules])
      : modules = modules ?? <VadenModule>[];

  /// The `registerAll` method iterates through all registered modules and
  /// calls their `registerInjections` and `registerRoutes` methods.
  /// This method is responsible for setting up the dependency injections and
  /// route configurations for each module. It takes a `Router` instance and
  /// an `AutoInjector` instance as parameters, which are used to register
  /// the injections and routes for each module.
  Future<void> registerAll(
    Router router,
    AutoInjector injector,
  ) async {
    for (final module in modules) {
      await module.register(router, injector);
    }
  }
}

/// The `VadenModule` abstract class defines the structure for creating modules
/// that can register their own dependency injections and route configurations.
/// This allows for modularization and better organization of code in a Vaden-based
/// application.
abstract class VadenModule {
  /// The `register` method is responsible for defining the routes that
  /// the module provides. This method should be implemented by subclasses
  /// to define the specific routes required by the module. The `router`
  /// parameter is an instance of `Router` that can be used to register the
  /// routes. The `injector` parameter is an instance of `Injector` that can
  /// be used to resolve dependencies for the routes.
  FutureOr<void> register(Router router, AutoInjector injector);
}
