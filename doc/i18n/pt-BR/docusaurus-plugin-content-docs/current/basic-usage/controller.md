---
sidebar_position: 2
---

# Controlador

Um `@Controller()` no Vaden define uma classe que lida com rotas HTTP. É um dos blocos de construção fundamentais do framework.

O valor passado para `@Controller('/caminho')` define um prefixo de rota aplicado a todos os métodos naquela classe. Por exemplo:

```dart
@Controller('/users')
class UserController {
  @Get('/all')
  String getAll() => 'Listing all users';
}
```

Isso será mapeado para `/users/all` no servidor HTTP.<br></br>
Agrupar rotas com um prefixo comum ajuda a manter sua aplicação modular e organizada.

```dart
@Controller('/hello')
class HelloController {
  final HelloService helloService;

  helloController(this.helloService);

  @Get('/ping')
  Response ping() => Response.ok(helloService.ping());
}
```

- O caminho base `/hello` se aplica a todos os métodos dentro.
- Injeção por construtor injeta automaticamente `HelloService` se estiver registrado.

## Tipos de Retorno

Métodos de controlador no Vaden suportam múltiplos tipos de retorno. O Vaden adaptará automaticamente a resposta dependendo do que você retornar:
- `Response` ou `Future<Response>` → Usado diretamente.
- `String` ou `List<int>` → Enviado como corpo simples.
- Um objeto marcado com `@DTO()` → Serializado para JSON.
- Uma lista de `@DTO()` → Serializada como array JSON.

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

## Manipuladores de Métodos HTTP

Vaden suporta os seguintes decoradores de método:

- `@Get()`
- `@Post()`
- `@Put()`
- `@Delete()`
- `@Head()`
- `@Options()`

### @Param and @Query

Esses decoradores extraem dados do caminho da URL ou da string de consulta.

```dart
// http://localhost:8080/user/2
@Get('/user/<id>')
String getUser(@Param('id') int id) => 'User $id';

// http://localhost:8080/search?term=Text
@Get('/search')
String search(@Query('term') String term) => 'Searching $term';
```

Você pode omitir o nome do parâmetro na anotação:

```dart
@Get('/product/<id>')
String getProduct(@Param() String id) => 'Product $id';
```
Neste caso, o nome da variável `(id)` será usado como chave.

Tanto `@Param` quanto `@Query` suportam os seguintes tipos:

- `String`
- `int`
- `double`
- `bool`

Se um parâmetro for opcional, você pode declará-lo com um tipo anulável:

```dart
@Get('/search')
Response search(@Query('term') String? term) => ...;
```
Isso indica ao Vaden para não lançar um erro se o valor estiver ausente.

### Usando `@Body` com DTOs

O decorador `@Body()` vincula o corpo JSON da requisição a um objeto Dart.

Apenas classes anotadas com `@DTO()` são permitidas:

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
Internamente, o Vaden usa o motor DSON para converter o corpo da requisição no seu DTO.

## Roteamento Curinga

Use `@Mount()` para endpoints curinga — útil para casos avançados como WebSockets ou manipuladores de proxy:

```dart
@Controller('/socket')
class SocketController {
  @Mount('/chat')
  Response handle(Request request) {
    return websocketHandler(request);
  }
}
```
