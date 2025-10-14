import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              buildCard(
                t.eating_habits,
                "Description duis aute irure dolor in reprehenderit in voluptsafweffffffffffffffffffate velit.",
              ),
              buildCard(
                t.good_habits,
                "Description duis aute irure dolor in reprehenderit in voluptate velit.",
              ),
              buildCard(
                t.bad_habits,
                "Description duis aute irure dolor in reprehenderit in voluptate velit.",
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded( // <-- Make the Column flexible
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
                    Icon(Icons.arrow_forward_rounded, color: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .color,)
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
    );
  }


}
