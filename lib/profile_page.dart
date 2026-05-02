// profile_page.dart
import 'package:flutter/material.dart';
import 'post_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "Sergi_DAM";
  String _realName = "";
  static const String _email = "sergi@instadam.cat";
  static const String _bio =
      "Estudiant de DAM. Apassionat de Flutter i accessibilitat.";
  static const int _followersCount = 130;
  static const int _followingCount = 85;

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          username: _username,
          email: _email,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _username = result['username'] ?? _username;
        _realName = result['realName'] ?? _realName;
      });
    }
  }

  void _openPost(BuildContext context, int index, PostData post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Obrint post ${index + 1}...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownPosts = PostProvider.instance.ownPosts;

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: ListView(
        children: [

          // CAPÇALERA DEL PERFIL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Semantics(
                  label: "Foto de perfil de $_username",
                  image: true,
                  child: const CircleAvatar(
                    radius: 48,
                    child: Icon(Icons.person, size: 48),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _username,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                if (_realName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _realName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],

                const SizedBox(height: 4),

                const Text(
                  _bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 16),

                MergeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("${ownPosts.length}", "Posts"),
                      _buildStatItem("$_followersCount", "Seguidors"),
                      _buildStatItem("$_followingCount", "Seguint"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Semantics(
                  label: "Editar perfil",
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _openEditProfile,
                      child: const Text("Editar perfil"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // GRID DE POSTS PROPIS
          ownPosts.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                "Encara no has publicat cap post.\nPremeu + al feed per crear-ne un!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: ownPosts.length,
            itemBuilder: (context, index) {
              final post = ownPosts[index];
              final description = post.description.isEmpty
                  ? "Sense descripció"
                  : post.description;
              return Semantics(
                label: "Post ${index + 1} de ${ownPosts.length}. "
                    "$description. "
                    "${post.initialLikes} m'agrades. "
                    "Doble toc per obrir.",
                button: true,
                child: GestureDetector(
                  onTap: () => _openPost(context, index, post),
                  child: Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
