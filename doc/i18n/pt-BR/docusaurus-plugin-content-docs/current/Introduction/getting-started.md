---
sidebar_position: 10
---

# Primeiros Passos

O Vaden é projetado para estar "pronto para o voo" desde o início. Inicie um novo projeto em apenas três etapas simples:

## 1. Gere Seu Projeto

Visite nosso site Vaden Generator para criar a estrutura inicial do seu projeto. Ele gera automaticamente todos os arquivos e configurações necessários com base em suas dependências.  
Acesse aqui: [https://start.vaden.dev](https://start.vaden.dev).

## 2. Instale as Dependências

Como em qualquer projeto Dart, você precisa baixar as dependências necessárias. Execute o seguinte comando usando o SDK Dart:

```sh title="Terminal"
dart pub get
```

## 3. Execute o Scanner de Classes com build_runner

O **Scanner de Classes** introduz metaprogramação inspirada em Java para Dart. Como esse recurso é integrado com build_runner, simplesmente execute o comando de build ou watch durante o desenvolvimento:

```sh title="Terminal"
dart run build_runner watch
```

## 4. Executando o Projeto

O projeto gerado está pronto para ser executado usando o SDK Dart ou por meio de IDEs como VSCode.
Para executar o projeto:
- Em sua IDE, pressione F5, ou execute o comando:

```sh title="Terminal"
dart run bin/server.dart
```

## 5. Testando Sua Aplicação

Quando você executar o projeto, o console exibirá uma mensagem indicando que o servidor está escutando na porta `8080`. Você pode então testar sua aplicação usando um navegador web ou ferramentas como `Postman` ou `Insomnia`.

Se seu projeto incluir `OpenAPI` como dependência, navegue até [http://localhost:8080/docs/](http://localhost:8080/docs/) para acessar a **Swagger UI** e testar os endpoints da **API**.

## 6. Contribua e Evolua

Vaden é um projeto de código aberto, e estamos abertos às suas contribuições — grandes ou pequenas. Se você encontrar algum bug ou tiver sugestões de melhoria, por favor, entre em contato por meio de nossos canais de mídia social ou abra uma issue no GitHub.

Abrace a revolução, e que a força esteja com você!

```
Happy Coding
```