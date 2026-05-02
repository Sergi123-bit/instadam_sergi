import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'feed_page.dart';

class LoginPage extends StatefulWidget {
  //  S7: Recibe el tema para pasarlo a FeedPage → SettingsPage
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const LoginPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _passFocusNode = FocusNode();

  final DBHelper _dbHelper = DBHelper();

  bool _rememberUser = false;
  bool _isLoading = false;
  String? _globalError;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _globalError = null;
      _isLoading = true;
    });

    bool success = await _dbHelper.loginUser(
      _userController.text,
      _passController.text,
    );

    setState(() {
      _isLoading = false;
      if (success) {
        _globalError = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FeedPage(
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
      } else {
        _globalError = "Error: Usuari o contrasenya incorrectes.";
      }
    });
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    await _dbHelper.registerUser(_userController.text, _passController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Usuari registrat correctament.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar sessió")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Correu electrònic',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passFocusNode),
                validator: (value) =>
                (value == null || value.isEmpty) ? "L'email és obligatori" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passController,
                focusNode: _passFocusNode,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contrasenya',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value == null || value.length < 6) ? "Mínim 6 caràcters" : null,
              ),
              const SizedBox(height: 8),
              if (_globalError != null)
                Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _globalError!,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Semantics(
                label: "Recordar usuari",
                container: true,
                child: SwitchListTile(
                  title: const Text("Recordar usuari"),
                  value: _rememberUser,
                  onChanged: (bool value) =>
                      setState(() => _rememberUser = value),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
                    : const Text("Iniciar sessió"),
              ),
              TextButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: const Text("No tens compte? Registra't aquí"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
