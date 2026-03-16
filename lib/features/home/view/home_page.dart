import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/core/services/report_printing_service.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/info_small_text.dart';
import 'package:aut_toolkit/features/selected_person/domain/model/selected_person.dart';
import 'package:aut_toolkit/features/selected_person/provider/selected_person_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/pdf_generating_dialog.dart';
import '../../../i18n/strings.g.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _startupSyncDone = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_startupSyncDone) await _runStartupSync();

      final allPersons = ref.read(selectedPersonsProvider);

      if (allPersons.isEmpty) {
        _showCreatePersonDialog();
      }
    });
  }

  Future<void> _runStartupSync() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Padding(
          padding: EdgeInsets.only(top: AppConstants.BASE_APP_UI_PADDING),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(t.data_sync),
            ],
          ),
        ),
      ),
    );

    try {
      await RepoService().fetchAllRemoteData();
    } finally {
      if (mounted) {
        _startupSyncDone = true;
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allPersons = ref.watch(selectedPersonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home),
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedPersonArea(allPersons),
              Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 8,
                  left: 10,
                  right: 10,
                ),
                child: Divider(),
              ),
              _buildCard(
                t.eating_habits,
                t.eating_habits_desc,
                RouterUtils.getEatingHabitsPath(),
              ),
              const SizedBox(height: 8),
              _buildCard(
                t.challenging_behaviour,
                t.challenging_behaviour_desc,
                RouterUtils.getChallengingBehavioursPath(),
              ),
              const SizedBox(height: 8),
              _buildCard(
                t.good_habits,
                t.good_habits_desc,
                RouterUtils.getGoodHabitsPath(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 10,
                  right: 10,
                ),
                child: Divider(),
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: _buildCard(
                          t.visual_supports,
                          t.visual_supports_desc,
                          RouterUtils.getVisualSupportsPagePath(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        child: _buildCard(
                          t.cards,
                          t.cards_desc,
                          RouterUtils.getCardsPath(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 10,
                  right: 10,
                ),
                child: Divider(),
              ),
              _buildCard(
                t.pdf_report_creation,
                t.pdf_report_creation_desc,
                null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showCreatePersonDialog() async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            String name = '';
            return AlertDialog(
              title: Text(t.add_managed_person),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => name = value,
                    decoration: InputDecoration(hintText: t.name),
                  ),
                  SizedBox(height: AppConstants.BASE_APP_UI_PADDING),
                  InfoSmallText(description: t.add_person_info),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(t.cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (name.isNotEmpty) {
                      final docRef = FirebaseFirestore.instance
                          .collection('selected_persons')
                          .doc();
                      final newPerson = SelectedPerson(
                        userId: FirebaseService().currentUser!.uid,
                        name: name,
                        isSelected: false,
                        remoteId: docRef.id,
                        updatedAt: DateTime.now(),
                      );

                      ref.read(selectedPersonsProvider.notifier).add(newPerson);

                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text(t.create),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildCard(String title, String subtitle, String? route) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        if (route != null) {
          router.push(route);
        } else {
          await PdfGeneratingWaitingDialog.show(
            context,
            message: t.preparing_pdf,
          );

          try {
            await ReportPrintingService().generateAndSharePdf();
          } finally {
            if (mounted) {
              PdfGeneratingWaitingDialog.hide(context);
            }
          }
        }
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium,
                            softWrap: true,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Theme.of(
                            context,
                          ).textTheme.headlineMedium!.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedPersonArea(List<SelectedPerson> allPersons) {
    final selected = allPersons.isEmpty
        ? null
        : allPersons.firstWhere(
            (sp) => sp.isSelected,
            orElse: () => allPersons.first,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DropdownButtonFormField<SelectedPerson>(
                  initialValue: selected,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: [
                    ...allPersons.map((person) {
                      return DropdownMenuItem<SelectedPerson>(
                        value: person,
                        child: Text(
                          person.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                    }),
                    DropdownMenuItem<SelectedPerson>(
                      value: null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.add_managed_person,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (person) async {
                    if (person == null) {
                      final previousSelected = selected;
                      final ret = await _showCreatePersonDialog();
                      if (!ret && previousSelected != null) {
                        ref
                            .read(selectedPersonsProvider.notifier)
                            .add(previousSelected);
                      }
                    } else {
                      ref.read(selectedPersonsProvider.notifier).add(person);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
