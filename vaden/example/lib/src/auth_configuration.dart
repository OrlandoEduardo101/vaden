import 'package:vaden/vaden.dart';

import 'envtest.dart';

@Configuration()
class AuthConfiguration {
  @Bean()
  Future<MyEnv> myEnv(DSON factory) async {
    return MyEnv('http://localhost:3000', 'myToken');
  }
}
