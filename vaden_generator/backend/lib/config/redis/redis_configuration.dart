import 'package:redis/redis.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class RedisConfiguration {
  @Bean()
  Future<Command> redisCommand(ApplicationSettings settings) {
    final host = settings['redis']['host'] ?? 'localhost';
    final port = settings['redis']['port'] ?? 6379;
    final connection = RedisConnection();
    return connection.connect(host, port);
  }
}
