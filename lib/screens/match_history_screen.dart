import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'record_match_score.dart';
import '../widgets/staggered_slide_fade.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class MatchHistoryScreen extends StatefulWidget {
  final String userId;
  const MatchHistoryScreen({super.key, required this.userId});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  List<MatchWithDetails> _allMatches = [];
  List<MatchWithDetails> _filteredMatches = [];
  bool _isLoading = true;

  int? _selectedYear;
  int? _selectedMonth;
  StreamSubscription<List<MatchWithDetails>>? _subscription;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  void _loadMatches() {
    final matchesDao = context.read<MatchesDao>();
    _subscription = matchesDao.watchMatchesForUser(widget.userId).listen((matches) {
      if (mounted) {
        setState(() {
          _allMatches = matches;
          _isLoading = false;
          _applyFilters();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredMatches = _allMatches.where((m) {
        final date = m.match.date;
        if (_selectedYear != null && date.year != _selectedYear) return false;
        if (_selectedMonth != null && date.month != _selectedMonth) return false;
        return true;
      }).toList();
      
      // If no filters are selected, rule says "mostre as 10 ultimas partida".
      // But if user IS filtering, showing only 10 might be confusing if they want to see "All from Jan 2024".
      // I will limit to 10 ONLY if no filters are active, or perhaps show all if filtered.
      // User request: "Mostre as 10 ultimas... Possibilite filtrar".
      // Interpretation: default view = top 10. Filtered view = all matching filter.
      
      if (_selectedYear == null && _selectedMonth == null) {
        _filteredMatches = _filteredMatches.take(10).toList();
      }
    });
  }

  List<int> _getAvailableYears() {
    final years = _allMatches.map((m) => m.match.date.year).toSet().toList();
    years.sort((a, b) => b.compareTo(a)); // Descending
    return years;
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.matchHistory, style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : Column(
            children: [
              _buildFilters(theme, mutedColor),
              Expanded(
                child: _filteredMatches.isEmpty 
                    ? _buildEmptyState(mutedColor)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredMatches.length,
                        itemBuilder: (context, index) {
                          return StaggeredSlideFade(
                            index: index,
                            child: _buildMatchItem(_filteredMatches[index], theme, mutedColor),
                          );
                        },
                      ),
              ),
            ],
          ),
    );
  }

  Widget _buildFilters(ThemeData theme, Color mutedColor) {
    final l10n = AppLocalizations.of(context)!;
    final years = _getAvailableYears();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(bottom: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha:0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown<int>(
              value: _selectedYear,
              hint: l10n.historyYear,
              items: years,
              labelBuilder: (y) => y.toString(),
              onChanged: (val) {
                setState(() {
                   _selectedYear = val;
                });
                _applyFilters();
              },
              theme: theme, mutedColor: mutedColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown<int>(
              value: _selectedMonth,
              hint: l10n.historyMonth,
              items: List.generate(12, (i) => i + 1),
              labelBuilder: (m) => DateFormat('MMMM', Localizations.localeOf(context).languageCode).format(DateTime(2024, m)),
              onChanged: (val) {
                setState(() => _selectedMonth = val);
                _applyFilters();
              },
              theme: theme, mutedColor: mutedColor,
            ),
          ),
           if (_selectedYear != null || _selectedMonth != null)
             IconButton(
               icon: Icon(Icons.clear, color: mutedColor),
               onPressed: () {
                 setState(() {
                   _selectedYear = null;
                   _selectedMonth = null;
                 });
                 _applyFilters();
               },
             ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
    required ThemeData theme,
    required Color mutedColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: TextStyle(color: mutedColor)),
          dropdownColor: theme.cardTheme.color,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item), style: TextStyle(color: theme.colorScheme.onSurface)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color mutedColor) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 64, color: mutedColor.withValues(alpha:0.5)),
          const SizedBox(height: 16),
          Text(l10n.historyNoMatches, style: TextStyle(color: mutedColor)),
        ],
      ),
    );
  }

  Widget _buildMatchItem(MatchWithDetails matchData, ThemeData theme, Color mutedColor) {
     final match = matchData.match;
     final game = matchData.game;
     final l10n = AppLocalizations.of(context)!;
     
     return GestureDetector(
        onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => RecordMatchScore(matchId: match.id)));
        },
        child: Container(
           margin: const EdgeInsets.only(bottom: 12),
           padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
              color: theme.cardTheme.color, 
              borderRadius: BorderRadius.circular(16), 
              border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.05)),
           ),
           child: Row(
              children: [
                 ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                       game.imageUrl ?? '',
                       width: 60, height: 60, fit: BoxFit.cover,
                       errorBuilder: (context, error, stackTrace) => Container(width: 60, height: 60, color: theme.colorScheme.surface),
                    ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          Text(game.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
                          const SizedBox(height: 4),
                          Text(
                             DateFormat('EEE, MMM d, yyyy', Localizations.localeOf(context).languageCode).format(match.date),
                             style: TextStyle(color: mutedColor, fontSize: 13),
                          ),
                          Row(
                            children: [
                              Icon(
                                match.scoringType == 'cooperative' ? Icons.group_work : Icons.emoji_events, 
                                size: 14, 
                                color: theme.primaryColor
                              ),
                              const SizedBox(width: 4),
                              Text(
                                match.scoringType == 'cooperative' ? l10n.cooperative : l10n.competitive,
                                style: TextStyle(color: theme.primaryColor, fontSize: 12),
                              ),
                            ],
                          ),
                       ],
                    ),
                 ),
                 Icon(Icons.chevron_right, color: mutedColor),
              ],
           ),
        ),
     );
  }
}
