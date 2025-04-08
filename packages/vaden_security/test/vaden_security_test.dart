import 'package:vaden_security/src/glob.dart';

void main() {
  final glob = Glob('/docs/**');

  print(glob.matches('/docs/'));
}
