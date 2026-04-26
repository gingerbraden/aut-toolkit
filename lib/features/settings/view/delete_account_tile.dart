import 'package:aut_toolkit/router.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final passwordController = TextEditingController();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.delete_account),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.delete_account_info),
            if (FirebaseService().checkSignInProvider() == SignInMethod.email) const SizedBox(height: 16), Text(t.delete_account_info_password),
            const SizedBox(height: 16),
            if (FirebaseService().checkSignInProvider() == SignInMethod.email)
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: t.password,
                  border: OutlineInputBorder(),
                ),
              ),
          ],
        ),
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
      await _deleteAccount(passwordController.text);
    }

    passwordController.dispose();
  }

  Future<void> _deleteAccount(String password) async {
    setState(() => isDeleting = true);

    if (FirebaseService().checkSignInProvider() == SignInMethod.email) {
      try {
        final ret = await FirebaseService().reauthenticateUser(password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          setState(() => isDeleting = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.incorrect_password)));
          return;
        }
      }
    }

    if (FirebaseService().checkSignInProvider() == SignInMethod.google) {
      try {
        FirebaseService().reauthenticateWithGoogle();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          return;
        }
      }
    }

    final authNotifier = ref.read(authentificationNotifierProvider.notifier);
    final result = await authNotifier.deleteAccount();

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
      setState(() => isDeleting = false);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.delete_success)));
      router.go('/');
    }
  }
}
