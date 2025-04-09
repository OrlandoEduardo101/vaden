import 'dart:async';
import 'dart:convert';

import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart' hide Response;

@Controller('/docs')
class OpenAPIController {
  final SwaggerUI swaggerUI;
  const OpenAPIController(this.swaggerUI);

  @Get('/')
  FutureOr<Response> getSwagger(Request request) {
    return swaggerUI.call(request);
  }

  @Get('/openapi.json')
  Map<String, dynamic> getOpenAPIJson() {
    return jsonDecode(swaggerUI.schemaText);
  }
}
