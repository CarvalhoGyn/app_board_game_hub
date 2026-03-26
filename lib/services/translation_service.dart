import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class TranslationService {
  static TranslateLanguage _mapCode(String code) {
    if (code.startsWith('pt')) return TranslateLanguage.portuguese;
    if (code.startsWith('fr')) return TranslateLanguage.french;
    if (code.startsWith('de')) return TranslateLanguage.german;
    if (code.startsWith('en')) return TranslateLanguage.english;
    return TranslateLanguage.english;
  }

  static Future<String> translate(String text, String targetCode) async {
    if (text.isEmpty) return text;
    
    // 1. Identify Source Language
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    final String sourceCode = await languageIdentifier.identifyLanguage(text);
    await languageIdentifier.close();

    // If already in target language (or same family), return original
    if (sourceCode == targetCode || (sourceCode.startsWith('und'))) {
      // If undetermined and we are translating from description, assume English
      if (text.length < 10) return text; 
    }
    
    if (sourceCode == targetCode) return text;

    final sourceLanguage = _mapCode(sourceCode);
    final targetLanguage = _mapCode(targetCode);
    final modelManager = OnDeviceTranslatorModelManager();
    
    // Check and download models
    // We use the raw codes detected or mapped
    if (!(await modelManager.isModelDownloaded(sourceCode))) {
      await modelManager.downloadModel(sourceCode);
    }
    if (!(await modelManager.isModelDownloaded(targetCode))) {
      await modelManager.downloadModel(targetCode);
    }

    final translator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    try {
      final String result = await translator.translateText(text);
      return result;
    } catch (e) {
      return text;
    } finally {
      await translator.close();
    }
  }
}
