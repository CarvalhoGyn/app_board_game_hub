import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/ai_config.dart';

class AiMessageService {
  static Future<String> generateWinnerMessage(String gameName, String winnerName, int score, List<int> allScores) async {
    // Analyze Context
    bool isSolo = allScores.length == 1;
    bool isCloseMatch = false;
    bool isLandslide = false;

    if (!isSolo) {
      final sortedScores = List<int>.from(allScores)..sort((a, b) => b.compareTo(a));
      if (sortedScores.length >= 2) {
        int diff = sortedScores[0] - sortedScores[1];
        if (diff <= 5) isCloseMatch = true;
        if (diff >= 20) isLandslide = true;
      }
    }

    // Attempt Gemini API Call if available
    if (AiConfig.hasApiKey) {
       try {
          final model = GenerativeModel(model: AiConfig.modelName, apiKey: AiConfig.apiKey);
          
          String contextPrompt = '';
          if (isSolo) contextPrompt = "This was a solo game session.";
          else if (isLandslide) contextPrompt = "It was a crushing victory, a landslide!";
          else if (isCloseMatch) contextPrompt = "It was a very close match, down to the wire.";
          else contextPrompt = "It was a standard balanced match.";

          final prompt = 'Write a short, fun, emojis-filled victory notification message (max 20 words) for a board game match. '
                         'Game: "$gameName". Winner: "$winnerName". '
                         'Context: $contextPrompt. '
                         'Do NOT mention specific point values. '
                         'Make it feel tailored to the game theme if possible.';

          final response = await model.generateContent([Content.text(prompt)]);
          
          if (response.text != null && response.text!.isNotEmpty) {
             return response.text!;
          }
       } catch (e) {
          // Fallback implicitly
          print('Gemini API Error: $e');
       }
    }
    
    // Simulate "Thinking" delay if falling back (to match expected UX or avoid instant flicker if api fails)
    await Future.delayed(const Duration(seconds: 1));
    return _generateFallbackMessage(gameName, winnerName, isSolo: isSolo, isLandslide: isLandslide, isCloseMatch: isCloseMatch);
  }

  static Future<String> translateText(String text, String targetLanguageCode) async {
    if (!AiConfig.hasApiKey) {
      return text; // No translation possible
    }

    try {
      final model = GenerativeModel(model: AiConfig.modelName, apiKey: AiConfig.apiKey);
      
      // Map language code to full name for the prompt
      String langName = 'the user\'s local language';
      if (targetLanguageCode == 'pt') langName = 'Portuguese (Brazil)';
      if (targetLanguageCode == 'fr') langName = 'French';
      if (targetLanguageCode == 'de') langName = 'German';
      
      final prompt = 'Translate the following board game description into $langName. '
                     'Keep the tone engaging and professional. Preserve any formatting. '
                     'Only return the translated text without any explanations.\n\n'
                     'Text to translate: "$text"';

      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text != null && response.text!.isNotEmpty) {
         return response.text!.trim();
      }
    } catch (e) {
      print('Gemini Translation Error: $e');
    }
    
    return text; // Fallback to original
  }

  static String _generateFallbackMessage(String gameName, String winnerName, {required bool isSolo, required bool isLandslide, required bool isCloseMatch}) {
    List<String> templates = [];

    if (isSolo) {
        templates = [
            "Solo Master! $winnerName beat the game in $gameName. Can you do it again? 🃏",
            "A solitary victory! $winnerName conquered $gameName. Well played! 🧩",
            "$winnerName fought the board in $gameName and won! 🛡️",
        ];
    } else if (isLandslide) {
        templates = [
            "Total DOMINATION! 💥 $winnerName crushed everyone in $gameName!",
            "Unstoppable! $winnerName leaves the competition in the dust in $gameName! 🚀",
            "Is there no one else?! $winnerName destroys the table at $gameName! 👑",
        ];
    } else if (isCloseMatch) {
         templates = [
            "What a nail-biter! 💅 $winnerName barely squeaked out a win in $gameName!",
            "Down to the wire! $winnerName takes the victory in $gameName. GG! 🏁",
            "So close! But $winnerName emerged victorious in $gameName! 🧠",
        ];
    } else {
        // Generic Balanced
        templates = [
            "Congratulations $winnerName! You won $gameName! 🏆",
            "Victory for $winnerName! A great match of $gameName showing true strategy! 🌟",
            "The board bows to $winnerName! Champion of $gameName! 🎲",
        ];
    }

    // Check for game-specific flavor
    List<String> gameSpecific = _getGameFlavor(gameName, winnerName);
    if (gameSpecific.isNotEmpty) {
      // 50% chance to use game specific flavor to keep variety
      if (DateTime.now().millisecond % 2 == 0) {
         templates = gameSpecific;
      }
    }

    return (templates..shuffle()).first;
  }

  static List<String> _getGameFlavor(String gameName, String winnerName) {
     final name = gameName.toLowerCase();
     if (name.contains('catan')) {
        return [
           "Lord of Catan! 🐑 $winnerName built the longest road to victory!",
           "No sheep for you! $winnerName monopolized the win in $gameName! 🧱",
           "$winnerName settled exactly where they needed to win $gameName! 🌾",
        ];
     }
     if (name.contains('ticket') || name.contains('ride')) {
        return [
           "Choo choo! 🚂 $winnerName completed the ultimate route in $gameName!",
           "$winnerName is on track! A full steam victory in $gameName! 🎫",
        ];
     }
     if (name.contains('zombicide') || name.contains('zombie')) {
        return [
           "Survivor! 🧟‍♂️ $winnerName killed the most zombies and survived $gameName!",
           "Brains?! No, just wins! $winnerName escaped the horde in $gameName! 🔫",
        ];
     }
     if (name.contains('monopoly')) {
        return [
           "Bankrupting the competition! 💸 $winnerName owns it all in $gameName!",
           "Do not pass Go, go straight to the winner's circle! Congrats $winnerName! 🎩",
        ];
     }
     if (name.contains('terraforming') || name.contains('mars')) {
        return [
           "The Red Planet is yours! 🚀 $winnerName terraformed their way to victory in $gameName!",
           "$winnerName controls the spice... err, the TR! Victory in $gameName! 🌌",
        ];
     }
     if (name.contains('wing') || name.contains('span')) {
        return [
           "Flying high! 🦅 $winnerName had the best habitat in $gameName!",
           "Egg-cellent strategy! $winnerName hatched a victory in $gameName! 🥚",
        ];
     }
     return [];
  }
}
