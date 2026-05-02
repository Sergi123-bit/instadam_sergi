// settings_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';

// Mapa de traduccions de les etiquetes de la pàgina
const Map<String, Map<String, String>> _i18n = {
  'Català': {
    'title': 'Configuració',
    'appearance': 'Aparença',
    'darkMode': 'Tema fosc',
    'darkOn': 'Activat',
    'darkOff': 'Desactivat',
    'language': 'Idioma',
    'langLabel': "Idioma de l'aplicació",
    'notifications': 'Notificacions',
    'notifTitle': 'Notificacions push',
    'notifOn': 'Activades',
    'notifOff': 'Desactivades',
    'account': 'Compte',
    'logout': 'Tancar sessió',
    'logoutDialog': 'Tancar sessió',
    'logoutQuestion': 'Estàs segur que vols tancar la sessió?',
    'cancel': 'Cancel·lar',
    'confirm': 'Tancar sessió',
    'darkActivated': 'Tema fosc activat',
    'lightActivated': 'Tema clar activat',
    'notifActivated': 'Notificacions activades',
    'notifDeactivated': 'Notificacions desactivades',
    'langChanged': 'Idioma canviat a',
  },
  'Español': {
    'title': 'Configuración',
    'appearance': 'Apariencia',
    'darkMode': 'Tema oscuro',
    'darkOn': 'Activado',
    'darkOff': 'Desactivado',
    'language': 'Idioma',
    'langLabel': 'Idioma de la aplicación',
    'notifications': 'Notificaciones',
    'notifTitle': 'Notificaciones push',
    'notifOn': 'Activadas',
    'notifOff': 'Desactivadas',
    'account': 'Cuenta',
    'logout': 'Cerrar sesión',
    'logoutDialog': 'Cerrar sesión',
    'logoutQuestion': '¿Estás seguro de que quieres cerrar la sesión?',
    'cancel': 'Cancelar',
    'confirm': 'Cerrar sesión',
    'darkActivated': 'Tema oscuro activado',
    'lightActivated': 'Tema claro activado',
    'notifActivated': 'Notificaciones activadas',
    'notifDeactivated': 'Notificaciones desactivadas',
    'langChanged': 'Idioma cambiado a',
  },
  'English': {
    'title': 'Settings',
    'appearance': 'Appearance',
    'darkMode': 'Dark mode',
    'darkOn': 'On',
    'darkOff': 'Off',
    'language': 'Language',
    'langLabel': 'App language',
    'notifications': 'Notifications',
    'notifTitle': 'Push notifications',
    'notifOn': 'Enabled',
    'notifOff': 'Disabled',
    'account': 'Account',
    'logout': 'Log out',
    'logoutDialog': 'Log out',
    'logoutQuestion': 'Are you sure you want to log out?',
    'cancel': 'Cancel',
    'confirm': 'Log out',
    'darkActivated': 'Dark mode enabled',
    'lightActivated': 'Light mode enabled',
    'notifActivated': 'Notifications enabled',
    'notifDeactivated': 'Notifications disabled',
    'langChanged': 'Language changed to',
  },
};

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Català';

  final List<String> _languages = ['Català', 'Español', 'English'];

  // Drecera per accedir a les traduccions actuals
  Map<String, String> get t => _i18n[_selectedLanguage]!;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
    widget.onThemeChanged(value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Semantics(
          liveRegion: true,
          child: Text(value ? t['darkActivated']! : t['lightActivated']!),
        ),
      ),
    );
  }

  void _toggleNotifications(bool value) {
    setState(() => _notificationsEnabled = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Semantics(
          liveRegion: true,
          child: Text(
              value ? t['notifActivated']! : t['notifDeactivated']!),
        ),
      ),
    );
  }

  void _changeLanguage(String? newLanguage) {
    if (newLanguage == null) return;
    // Guardem el missatge ABANS de canviar l'idioma perquè sigui coherent
    final msg = '${_i18n[newLanguage]!['langChanged']} $newLanguage';
    setState(() => _selectedLanguage = newLanguage);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Semantics(
          liveRegion: true,
          child: Text(msg),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t['logoutDialog']!),
        content: Text(t['logoutQuestion']!),
        actions: [
          Semantics(
            label: t['cancel'],
            button: true,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t['cancel']!),
            ),
          ),
          Semantics(
            label: t['confirm'],
            button: true,
            child: TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(
                      isDarkMode: _isDarkMode,
                      onThemeChanged: widget.onThemeChanged,
                    ),
                  ),
                      (route) => false,
                );
              },
              child: Text(t['confirm']!),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t['title']!),
      ),
      body: ListView(
        children: [

          // SECCIÓ: APARENÇA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              t['appearance']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

          Semantics(
            label: t['darkMode'],
            toggled: _isDarkMode,
            child: SwitchListTile(
              secondary: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: Text(t['darkMode']!),
              subtitle: Text(_isDarkMode ? t['darkOn']! : t['darkOff']!),
              value: _isDarkMode,
              onChanged: _toggleTheme,
            ),
          ),

          const Divider(),

          // SECCIÓ: IDIOMA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              t['language']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

          Semantics(
            label:
            "${t['langLabel']}. ${t['language']} actual: $_selectedLanguage",
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['langLabel']!),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: _languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: _changeLanguage,
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          // SECCIÓ: NOTIFICACIONS
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              t['notifications']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

          Semantics(
            label: t['notifTitle'],
            toggled: _notificationsEnabled,
            child: SwitchListTile(
              secondary: Icon(
                _notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
              ),
              title: Text(t['notifTitle']!),
              subtitle: Text(
                  _notificationsEnabled ? t['notifOn']! : t['notifOff']!),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ),

          const Divider(),

          // SECCIÓ: COMPTE
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              t['account']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Semantics(
              label: t['logout'],
              button: true,
              child: SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: Text(t['logout']!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _showLogoutDialog,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
