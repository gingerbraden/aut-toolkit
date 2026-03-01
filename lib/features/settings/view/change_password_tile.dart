import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';

class ChangePasswordTile extends ConsumerStatefulWidget {
  const ChangePasswordTile({super.key});

  @override
  ConsumerState<ChangePasswordTile> createState() => _ChangePasswordTileState();
}

class _ChangePasswordTileState extends ConsumerState<ChangePasswordTile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: FirebaseAuth.instance.currentUser != null
          ? FirebaseAuth.instance.currentUser!.providerData.any(
              (p) => p.providerId == 'password',
            )
          : false,
      leading: const Icon(Icons.password),
      title: Text(t.password_reset),
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
        title: Text(t.really_reset_password),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.no),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
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
    if (FirebaseAuth.instance.currentUser!.providerData.any(
      (p) => p.providerId == 'password',
    )) {
      await ref
          .read(authentificationNotifierProvider.notifier)
          .resetPassword(FirebaseAuth.instance.currentUser!.email!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.mail_sent)));
    }
    setState(() => isLoading = false);
    router.go('/');
  }
}
