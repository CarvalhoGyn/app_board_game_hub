import 'package:flutter/material.dart';
import '../utils/game_data_localizer.dart';
import '../services/translation_service.dart';
import '../l10n/app_localizations.dart';

class LocalizedTag extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const LocalizedTag({
    super.key,
    required this.text,
    this.style,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  @override
  State<LocalizedTag> createState() => _LocalizedTagState();
}

class _LocalizedTagState extends State<LocalizedTag> {
  late String _displayText;
  bool _isTranslatedByIA = false;
  String? _currentLocale;

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = AppLocalizations.of(context)?.localeName ?? 'pt';
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      _localize();
    }
  }

  @override
  void didUpdateWidget(LocalizedTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _localize();
    }
  }

  void _localize() {
    final locale = _currentLocale ?? 'pt';
    
    // 1. Dicionário (Instantâneo)
    final dictTranslation = GameDataLocalizer.localize(widget.text, locale);
    
    if (dictTranslation != widget.text) {
      _displayText = dictTranslation;
      _isTranslatedByIA = false;
    } else if (locale != 'en') {
      // 2. Fallback ML Kit (Assíncrono se não for inglês)
      _displayText = widget.text;
      _translateViaIA(locale);
    } else {
      _displayText = widget.text;
    }
  }

  Future<void> _translateViaIA(String locale) async {
    try {
      final translated = await TranslationService.translate(widget.text, locale);
      if (mounted && translated != widget.text) {
        setState(() {
          _displayText = translated;
          _isTranslatedByIA = true;
        });
      }
    } catch (_) {
      // Mantenha o original se falhar
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha:0.3);
    
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
      ),
      child: Text(
        _displayText,
        style: widget.style ?? TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurface.withValues(alpha:0.9),
          fontStyle: _isTranslatedByIA ? FontStyle.italic : FontStyle.normal, // Pequena dica visual
        ),
      ),
    );
  }
}
