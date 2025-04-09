import 'package:vaden/vaden.dart';

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  head('HEAD'),
  options('OPTIONS'),
  trace('TRACE'),
  any('ANY');

  final String name;

  const HttpMethod(this.name);

  static HttpMethod fromRequest(Request request) {
    final method = request.method.toUpperCase();
    return HttpMethod.values.firstWhere(
      (e) => e.name.toUpperCase() == method.toUpperCase(),
      orElse: () => HttpMethod.any,
    );
  }
}
