import 'package:vaden/vaden.dart';

import '../config/security/user_details_service.dart';

@Api(tag: 'User')
@Controller('/user')
class UserController {
  @Get('/')
  User getUser(@Context('user') User user) {
    return user;
  }
}
