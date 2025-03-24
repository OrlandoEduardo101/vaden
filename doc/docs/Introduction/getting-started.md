---
sidebar_position: 10
---

# Getting Started

Vaden is designed to be "flight-ready" from the very start. Launch a new project in just three simple steps:

## 1. Generate Your Project

Visit our Vaden Generator website to create your initial project structure. It automatically generates all the necessary files and configurations based on your dependencies.  
Access it here: [https://start.vaden.dev](https://start.vaden.dev).

## 2. Install Dependencies

As with any Dart project, you need to download the required dependencies. Run the following command using the Dart SDK:

```sh title="Terminal"
dart pub get
```

## 3. Run the Class Scanner with build_runner

The **Class Scanner** iintroduces Java-inspired metaprogramming to Dart. Since this feature is integrated with build_runner, simply run the build or watch command during development:

```sh title="Terminal"
dart run build_runner watch
```

## 4. Running the Project

The generated project is ready to run using the Dart SDK or via IDEs like VSCode. To run the project:
- In your IDE, press F5, or run the command:

```sh title="Terminal"
dart run
```

## 5. Testing Your Application

When you run the project, the console will display a message indicating that the server is listening on port **8080**. You can then test your application using a web browser or tools like **Postman** or **Insomnia**.

If your project includes **OpenAPI** as a dependency, navigate to [http://localhost:8080/docs/](http://localhost:8080/docs/) to access the **Swagger UI** and test the **API** endpoints.

## 6. Contribute and Evolve

Vaden is an open-source project, and we welcome your contributions—big or small. If you encounter any bugs or have suggestions for improvement, please reach out via our social media channels or open an issue on GitHub.

Embrace the revolution, and may the force be with you!

```
Happy Coding
```