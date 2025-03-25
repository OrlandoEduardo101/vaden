---
sidebar_position: 3
---

# Componentes

O Vaden fornece um sistema de injeção de dependência (DI) poderoso e intuitivo inspirado em frameworks como Spring Boot. Ele utiliza anotações para registrar e injetar dependências em toda a aplicação de forma modular e escalável.

## O Fundamento da Injeção

A anotação `@Component()` é a base para todas as classes injetáveis. Qualquer classe anotada com `@Component()` é automaticamente descoberta e registrada no contêiner de DI da aplicação.

```dart
@Component()
class Logger {
  void log(String message) => print('[LOG] $message');
}
```

Você pode injetar isso em outros componentes via injeção por construtor:

```dart
@Service()
class UserService {
  final Logger logger;

  UserService(this.logger);

  void createUser() => logger.log('User created');
}
```
Por baixo dos panos, `@Service`, `@Repository`, e `@Bean`  são todas especializações de `@Component`.

## `@Service()` e `@Repository()`

Essas anotações são atalhos semânticos para indicar o propósito de uma classe:

- `@Service()` é usado para classes de lógica de negócio.
- `@Repository()` é usado para camadas de acesso a dados e persistência.

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

Elas se comportam igual a `@Component()`, mas ajudam na legibilidade do código e no suporte futuro de ferramentas.

## Configuração

Em alguns casos, você pode querer registrar uma classe manualmente ou configurar uma instância que requer parâmetros (como credenciais ou dados de ambiente). Para isso, você pode usar `@Configuration()` com métodos `@Bean()`:

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
- Beans podem ser síncronos ou assíncronos (`Future<T>`).
- Parâmetros são automaticamente resolvidos pelo contêiner.

## Ciclo de Vida & Resolução

Todas as classes são singletons por padrão — o que significa que a mesma instância é reutilizada em toda a aplicação.
A injeção de dependência funciona em:

- Controladores
- Serviços
- Repositórios
- Middlewares
- Guards
- Beans (métodos @Bean())

