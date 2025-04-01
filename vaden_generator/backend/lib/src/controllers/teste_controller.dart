import 'package:backend/src/domain/entities/backer.dart';
import 'package:vaden/vaden.dart';

@Api(tag: 'teste', description: 'teste')
@Controller('/v1/teste')
class TesteController {
  @ApiOperation(summary: 'teste')
  @ApiResponse(
    200,
    description: 'Check backer',
    content: ApiContent(type: 'application/json', schema: Backer),
  )
  @Post('/')
  Future<Teste> getDependencies(@Body() Teste dto) async {
    print(dto.list);

    return dto;
  }
}

@DTO()
class Teste {
  final String name;
  final List<String> list;
  Teste({
    required this.name,
    required this.list,
  });
}
