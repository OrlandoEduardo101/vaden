class Glob {
  final String pattern;
  late final List<String> _patternSegments;

  Glob(this.pattern) {
    _patternSegments = _splitPattern(pattern);
  }

  // Divide o padrão mantendo segmentos vazios, para lidar com
  // caminhos que começam ou terminam com '/'
  List<String> _splitPattern(String pattern) {
    return pattern.split('/');
  }

  /// Retorna true se [input] casar com o padrão.
  bool matches(String input) {
    final inputSegments = input.split('/');
    return _matchSegments(_patternSegments, inputSegments);
  }

  /// Função recursiva que casa os segmentos do padrão com os segmentos de input.
  bool _matchSegments(List<String> pat, List<String> inp) {
    // Se ambos estão vazios, deu match
    if (pat.isEmpty && inp.isEmpty) return true;
    // Se o padrão acabou mas ainda há input, não casa
    if (pat.isEmpty) return false;
    // Se o input acabou, o padrão só pode casar se os segmentos restantes forem '**'
    if (inp.isEmpty) {
      for (final segment in pat) {
        if (segment != '**') return false;
      }
      return true;
    }

    final firstPat = pat.first;

    if (firstPat == '**') {
      // '**' pode casar com zero ou mais segmentos:
      // Opção 1: ignore '**' (casando zero segmentos)
      if (_matchSegments(pat.sublist(1), inp)) return true;
      // Opção 2: faça '**' casar com o primeiro segmento e continue
      if (_matchSegments(pat, inp.sublist(1))) return true;
      return false;
    } else {
      // Para outros segmentos, use a função que casa com '*' dentro do segmento
      if (!_matchSegment(firstPat, inp.first)) return false;
      return _matchSegments(pat.sublist(1), inp.sublist(1));
    }
  }

  /// Casa um segmento do padrão com um segmento do input, considerando o curing '*'.
  bool _matchSegment(String patternSegment, String inputSegment) {
    int p = 0, s = 0;
    int starIndex = -1, matchIndex = 0;

    while (s < inputSegment.length) {
      if (p < patternSegment.length &&
          (patternSegment[p] == inputSegment[s] || patternSegment[p] == '*')) {
        if (patternSegment[p] == '*') {
          starIndex = p;
          matchIndex = s;
          p++; // Avança além do '*'
        } else {
          p++;
          s++;
        }
      } else if (starIndex != -1) {
        // Se houver um '*' anterior, retrocede e tenta casar mais caracteres
        p = starIndex + 1;
        matchIndex++;
        s = matchIndex;
      } else {
        return false;
      }
    }
    // Consome os '*' restantes no padrão
    while (p < patternSegment.length && patternSegment[p] == '*') {
      p++;
    }
    return p == patternSegment.length;
  }
}
