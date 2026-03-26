import '../env/env.dart';

class AiConfig {
  static String get apiKey => Env.geminiApiKey;
  
  // Model to use
  static const String modelName = 'gemini-1.5-flash';

  static bool get hasApiKey => apiKey.isNotEmpty && !apiKey.contains('PLACEHOLDER');
}
