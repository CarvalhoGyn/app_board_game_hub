import 'package:flutter/material.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class PrivacyAgreementScreen extends StatelessWidget {
  final bool showOnlyPrivacy;
  const PrivacyAgreementScreen({super.key, this.showOnlyPrivacy = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          showOnlyPrivacy ? l10n.privacyPolicy : l10n.termsOfService,
          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showOnlyPrivacy) ...[
              _buildSectionTitle(l10n.termsOfService, theme),
              const SizedBox(height: 12),
              _buildSectionBody(l10n.termsOfServiceContent, theme),
              const SizedBox(height: 32),
            ],
            _buildSectionTitle(l10n.privacyPolicy, theme),
            const SizedBox(height: 12),
            _buildSectionBody(l10n.privacyPolicyContent, theme),
            const SizedBox(height: 48),
            Center(
              child: Text(
                "MeepleSync v1.0.0",
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildSectionBody(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        height: 1.6,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
