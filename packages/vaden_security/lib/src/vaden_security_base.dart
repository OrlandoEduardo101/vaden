import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart' as oapi;
import 'package:vaden_security/src/global_security_middleware.dart';
import 'package:vaden_security/vaden_security.dart';

class VadenSecurity extends VadenModule {
  @override
  FutureOr<void> register(Router router, AutoInjector injector) {
    var pipeline = injector.get<Pipeline>();
    pipeline = pipeline.addVadenMiddleware(GlobalSecurityMiddleware(
      injector.get<JwtService>(),
      injector.tryGet<UserDetailsService>(),
      injector.get<HttpSecurity>(),
    ));

    injector.replaceInstance(pipeline);

    router.get('/auth/me', (request) => _meHandler(request, injector));
    router.get('/auth/login', (request) => _handleLogin(request, injector));
    router.get('/auth/refresh', (request) => _handleRefresh(request, injector));

    final dson = injector.get<DSON>();

    dson.addToJson<UserDetails>((user) {
      return {
        'username': user.username,
        'roles': user.roles,
      };
    });

    dson.addFromJson<UserDetails>((json) {
      return UserDetails(
        username: json['username'] as String,
        password: json['password'] as String,
        roles: List<String>.from(json['roles'] as List),
      );
    });

    var openapi = injector.get<oapi.OpenApi>();

    final httpSecurity = injector.get<HttpSecurity>();

    for (final path in (openapi.paths ?? {}).keys) {
      final pathItems = openapi.paths!;
      var pathItem = pathItems[path]!;

      bool checkHasSecurity(String path, HttpMethod method) {
        final authorize = httpSecurity.authorizeRequests.firstWhereOrNull((e) => e.matches(path, method));
        return authorize != null && authorize.autheticated();
      }

      pathItem = pathItem.copyWith(
        get: pathItem.get?.copyWith(
          security: [
            ...pathItem.get?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.get))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        post: pathItem.post?.copyWith(
          security: [
            ...pathItem.post?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.post))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        put: pathItem.put?.copyWith(
          security: [
            ...pathItem.put?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.put))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        delete: pathItem.delete?.copyWith(
          security: [
            ...pathItem.delete?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.delete))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        patch: pathItem.patch?.copyWith(
          security: [
            ...pathItem.patch?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.patch))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        head: pathItem.head?.copyWith(
          security: [
            ...pathItem.head?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.head))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        options: pathItem.options?.copyWith(
          security: [
            ...pathItem.options?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.options))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
        trace: pathItem.trace?.copyWith(
          security: [
            ...pathItem.trace?.security ?? [],
            if (checkHasSecurity(path, HttpMethod.trace))
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
          ],
        ),
      );

      final newPathItems = {...pathItems};
      newPathItems[path] = pathItem;
      openapi = openapi.copyWith(
        paths: newPathItems,
      );
    }

    openapi = openapi.copyWith.components!.call(
      schemas: {
        ...openapi.components?.schemas ?? {},
        'UserDetails': oapi.Schema.object(
          properties: {
            'username': oapi.Schema.string(),
            'roles': oapi.Schema.array(
              items: oapi.Schema.string(),
            ),
          },
        ),
        'Tokens': oapi.Schema.object(
          properties: {
            'access_token': oapi.Schema.string(),
            'refresh_token': oapi.Schema.string(),
          },
        ),
      },
      securitySchemes: {
        ...openapi.components?.securitySchemes ?? {},
        'basic': oapi.SecurityScheme.http(
          scheme: oapi.HttpSecurityScheme.basic,
          description: 'Basic authentication for login',
        ),
        'bearer': oapi.SecurityScheme.http(
          scheme: oapi.HttpSecurityScheme.bearer,
          description: 'Bearer authentication for accessing protected resources',
        ),
        'bearer-refresh': oapi.SecurityScheme.http(
          scheme: oapi.HttpSecurityScheme.bearer,
          description: 'Bearer authentication for refreshing tokens',
        ),
      },
    );

    openapi = openapi.copyWith(
      tags: [
        oapi.Tag(name: 'auth', description: 'Authentication endpoints'),
        ...openapi.tags ?? [],
      ],
      paths: {
        ...openapi.paths ?? {},
        '/auth/me': oapi.PathItem(
          get: oapi.Operation(
            summary: 'Get current user details',
            tags: ['auth'],
            security: [
              oapi.Security(
                name: 'bearer',
                scopes: [],
              ),
            ],
            responses: {
              '200': oapi.Response(
                description: 'User details retrieved successfully',
                content: {
                  'application/json': oapi.MediaType(
                    schema: oapi.Schema.object(ref: '#/components/schemas/UserDetails'),
                  ),
                },
              ),
              '403': oapi.Response(description: 'Forbidden'),
            },
          ),
        ),
        '/auth/login': oapi.PathItem(
          get: oapi.Operation(
            summary: 'Login and get access and refresh tokens',
            tags: ['auth'],
            security: [
              oapi.Security(
                name: 'basic',
                scopes: [],
              ),
            ],
            responses: {
              '200': oapi.Response(
                description: 'Tokens retrieved successfully',
                content: {
                  'application/json': oapi.MediaType(
                    schema: oapi.Schema.object(ref: '#/components/schemas/Tokens'),
                  ),
                },
              ),
              '400': oapi.Response(description: 'Bad request'),
              '403': oapi.Response(description: 'Forbidden'),
            },
          ),
        ),
        '/auth/refresh': oapi.PathItem(
          get: oapi.Operation(
            summary: 'Refresh access token using refresh token',
            tags: ['auth'],
            security: [
              oapi.Security(
                name: 'bearer-refresh',
                scopes: [],
              ),
            ],
            responses: {
              '200': oapi.Response(
                description: 'Tokens refreshed successfully',
                content: {
                  'application/json': oapi.MediaType(
                    schema: oapi.Schema.object(ref: '#/components/schemas/Tokens'),
                  ),
                },
              ),
              '400': oapi.Response(description: 'Bad request'),
              '403': oapi.Response(description: 'Forbidden'),
            },
          ),
        ),
      },
    );

    injector.replaceInstance<oapi.OpenApi>(openapi);
  }

  Future<Response> _meHandler(Request request, AutoInjector injector) async {
    final header = request.headers['Authorization'];
    if (header == null || !header.toLowerCase().startsWith('bearer ')) {
      return Response(400, body: jsonEncode({"error": 'Missing or invalid Authorization header'}));
    }
    final token = header.substring(7);

    final jwtService = injector.get<JwtService>();

    final claims = jwtService.verifyToken(token);
    if (claims == null) {
      return Response.forbidden(jsonEncode({'error': 'Invalid token'}));
    }
    final username = claims['sub'];
    if (username == null) {
      return Response.forbidden(jsonEncode({'error': 'Token missing subject'}));
    }
    final userDetailsService = injector.tryGet<UserDetailsService>();
    if (userDetailsService == null) {
      return Response(500, body: jsonEncode({'error': 'UserDetailsService not available. Please register it.'}));
    }
    final userDetails = await userDetailsService.loadUserByUsername(username);
    if (userDetails == null) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    final responseData = {
      'username': userDetails.username,
      'roles': userDetails.roles,
    };
    return Response.ok(jsonEncode(responseData), headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _handleLogin(Request request, AutoInjector injector) async {
    final headers = request.headers;
    final basic = headers['Authorization'];
    if (basic == null || !basic.toLowerCase().startsWith('basic ')) {
      return Response(400, body: jsonEncode({'error': 'Missing or invalid Authorization header'}));
    }
    final encodedCredentials = basic.substring(6);
    final decodedCredentials = utf8.decode(base64.decode(encodedCredentials));
    final credentials = decodedCredentials.split(':');
    if (credentials.length != 2) {
      return Response(400, body: jsonEncode({'error': 'Invalid credentials format'}));
    }
    final username = credentials[0];
    final rawPassword = credentials[1];
    if (username.isEmpty || rawPassword.isEmpty) {
      return Response(400, body: jsonEncode({'error': 'Missing username or password'}));
    }

    final userDetailsService = injector.tryGet<UserDetailsService>();
    if (userDetailsService == null) {
      return Response(500, body: jsonEncode({'error': 'UserDetailsService not available. Please register it.'}));
    }

    final userDetails = await userDetailsService.loadUserByUsername(username);
    if (userDetails == null) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    final passwordEncoder = injector.get<PasswordEncoder>();
    if (!passwordEncoder.matches(rawPassword, userDetails.password)) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    final jwtService = injector.get<JwtService>();
    final accessToken = jwtService.generateToken(userDetails);
    final refreshToken = jwtService.generateToken(
      userDetails,
      claims: {'refresh': true},
      isRefreshToken: true,
    );
    final responseData = {'access_token': accessToken, 'refresh_token': refreshToken};

    return Response.ok(jsonEncode(responseData), headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _handleRefresh(Request request, AutoInjector injector) async {
    final header = request.headers['Authorization'];
    if (header == null || !header.toLowerCase().startsWith('bearer ')) {
      return Response(400, body: jsonEncode({"error": 'Missing or invalid Authorization header'}));
    }
    final refreshToken = header.substring(7);

    final jwtService = injector.get<JwtService>();
    final claims = jwtService.verifyToken(refreshToken);
    if (claims == null || claims['refresh'] != true) {
      return Response.forbidden(jsonEncode({'error': 'Invalid or non-refresh token'}));
    }

    final username = claims['sub'];
    if (username == null) {
      return Response.forbidden(jsonEncode({'error': 'Token missing subject'}));
    }

    final userDetailsService = injector.tryGet<UserDetailsService>();
    if (userDetailsService == null) {
      return Response(500, body: jsonEncode({'error': 'UserDetailsService not available. Please register it.'}));
    }

    final userDetails = await userDetailsService.loadUserByUsername(username);
    if (userDetails == null) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    final accessToken = jwtService.generateToken(userDetails);
    final newRefreshToken = jwtService.generateToken(
      userDetails,
      claims: {'refresh': true},
      isRefreshToken: true,
    );
    final responseData = {'access_token': accessToken, 'refresh_token': newRefreshToken};

    return Response.ok(jsonEncode(responseData), headers: {'Content-Type': 'application/json'});
  }
}
