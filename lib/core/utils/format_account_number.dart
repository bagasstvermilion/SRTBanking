class FormatAccountNumber {
  static String format(String input) {
    final buffer = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write('-');
      }
      buffer.write(input[i]);
    }

    return buffer.toString();
  }
}
