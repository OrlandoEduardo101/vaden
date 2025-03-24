---
sidebar_position: 1
---

# Controller

A `@Controller()` in Vaden defines a class that handles HTTP routes. It's one of the core building blocks of the framework.

The value passed to` @Controller('/path')` defines a route prefix applied to all methods in that class. For example:

```dart
@Controller('/users')
class UserController {
  @Get('/all')
  String getAll() => 'Listing all users';
}
```

This will map to `/users/all` in the HTTP server.<br></br>
Grouping routes with a common prefix helps keep your application modular and organized.

```dart
@Controller('/hello')
class HelloController {
  final HelloService helloService;

  helloController(this.helloService);

  @Get('/ping')
  Response ping() => Response.ok(helloService.ping());
}
```

- The base path `/hello` applies to all methods inside.
- Constructor injection automatically injects `HelloService` if it’s registered.

## Return Types

Controller methods in Vaden support multiple return types. Vaden will automatically adapt the response depending on what you return:
- `Response` or `Future<Response>` → Used directly.
- `String` or `List<int>` → Sent as plain body.
- An object marked with `@DTO()` → Serialized to JSON.
- A list of `@DTO()` → Serialized as a JSON array.

```dart
@Get('/text')
String hello() => 'Hello World';

@Get('/json')
UserDTO getUser() => UserDTO('admin');

@Get('/list')
List<UserDTO> getUsers() => [UserDTO('a'), UserDTO('b')];

@Get('/custom')
Future<Response> advanced() async => Response.ok('Manual');
```

## HTTP Method Handlers

Vaden supports the following method decorators:
- `@Get()`
- `@Post()`
- `@Put()`
- `@Delete()`
- `@Head()`
- `@Options()`

### @Param and @Query

These decorators extract data from the URL path or query string.

```dart
// http://localhost:8080/user/2
@Get('/user/<id>')
String getUser(@Param('id') int id) => 'User $id';

// http://localhost:8080/search?term=Text
@Get('/search')
String search(@Query('term') String term) => 'Searching $term';
```

You can omit the parameter name in the annotation:

```dart
@Get('/product/<id>')
String getProduct(@Param() String id) => 'Product $id';
```
In this case, the name of the variable `(id)` will be used as the key.

Both `@Param` and `@Query` support the following types:

- `String`
- `int`
- `double`
- `bool`

If a parameter is optional, you can declare it with a nullable type:

```dart
@Get('/search')
Response search(@Query('term') String? term) => ...;
```
This tells Vaden not to throw an error if the value is missing.

### Using `@Body` with DTOs

The `@Body()` decorator binds the request JSON body to a Dart object.
Only classes annotated with `@DTO()` are allowed:

```dart
@DTO()
class Credentials {
  final String username;
  final String password;
  Credentials(this.username, this.password);
}

...

@Post('/login')
String login(@Body() Credentials credentials) => credentials.username;
```
Internally, Vaden uses the DSON engine to convert the request body into your DTO.

## Wildcard Routing

Use `@Mount()` for wildcard endpoints — useful for advanced cases like WebSockets or proxy handlers:

```dart
@Controller('/socket')
class SocketController {
  @Mount('/chat')
  Response handle(Request request) {
    return websocketHandler(request);
  }
}
```
