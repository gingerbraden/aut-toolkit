import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/router_utils.dart';
import '../../../../i18n/strings.g.dart';

class VisualSupportsPage extends StatefulWidget {
  const VisualSupportsPage({super.key});

  @override
  State<VisualSupportsPage> createState() => _VisualSupportsPageState();
}

class _VisualSupportsPageState extends State<VisualSupportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.visual_supports),
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
              _buildCard(
                t.visual_schedules,
                t.visual_schedule_desc,
                RouterUtils.getCardsPath(),
              ),
              const SizedBoxDivider(),
              _buildCard(
                t.first_then_boards,
                t.first_then_boards_desc,
                RouterUtils.getCardsPath(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, String route) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        router.push(route);
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
}
