import 'package:vaden/vaden.dart';

@DTO()
class Tokenization {
  @JsonKey('access_token')
  final String accessToken;
  @JsonKey('refresh_token')
  final String refreshToken;

  Tokenization({
    required this.accessToken,
    required this.refreshToken,
  });
}
