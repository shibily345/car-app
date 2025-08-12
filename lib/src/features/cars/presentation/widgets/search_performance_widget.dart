import 'package:flutter/material.dart';
import 'dart:async';

/// A debounced search widget that optimizes performance by reducing
/// the number of search operations during rapid typing
class DebouncedSearchField extends StatefulWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  final Duration debounceDuration;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

  const DebouncedSearchField({
    super.key,
    required this.hintText,
    required this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.controller,
    this.focusNode,
    this.decoration,
  });

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  Timer? _debounceTimer;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearchChanged(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
      style: TextStyle(
        fontSize: 16,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

/// A cache for search results to improve performance
class SearchResultCache {
  static final Map<String, List<dynamic>> _cache = {};
  static const int _maxCacheSize = 100;

  static void cacheResults(String query, List<dynamic> results) {
    if (_cache.length >= _maxCacheSize) {
      // Remove oldest entry
      _cache.remove(_cache.keys.first);
    }
    _cache[query.toLowerCase()] = results;
  }

  static List<dynamic>? getCachedResults(String query) {
    return _cache[query.toLowerCase()];
  }

  static void clearCache() {
    _cache.clear();
  }

  static bool hasCachedResults(String query) {
    return _cache.containsKey(query.toLowerCase());
  }
}

/// A widget that shows search suggestions based on recent searches
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionSelected;
  final int maxSuggestions;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
    this.maxSuggestions = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displaySuggestions = suggestions.take(maxSuggestions).toList();

    if (displaySuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: displaySuggestions.map((suggestion) {
          return ListTile(
            leading: Icon(
              Icons.history,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
              size: 20,
            ),
            title: Text(
              suggestion,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            onTap: () => onSuggestionSelected(suggestion),
          );
        }).toList(),
      ),
    );
  }
}
