/// Basic InputConverter utility for parsing and validating input
class InputConverter {
  /// Converts a string to an unsigned integer
  int? stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) return null;
      return integer;
    } catch (_) {
      return null;
    }
  }
}
