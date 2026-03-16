import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/model/Pictogram.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/arasaac_cards_search_viewmodel.dart';

class ARASAACCardsSearch extends ConsumerStatefulWidget {
  const ARASAACCardsSearch({super.key});

  @override
  ConsumerState<ARASAACCardsSearch> createState() => _ARASAACCardsSearchState();
}

class _ARASAACCardsSearchState extends ConsumerState<ARASAACCardsSearch> {
  late final viewModel = ref.read(arasaacCardsSearchViewModelProvider.notifier);

  @override
  void dispose() {
    viewModel.clearState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(arasaacCardsSearchViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.arasaac_icons),
        elevation: 0,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copyright),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Copyright'),
                  content: const Text('The pictographic symbols used are the property of the Government of Aragón and have been created by Sergio Palao for ARASAAC (http://www.arasaac.org), that distributes them under Creative Commons License BY-NC-SA.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: state.searchController,
                    onSubmitted: (_) => viewModel.performSearch(context),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: t.search,
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    tooltip: t.search,
                    onPressed: () => viewModel.performSearch(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 10,
                right: 10,
              ),
              child: Divider(),
            ), Expanded(
              child: FutureBuilder<List<Pictogram>>(
                future: state.futurePictograms,
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
                      final crossAxisCount =
                          (constraints.maxWidth / minItemWidth).floor().clamp(
                            3,
                            8,
                          );

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
                          final url = state.repo.getPictogramUrl(picto.id);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                final confirmed = await viewModel
                                    .showConfirmDialog(context, picto);
                                if (confirmed == true) {
                                  Navigator.pop(context, url);
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    AppConstants.BASE_APP_UI_PADDING,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              child: const Center(
                                                child: SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                      ),
                                                ),
                                              ),
                                            );
                                          },
                                      errorBuilder: (_, _, _) => const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
