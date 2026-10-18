import 'package:flutter/material.dart';

import '../models/app_user.dart';

enum AuthMode { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({
    required this.users,
    required this.onAuthenticated,
    required this.onRegistered,
    super.key,
  });

  final List<AppUser> users;
  final ValueChanged<AppUser> onAuthenticated;
  final ValueChanged<AppUser> onRegistered;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  AuthMode _mode = AuthMode.login;
  String? _message;

  bool get _registering => _mode == AuthMode.register;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _changeMode(AuthMode mode) {
    setState(() {
      _mode = mode;
      _message = null;
    });
    _formKey.currentState?.reset();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Bu alan zorunludur.';
    return null;
  }

  String? _validateEmail(String? value) {
    final requiredMessage = _required(value);
    if (requiredMessage != null) return requiredMessage;
    final email = value!.trim();
    if (!email.contains('@') || !email.split('@').last.contains('.')) {
      return 'Geçerli bir e-posta adresi girin.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final requiredMessage = _required(value);
    if (requiredMessage != null) return requiredMessage;
    if (value!.length < 6) return 'Şifre en az 6 karakter olmalıdır.';
    return null;
  }

  void _submit() {
    setState(() => _message = null);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (!_registering) {
      AppUser? matchedUser;
      for (final user in widget.users) {
        if (user.matches(email, password)) {
          matchedUser = user;
          break;
        }
      }
      if (matchedUser == null) {
        setState(() => _message = 'E-posta veya şifre hatalı.');
        return;
      }
      widget.onAuthenticated(matchedUser);
      return;
    }

    if (_confirmController.text != password) {
      setState(() => _message = 'Şifreler birbiriyle eşleşmiyor.');
      return;
    }
    if (widget.users.any((user) => user.email.toLowerCase() == email)) {
      setState(() => _message = 'Bu e-posta adresi zaten kayıtlı.');
      return;
    }

    final nextId =
        widget.users.fold(
          0,
          (maxId, user) => user.id > maxId ? user.id : maxId,
        ) +
        1;
    widget.onRegistered(
      AppUser(
        id: nextId,
        name: _nameController.text.trim(),
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _AuthHeader(),
                  const SizedBox(height: 22),
                  SegmentedButton<AuthMode>(
                    key: const ValueKey('auth-mode-selector'),
                    segments: const [
                      ButtonSegment(
                        value: AuthMode.login,
                        icon: Icon(Icons.login_rounded),
                        label: Text('Giriş Yap'),
                      ),
                      ButtonSegment(
                        value: AuthMode.register,
                        icon: Icon(Icons.person_add_alt_1_rounded),
                        label: Text('Kayıt Ol'),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (selection) =>
                        _changeMode(selection.first),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              _registering
                                  ? 'Taskora hesabını oluştur'
                                  : 'Tekrar hoş geldin',
                              style: const TextStyle(
                                color: Color(0xFF183047),
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 18),
                            if (_registering) ...[
                              TextFormField(
                                key: const ValueKey('auth-name-field'),
                                controller: _nameController,
                                validator: _required,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Ad soyad',
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            TextFormField(
                              key: const ValueKey('auth-email-field'),
                              controller: _emailController,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'E-posta',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              key: const ValueKey('auth-password-field'),
                              controller: _passwordController,
                              validator: _validatePassword,
                              obscureText: true,
                              textInputAction: _registering
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!_registering) _submit();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Şifre',
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                            if (_registering) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                key: const ValueKey('auth-confirm-field'),
                                controller: _confirmController,
                                validator: _required,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                decoration: const InputDecoration(
                                  labelText: 'Şifre tekrar',
                                  prefixIcon: Icon(Icons.lock_reset_rounded),
                                ),
                              ),
                            ],
                            if (_message != null) ...[
                              const SizedBox(height: 14),
                              Text(
                                _message!,
                                key: const ValueKey('auth-message'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFB34747),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              key: const ValueKey('auth-submit-button'),
                              onPressed: _submit,
                              icon: Icon(
                                _registering
                                    ? Icons.person_add_alt_1_rounded
                                    : Icons.login_rounded,
                              ),
                              label: Text(
                                _registering ? 'Hesap Oluştur' : 'Giriş Yap',
                              ),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Demo hesap: demo@taskora.app / 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF607383),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kayıtlar bu cihazda yerel olarak saklanır.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF718391), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF2468A0),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.checklist_rounded,
            color: Colors.white,
            size: 42,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'TASKORA',
          style: TextStyle(
            color: Color(0xFF183047),
            fontSize: 31,
            fontWeight: FontWeight.w900,
            letterSpacing: -.8,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Görevlerini planla, takip et ve tamamla.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF607383)),
        ),
      ],
    );
  }
}
