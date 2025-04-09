import 'package:vaden/vaden.dart';

@Api(tag: 'empty')
@Controller('/')
class EmptyController {
  @Get()
  String empty() {
    return 'empty';
  }
}
