// post_provider.dart
// Singleton senzill per compartir els posts entre FeedPage i ProfilePage

class PostData {
  final String author;
  final String time;
  final String description;
  final String imageAlt;
  final String imageUrl;
  final int initialLikes;
  final int commentsCount;
  final bool isOwn; // true → post publicat per l'usuari actual

  const PostData({
    required this.author,
    required this.time,
    required this.description,
    required this.imageAlt,
    required this.imageUrl,
    required this.initialLikes,
    required this.commentsCount,
    this.isOwn = false,
  });
}

class PostProvider {
  PostProvider._();
  static final PostProvider instance = PostProvider._();

  // Llista mutable de posts (els primers són d'exemple)
  final List<PostData> posts = [
    const PostData(
      author: "Sergi_DAM",
      time: "fa 10 minuts",
      description: "Codi de Flutter funcionant amb accessibilitat!",
      imageAlt:
      "Pantalla d'ordinador mostrant línies de codi de colors sobre un fons negre.",
      imageUrl: "https://picsum.photos/id/1/600/400",
      initialLikes: 24,
      commentsCount: 5,
      isOwn: true,
    ),
    const PostData(
      author: "Anna_Design",
      time: "fa 1 hora",
      description: "Mireu quina posta de sol des de la uni.",
      imageAlt: "Cel de color taronja i lila sobre un campus universitari buit.",
      imageUrl: "https://picsum.photos/id/10/600/400",
      initialLikes: 150,
      commentsCount: 12,
      isOwn: false,
    ),
  ];

  void addPost(PostData post) {
    posts.insert(0, post); // El nou post apareix al principi
  }

  List<PostData> get ownPosts => posts.where((p) => p.isOwn).toList();
}
