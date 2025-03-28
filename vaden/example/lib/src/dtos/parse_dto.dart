import 'package:vaden/vaden.dart';

@DTO()
class BaseDto {
  final String id;

  @UseParse(DateTimeParse)
  final DateTime createdAt;

  @UseParse(DateTimeParse)
  final DateTime? updatedAt;

  BaseDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}

class DateTimeParse extends ParamParse<DateTime?, String> {
  const DateTimeParse();

  @override
  String toJson(DateTime? param) {
    return param?.toIso8601String() ?? '';
  }

  @override
  DateTime? fromJson(String? json) {
    return DateTime.tryParse(json ?? '');
  }
}

@Api(tag: 'parse')
@Controller('/parse')
class ParseController {
  @Post('/')
  BaseDto get(@Body() BaseDto dto) {
    return dto;
  }
}
