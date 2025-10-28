/// Parses .env file content into key-value pairs
class EnvFileParser {
  /// Parse .env file content
  ///
  /// Supports:
  /// - KEY=value
  /// - KEY="value"
  /// - KEY='value'
  /// - Comments with #
  /// - Empty lines
  /// - Whitespace trimming
  Map<String, String> parse(String content) {
    final result = <String, String>{};
    final lines = content.split('\n');

    for (var line in lines) {
      // Trim whitespace
      line = line.trim();

      // Skip empty lines and comments
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      // Find the first = sign
      final separatorIndex = line.indexOf('=');
      if (separatorIndex == -1) {
        // Invalid line, skip it
        continue;
      }

      // Extract key and value
      final key = line.substring(0, separatorIndex).trim();
      var value = line.substring(separatorIndex + 1).trim();

      // Remove quotes if present
      value = _removeQuotes(value);

      // Store in result
      if (key.isNotEmpty) {
        result[key] = value;
      }
    }

    return result;
  }

  /// Remove surrounding quotes from value
  String _removeQuotes(String value) {
    if (value.length < 2) {
      return value;
    }

    // Check for double quotes
    if (value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1);
    }

    // Check for single quotes
    if (value.startsWith("'") && value.endsWith("'")) {
      return value.substring(1, value.length - 1);
    }

    return value;
  }
}