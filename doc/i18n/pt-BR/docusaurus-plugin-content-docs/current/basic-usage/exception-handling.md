---
sidebar_position: 7
---

# Tratamento de Exceções

O Vaden inclui um poderoso mecanismo de tratamento de exceções inspirado no `@ControllerAdvice` do Spring Boot. Ele permite definir lógica de tratamento de erros global de forma centralizada e reutilizável.

## ControllerAdvice

Classes anotadas com `@ControllerAdvice()` atuam como interceptadores globais para exceções não capturadas que ocorrem durante o processamento de requisições.

Cada método dentro dessa classe pode ser anotado com `@ExceptionHandler(SomeException)` para capturar e tratar um tipo específico de exceção.

Você pode injetar dependências na classe de advice como qualquer outro componente.

```dart
@ControllerAdvice()
class AppControllerAdvice {
  final DSON _dson;
  AppControllerAdvice(this._dson);

  @ExceptionHandler(ResponseException)
  Future<Response> handleResponseException(ResponseException e) async {
    return e.generateResponse(_dson);
  }

  @ExceptionHandler(Exception)
  Response handleGeneric(Exception e) {
    return Response.internalServerError(
      body: jsonEncode({'message': 'Internal server error'}),
    );
  }
}
```

- O primeiro método captura `ResponseException` e usa um método personalizado para gerar uma resposta.
- O segundo método trata qualquer Exceção não capturada como um plano de fundo.

## Notas de Design

- Todos os métodos `@ExceptionHandler()` devem retornar `Response` ou `Future<Response>`.
- Você pode ter múltiplas classes `@ControllerAdvice()` se necessário.
- A correspondência mais próxima (baseada na hierarquia de tipos) será usada.
- Injeção de dependência é totalmente suportada.

Este sistema de tratamento de exceções oferece controle limpo e centralizado sobre formatação de erros, códigos de status e lógica personalizada, sem espalhar blocos try/catch por todos os seus controladores.