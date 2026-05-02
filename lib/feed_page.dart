// feed_page.dart
import 'package:flutter/material.dart';
import 'post_card.dart';
import 'post_provider.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'new_post_page.dart';

class FeedPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const FeedPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // Quan tornem de NewPostPage o ProfilePage refresquem el feed
  void _openNewPost() async {
    final published = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NewPostPage()),
    );
    if (published == true) {
      setState(() {}); // Reconstrueix la llista de posts
    }
  }

  void _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
    setState(() {}); // Per si s'ha publicat des del perfil
  }

  @override
  Widget build(BuildContext context) {
    final posts = PostProvider.instance.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Instadam Feed"),
        actions: [
          // Botó perfil
          Semantics(
            label: 'Obrir perfil',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Perfil',
              onPressed: _openProfile,
            ),
          ),
          // Botó configuració
          Semantics(
            label: 'Obrir configuració',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuració',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(
                      isDarkMode: widget.isDarkMode,
                      onThemeChanged: widget.onThemeChanged,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Botó flotant per crear un nou post
      floatingActionButton: Semantics(
        label: 'Crear nou post',
        button: true,
        child: FloatingActionButton(
          onPressed: _openNewPost,
          tooltip: 'Nou post',
          child: const Icon(Icons.add),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final p = posts[index];
          return PostCard(
            author: p.author,
            time: p.time,
            description: p.description,
            imageAlt: p.imageAlt,
            imageUrl: p.imageUrl,
            initialLikes: p.initialLikes,
            commentsCount: p.commentsCount,
          );
        },
      ),
    );
  }
}
