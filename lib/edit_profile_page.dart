// edit_profile_page.dart
import 'package:flutter/material.dart';
import 'db_helper.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;

  const EditProfilePage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper _dbHelper = DBHelper();

  late TextEditingController _usernameController;
  late TextEditingController _realNameController;
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _repeatPassController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureRepeat = true;
  bool _isSaving = false;

  // null = sense feedback, true = èxit 👍, false = error 👎
  bool? _feedbackSuccess;
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _realNameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _realNameController.dispose();
    _newPassController.dispose();
    _repeatPassController.dispose();
    super.dispose();
  }

  // Mostra el banner emoji i el fa desaparèixer al cap d'uns segons
  void _showFeedback(bool success, String message) {
    setState(() {
      _feedbackSuccess = success;
      _feedbackMessage = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _feedbackSuccess = null);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _feedbackSuccess = null;
    });

    final newPass = _newPassController.text;
    bool passwordUpdated = false;

    // Si l'usuari ha escrit una nova contrasenya, l'actualitzem a la DB
    if (newPass.isNotEmpty) {
      final ok = await _dbHelper.updatePassword(widget.email, newPass);
      if (!ok) {
        setState(() => _isSaving = false);
        _showFeedback(false, 'No s\'ha pogut actualitzar la contrasenya. Torna-ho a intentar.');
        return;
      }
      passwordUpdated = true;
      _newPassController.clear();
      _repeatPassController.clear();
    }

    setState(() => _isSaving = false);

    final msg = passwordUpdated
        ? 'Perfil i contrasenya actualitzats correctament.'
        : 'Perfil actualitzat correctament.';

    _showFeedback(true, msg);

    // Esperem que l'usuari vegi el feedback i tornem
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.pop(context, {
      'username': _usernameController.text.trim(),
      'realName': _realNameController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        actions: [
          Semantics(
            label: 'Desar canvis',
            button: true,
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: const Text(
                'Desar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [

          // ── BANNER DE FEEDBACK (👍 / 👎) ──────────────────────────────
          if (_feedbackSuccess != null)
            Semantics(
              liveRegion: true,
              label: _feedbackSuccess!
                  ? 'Èxit: $_feedbackMessage'
                  : 'Error: $_feedbackMessage',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                color: _feedbackSuccess!
                    ? Colors.green[700]
                    : Colors.red[700],
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Text(
                      _feedbackSuccess! ? '👍' : '👎',
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _feedbackMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── FORMULARI ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // AVATAR
                    Center(
                      child: Stack(
                        children: [
                          Semantics(
                            label: "Foto de perfil de ${widget.username}",
                            image: true,
                            child: const CircleAvatar(
                              radius: 52,
                              child: Icon(Icons.person, size: 52),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Semantics(
                              label: 'Canviar foto de perfil',
                              button: true,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: theme.colorScheme.primary,
                                child: const Icon(Icons.camera_alt,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── INFORMACIÓ PERSONAL ──────────────────────────────
                    _sectionHeader('Informació personal'),
                    const SizedBox(height: 12),

                    // NOM D'USUARI
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Nom d'usuari",
                        hintText: '@usuari',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "El nom d'usuari és obligatori";
                        }
                        if (v.trim().length < 3) return 'Mínim 3 caràcters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // NOM REAL
                    TextFormField(
                      controller: _realNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nom real',
                        hintText: 'Ex: Joan Garcia',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // CORREU — BLOQUEJAT
                    Semantics(
                      label:
                      'Correu electrònic. Camp bloquejat: ${widget.email}',
                      readOnly: true,
                      child: TextFormField(
                        initialValue: widget.email,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Correu electrònic',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: theme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          suffixIcon: const Tooltip(
                            message: 'El correu no es pot modificar',
                            child: Icon(Icons.lock_outline, size: 18),
                          ),
                        ),
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── CANVIAR CONTRASENYA ──────────────────────────────
                    _sectionHeader('Canviar contrasenya'),
                    const SizedBox(height: 4),
                    Text(
                      'Deixa els camps buits si no vols canviar la contrasenya.',
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),

                    // NOVA CONTRASENYA
                    TextFormField(
                      controller: _newPassController,
                      obscureText: _obscureNew,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Nova contrasenya',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: Semantics(
                          label: _obscureNew
                              ? 'Mostrar contrasenya'
                              : 'Ocultar contrasenya',
                          button: true,
                          child: IconButton(
                            icon: Icon(_obscureNew
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _obscureNew = !_obscureNew),
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v != null && v.isNotEmpty && v.length < 6) {
                          return 'Mínim 6 caràcters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // REPETIR CONTRASENYA
                    TextFormField(
                      controller: _repeatPassController,
                      obscureText: _obscureRepeat,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _save(),
                      decoration: InputDecoration(
                        labelText: 'Repetir nova contrasenya',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: Semantics(
                          label: _obscureRepeat
                              ? 'Mostrar contrasenya'
                              : 'Ocultar contrasenya',
                          button: true,
                          child: IconButton(
                            icon: Icon(_obscureRepeat
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(
                                    () => _obscureRepeat = !_obscureRepeat),
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (_newPassController.text.isNotEmpty) {
                          if (v == null || v.isEmpty) {
                            return 'Repeteix la nova contrasenya';
                          }
                          if (v != _newPassController.text) {
                            return 'Les contrasenyes no coincideixen';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // BOTÓ DESAR
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        child: _isSaving
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : const Text('Desar canvis'),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }
}
