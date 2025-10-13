import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
          child: ElevatedButton(
            onPressed: isLoading ? null : () async {
              setState(() {
                isLoading = true;
              });

              await ref
                  .read(authentificationNotifierProvider.notifier)
                  .signOut();

              setState(() {
                isLoading = false;
              });

              router.go('/');
            },
            child: isLoading
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text("Sign Out"),
          )
      ),
    );
  }
}
