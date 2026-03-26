import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/localization_provider.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final bool showLabel;
  final Color? color;

  const LanguageSelector({
    super.key, 
    this.showLabel = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final localizationProvider = context.watch<LocalizationProvider>();
    final theme = Theme.of(context);

    String getFlag(String code) {
      switch (code) {
        case 'en': return '🇺🇸';
        case 'pt': return '🇧🇷';
        case 'de': return '🇩🇪';
        case 'fr': return '🇫🇷';
        default: return '🏳️';
      }
    }

    String getDisplayName(String code) {
      switch (code) {
        case 'en': return 'English';
        case 'pt': return 'Português';
        case 'de': return 'Deutsch';
        case 'fr': return 'Français';
        default: return code.toUpperCase();
      }
    }

    final currentLocale = localizationProvider.locale;

    return PopupMenuButton<Locale>(
      initialValue: currentLocale,
      onSelected: (Locale newLocale) {
        localizationProvider.setLocale(newLocale);
      },
      tooltip: 'Select Language',
      // Estilo do Botão Principal
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getFlag(currentLocale.languageCode), style: const TextStyle(fontSize: 18)),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                getDisplayName(currentLocale.languageCode).toUpperCase(), 
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
              ),
            ],
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: color ?? theme.colorScheme.onSurface, size: 16),
          ],
        ),
      ),
      // Estilo do Menu Suspenso
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      itemBuilder: (BuildContext context) {
        return AppLocalizations.supportedLocales.map((Locale locale) {
          final isSelected = locale == currentLocale;
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(getFlag(locale.languageCode), style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    getDisplayName(locale.languageCode),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (isSelected) 
                  Icon(Icons.check_circle, color: theme.primaryColor, size: 18),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
