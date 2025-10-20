import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../i18n/strings.g.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              buildCard(
                t.eating_habits,
                  "Description duis aute irure dolor in reprehenderit in voluptsafweffffffffffffffffffate velit.",
                  RouterUtils.getEatingHabitsPath() // route
              ),
              const SizedBox(height: 8),
              buildCard(
                t.good_habits,
                "Description duis aute irure dolor in reprehenderit in voluptate velit.",
                'TODO',
              ),
              const SizedBox(height: 8),
              buildCard(
                t.bad_habits,
                "Description duis aute irure dolor in reprehenderit in voluptate velit.",
                'TODO',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title, String subtitle, String route) {
    return InkWell(
      borderRadius: BorderRadius.circular(16), // Ripple effect boundary
      onTap: () {
        router.push(route); // Navigate to the route
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
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge,
                            softWrap: true,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Theme
                              .of(context)
                              .textTheme
                              .titleLarge!
                              .color,
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall,
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
