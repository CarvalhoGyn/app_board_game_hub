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
    final l10n = AppLocalizations.of(context);

    // Map locale code to emoji flag
    // en -> 🇺🇸, pt -> 🇧🇷, de -> 🇩🇪, fr -> 🇫🇷
    String getFlag(String code) {
      switch (code) {
        case 'en': return '🇺🇸';
        case 'pt': return '🇧🇷';
        case 'de': return '🇩🇪';
        case 'fr': return '🇫🇷';
        default: return '🏳️';
      }
    }

    // Map locale code to display name
    String getDisplayName(String code) {
         switch (code) {
        case 'en': return 'English';
        case 'pt': return 'Português';
        case 'de': return 'Deutsch';
        case 'fr': return 'Français';
        default: return code.toUpperCase();
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 10,
             offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: localizationProvider.locale,
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.keyboard_arrow_down, color: color ?? theme.colorScheme.onSurface, size: 20),
          ),
          dropdownColor: theme.cardTheme.color,
          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
          isDense: true,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localizationProvider.setLocale(newLocale);
            }
          },
          selectedItemBuilder: (BuildContext context) {
             return AppLocalizations.supportedLocales.map((Locale locale) {
               return Row(
                  children: [
                    Text(getFlag(locale.languageCode), style: const TextStyle(fontSize: 18)),
                    if (showLabel) ...[
                      const SizedBox(width: 8),
                      Text(getDisplayName(locale.languageCode).toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ],
               );
             }).toList();
          },
          items: AppLocalizations.supportedLocales.map((Locale locale) {
            final isSelected = locale == localizationProvider.locale;
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Row(
                children: [
                  Text(getFlag(locale.languageCode), style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(
                     getDisplayName(locale.languageCode),
                     style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  if (isSelected) ...[
                     const Spacer(),
                     Icon(Icons.check, color: theme.primaryColor, size: 16),
                  ]
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
