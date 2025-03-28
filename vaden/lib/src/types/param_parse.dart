abstract class ParamParse<P, R> {
  const ParamParse();

  R toJson(P param);

  P fromJson(R json);
}
