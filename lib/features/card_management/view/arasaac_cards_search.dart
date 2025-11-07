import 'dart:convert';

import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/scaffold_messenger_util.dart';
import 'package:aut_toolkit/core/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/router.dart';
import '../../../core/model/Pictogram.dart';
import '../../../core/repository/arasaac_repository.dart';
import '../../../i18n/strings.g.dart';

class ARASAACCardsSearch extends StatefulWidget {
  const ARASAACCardsSearch({super.key});

  @override
  State<ARASAACCardsSearch> createState() => _ARASAACCardsSearchState();
}

class _ARASAACCardsSearchState extends State<ARASAACCardsSearch> {
  final ARASAACRepository _repo = ARASAACRepository();
  final TextEditingController _searchController = TextEditingController();
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<List<Pictogram>>? _futurePictograms;
  String _lastQuery = '';

  Map<String, List<String>> _translations = {};

  Future<void> _loadTranslations() async {
    final jsonString = await rootBundle.loadString('res/sk-en.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      _translations = jsonMap.map((key, value) => MapEntry(StringUtils().removeDiacritics(key), List<String>.from(value)));
    });
  }

  @override
  void initState() {
    super.initState();
    _translations.clear();
    _loadTranslations();
  }

  void _performSearch() {
    final query = StringUtils().removeDiacritics(_searchController.text.trim());
    if (query.isEmpty || query == _lastQuery || !_translations.keys.contains(query)) {
      ScaffoldMessengerUtils().showSnackBar(context, t.no_icons_found);
      return;
    };
    setState(() {
      _lastQuery = query;
      _futurePictograms = _repo.searchPictograms(_translations[query]!.join(" "));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _translations.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.arasaac_icons), elevation: 0, forceMaterialTransparency: true,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _searchField()),
                const SizedBox(width: 8),
                _searchButton(),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Divider(),
            ),
            _pictogramList()
          ],
        ),
      ),
    );
  }

  Widget _searchField() => TextField(
    controller: _searchController,
    onSubmitted: (_) => _performSearch(),
    style: const TextStyle(fontSize: 16),
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintText: t.search,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(99),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    ),
  );

  Widget _searchButton() => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: Icon(Icons.search,
          color: Theme.of(context).colorScheme.onPrimaryContainer),
      tooltip: t.search,
      onPressed: _performSearch,
    ),
  );

  Widget _buildPictogramTile(Pictogram pictogram) {
    final url = _repo.getPictogramUrl(pictogram.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final bool? confirmed = await _showConfirmDialog(pictogram);
          if (confirmed == true) {
            Navigator.pop(context, url); // Return the pictogram URL (or pictogram.id if you prefer)
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) =>
                const Center(child: Icon(Icons.broken_image, size: 32)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(Pictogram pictogram) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.use_this_image),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _repo.getPictogramUrl(pictogram.id),
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.no),
          ),
          FilledButton(
            onPressed: () => {
              asyncPrefs.setString('imgPath', _repo.getPictogramUrl(pictogram.id)),
              router.pop(true)
            },
            child: Text(t.yes),
          ),
        ],
      ),
    );
  }

  Expanded _pictogramList() {
    return Expanded(
      child: FutureBuilder<List<Pictogram>>(
        future: _futurePictograms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final pictograms = snapshot.data ?? [];

          if (pictograms.isEmpty) {
            return Center(child: Text(t.no_entries));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              const double minItemWidth = 140;
              final int crossAxisCount = (constraints.maxWidth / minItemWidth)
                  .floor()
                  .clamp(3, 8);

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: pictograms.length,
                itemBuilder: (_, i) {
                  final picto = pictograms[i];
                  return _buildPictogramTile(picto);
                },
              );
            },
          );
        },
      ),
    );
  }




}
