import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';

class LogOutTile extends ConsumerStatefulWidget {
  const LogOutTile({super.key});

  @override
  ConsumerState<LogOutTile> createState() => _LogOutTileState();
}

class _LogOutTileState extends ConsumerState<LogOutTile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: Text(t.log_out),
      onTap: isLoading ? null : _confirmSignOut,
      trailing: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
    );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.really_log_out),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.yes),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await _signOut();
    }
  }

  Future<void> _signOut() async {
    setState(() => isLoading = true);
    await ref.read(authentificationNotifierProvider.notifier).signOut();
    setState(() => isLoading = false);
    router.go('/');
  }
}
