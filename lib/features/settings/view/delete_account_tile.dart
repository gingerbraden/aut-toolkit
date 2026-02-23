import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';

class DeleteAccountTile extends ConsumerStatefulWidget {
  const DeleteAccountTile({super.key});

  @override
  ConsumerState<DeleteAccountTile> createState() => _DeleteAccountTileState();
}

class _DeleteAccountTileState extends ConsumerState<DeleteAccountTile> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: Text(
        t.delete_account_name,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: isDeleting ? null : _confirmDelete,
      trailing: isDeleting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
    );
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.delete_account),
        content: Text(t.delete_account_info),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => isDeleting = true);

    final authNotifier = ref.read(authentificationNotifierProvider.notifier);
    final result = await authNotifier.deleteAccount();

    setState(() => isDeleting = false);

    if (result == 'requires-recent-login') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.delete_reauthenticate)));
    } else if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.delete_success)));
      router.go('/');
    }
  }
}
