import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String author;
  final String time;
  final String description;
  final String imageAlt;
  final String imageUrl;
  final int initialLikes;
  final int commentsCount;

  const PostCard({
    super.key,
    required this.author,
    required this.time,
    required this.description,
    required this.imageAlt,
    required this.imageUrl,
    required this.initialLikes,
    required this.commentsCount,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  late int _likes;

  final List<Map<String, String>> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
    // Comentaris d'exemple
    _comments.addAll([
      {'author': 'Anna', 'text': 'Molt bonic!', 'time': 'fa 5 minuts'},
      {'author': 'Marc', 'text': "M'encanta aquest contingut", 'time': 'fa 1 hora'},
    ]);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  //  LIKE
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likes++ : _likes--;
    });

    //  S5: SnackBar amb liveRegion → TalkBack anuncia el canvi d'estat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Semantics(
          liveRegion: true,
          child: Text(
            _isLiked
                ? "M'agrada activat. Total: $_likes m'agrades."
                : "M'agrada tret. Total: $_likes m'agrades.",
          ),
        ),
      ),
    );
  }

  //  COMENTARI
  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add({'author': 'Jo', 'text': text, 'time': 'ara mateix'});
      _commentController.clear();
      _showComments = true;
    });

    //  S5: Feedback accessible al enviar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Semantics(
          liveRegion: true,
          child: const Text("Comentari enviat correctament."),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //  CAPÇALERA
          //  S5: MergeSemantics agrupa autor+temps | ExcludeSemantics a l'avatar
          MergeSemantics(
            child: ListTile(
              leading: ExcludeSemantics(
                child: const CircleAvatar(child: Icon(Icons.person)),
              ),
              title: Text(widget.author),
              subtitle: Text(widget.time),
            ),
          ),

          //  IMATGE
          //  S5: image:true + label descriptiva
          Semantics(
            label: "Imatge: ${widget.imageAlt}",
            image: true,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
              errorBuilder: (_, __, ___) =>
              const SizedBox(height: 250, child: Icon(Icons.broken_image)),
            ),
          ),

          // DESCRIPCIÓ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(widget.description),
          ),

          //  BOTONS
          Row(
            children: [

              //  S5: toggled + onTapHint + label amb nombre de likes
              Semantics(
                label: "M'agrada. $_likes m'agrades.",
                toggled: _isLiked,
                onTapHint: _isLiked ? "Treure m'agrada" : "Donar m'agrada",
                button: true,
                child: IconButton(
                  //  S5: Icona diferent, NO només color
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : null,
                  ),
                  onPressed: _toggleLike,
                ),
              ),

              ExcludeSemantics(child: Text("$_likes")),
              const SizedBox(width: 8),

              Semantics(
                label: "Comentaris. ${_comments.length} comentaris.",
                button: true,
                onTapHint: _showComments ? "Amagar" : "Veure comentaris",
                child: IconButton(
                  icon: Icon(
                    _showComments ? Icons.comment : Icons.comment_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _showComments = !_showComments),
                ),
              ),

              ExcludeSemantics(child: Text("${_comments.length}")),
            ],
          ),

          //  COMENTARIS
          if (_showComments) ...[
            const Divider(),

            //  S5: MergeSemantics per a cada comentari (autor + text + temps)
            //  S5: ExcludeSemantics a l'avatar decoratiu
            ..._comments.map(
                  (c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: MergeSemantics(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: const CircleAvatar(
                          radius: 14,
                          child: Icon(Icons.person, size: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['author']!,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(c['text']!),
                            Text(c['time']!,
                                style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //  FORMULARI
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  //  S5: labelText visible (NO placeholder)
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: "Afegir comentari",
                        hintText: "Escriu aquí...",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // S5: label = 'Enviar comentari'
                  Semantics(
                    label: "Enviar comentari",
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _submitComment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
