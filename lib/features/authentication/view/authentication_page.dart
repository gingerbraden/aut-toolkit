import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<AuthenticationPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<AuthenticationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Firebase Auth Service')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Vertical centering
            crossAxisAlignment: CrossAxisAlignment.center,
            // Horizontal centering
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String? result = await ref
                      .read(authentificationNotifierProvider.notifier)
                      .signIn(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                  if (result == null) router.go('/home');
                },
                child: const Text('Sign In'),
              ),
              TextButton(
                onPressed: () => {
                  ref
                      .read(authentificationNotifierProvider.notifier)
                      .signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      ),
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
