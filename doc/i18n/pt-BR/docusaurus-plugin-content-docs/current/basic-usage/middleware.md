---
sidebar_position: 4
---

# Middleware

O Vaden oferece um sistema de middleware poderoso construído sobre o pipeline do Shelf. Ele permite transformações de requisição/resposta, autenticação, registro de logs, manipulação de cabeçalhos e muito mais — globalmente ou por rota.

## Middlewares Globais com `Pipeline`

Para definir middlewares que se aplicam a todas as requisições, use o `Pipeline` dentro da sua classe `@Configuration()`:

```dart
@Configuration()
class AppConfiguration {
  @Bean()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
  }

  @Bean()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline()
        .addMiddleware(cors(allowedOrigins: ['*']))
        .addVadenMiddleware(EnforceJsonContentType())
        .addMiddleware(logRequests());
  }
}
```

- `addMiddleware(...)` adiciona qualquer middleware do Shelf.
- `addVadenMiddleware(...)` adiciona um middleware compatível com Vaden.

Esses middlewares são executados antes de qualquer lógica de controlador.

## Middleware em Nível de Rota

Você pode aplicar middleware a controladores específicos ou até rotas individuais usando a anotação `@UseMiddleware`:

```dart
@UseMiddleware([LoggerMiddleware])
@Controller('/users')
class UserController {
  @Get('/')
  Response list() => Response.ok('Users');
}
```

Você também pode anotar um método específico:

```dart
@UseMiddleware([LoggerMiddleware])
@Get('/profile')
Response getProfile() => Response.ok('Profile');
```

Classes de middleware devem implementar a seguinte interface:

```dart
class MyMiddleware implements Middleware {
  FutureOr<Response> handle(Request request, Handler next) async {
    return next(request);
  }
}
```

## Guards

Guards são um tipo especial de middleware usado para controle de acesso. Você pode aplicá-los como middleware regular usando `@UseGuards`:

```dart
@UseGuards([AuthGuard])
@Controller('/admin')
class AdminController {
  @Get('/dashboard')
  Response dashboard() => Response.ok('Admin');
}
```

Um guard deve estender `Guard`, que por sua vez implementa `Middleware`:

```dart
class MyGuard extends Guard {
  FutureOr<bool> canActivate(Request request) async {
    return true;
  }
}
```

## Ordem dos Middlewares

A ordem de execução dos middlewares segue este padrão:

- Middlewares globais do Pipeline em `AppConfiguration`.
- Middlewares em nível de Controlador com `@UseMiddleware`.
- Middlewares em nível de Método com `@UseMiddleware`.
- Guards via `@UseGuards `são sempre aplicados antes de qualquer lógica de rota.

Esta abordagem em camadas garante uma separação clara de responsabilidades e controle flexível de requisições.
