---
sidebar_position: 3
---

# Components

Vaden provides a powerful and intuitive dependency injection (DI) system inspired by frameworks like Spring Boot. It makes use of annotations to register and inject dependencies throughout your application in a modular and scalable way.

## The Foundation of Injection

The `@Component()` annotation is the base for all injectable classes. Any class annotated with `@Component()` is automatically discovered and registered in the application’s DI container.

```dart
@Component()
class Logger {
  void log(String message) => print('[LOG] $message');
}
```

You can inject this into other components via constructor injection:

```dart
@Service()
class UserService {
  final Logger logger;

  UserService(this.logger);

  void createUser() => logger.log('User created');
}
```
Under the hood, `@Service`, `@Repository`, and `@Bean` are all specializations of `@Component`.

## `@Service()` and `@Repository()`

These annotations are semantic shortcuts to indicate a class’s purpose:

- `@Service()` is used for business logic classes.
- `@Repository()` is used for data access and persistence layers.

```dart
@Repository()
class UserRepository {
  List<String> findAllUsers() => ['Alice', 'Bob'];
}

@Service()
class UserService {
  final UserRepository repository;
  UserService(this.repository);

  List<String> getUsers() => repository.findAllUsers();
}
```

They behave the same as @Component() but help with code readability and future tooling support.

## Configuration

In some cases, you may want to register a class manually or configure an instance that requires parameters (such as credentials or environment data). For this, you can use `@Configuration()` with `@Bean()` methods:

```dart
@Configuration()
class AppConfiguration {
  @Bean()
  Logger logger() => Logger();

  @Bean()
  Future<ApiClient> api(ApplicationSettings settings) async {
    return ApiClient(baseUrl: settings['api']['url']);
  }
}
```
- Beans can be synchronous or asynchronous (`Future<T>`).
- Parameters are automatically resolved by the container.

## Lifecycle & Resolution

All classes are singletons by default — meaning the same instance is reused across the entire app.
Dependency injection works in:

- Controllers
- Services
- Repositories
- Middlewares
- Guards
- Beans (@Bean() methods)

