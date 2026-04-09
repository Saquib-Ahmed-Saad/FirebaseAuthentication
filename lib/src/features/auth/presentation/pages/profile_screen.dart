import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../inventory/presentation/pages/inventory_page.dart';
import '../../data/services/auth_service.dart';
import 'authentication_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  bool _updatingPassword = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Signed in as',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentUser?.email ?? 'No email found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _passwordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Update Password',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New password',
                        ),
                        validator: (String? value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _updatingPassword
                            ? null
                            : _handlePasswordChange,
                        child: _updatingPassword
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Change Password'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const InventoryPage(),
                  ),
                );
              },
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('Open Inventory Dashboard'),
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: _handleSignOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePasswordChange() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    setState(() => _updatingPassword = true);

    try {
      await widget.authService.changePassword(_newPasswordController.text);
      if (!mounted) {
        return;
      }
      _newPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }
      final fallback = error.code == 'requires-recent-login'
          ? 'Please sign in again, then try changing your password.'
          : 'Could not update password.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? fallback)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error while updating password')),
      );
    } finally {
      if (mounted) {
        setState(() => _updatingPassword = false);
      }
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await widget.authService.signOut();
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const AuthenticationScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign out failed. Please try again.')),
      );
    }
  }
}
