// new_post_page.dart
import 'package:flutter/material.dart';
import 'post_provider.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _imageAltController = TextEditingController();

  bool _isPublishing = false;

  // Imatges d'exemple ràpides per triar
  static const List<Map<String, String>> _sampleImages = [
    {
      'url': 'https://picsum.photos/id/20/600/400',
      'alt': 'Muntanya nevada amb cel blau',
    },
    {
      'url': 'https://picsum.photos/id/30/600/400',
      'alt': 'Bosc verd amb llum de matí',
    },
    {
      'url': 'https://picsum.photos/id/40/600/400',
      'alt': 'Tassa de cafè sobre una taula de fusta',
    },
    {
      'url': 'https://picsum.photos/id/50/600/400',
      'alt': 'Passeig pel parc en tardor',
    },
  ];

  String? _selectedSampleUrl;

  @override
  void dispose() {
    _descController.dispose();
    _imageUrlController.dispose();
    _imageAltController.dispose();
    super.dispose();
  }

  void _selectSample(Map<String, String> sample) {
    setState(() {
      _selectedSampleUrl = sample['url'];
      _imageUrlController.text = sample['url']!;
      _imageAltController.text = sample['alt']!;
    });
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPublishing = true);

    // Simulem un petit retard de xarxa
    await Future.delayed(const Duration(milliseconds: 600));

    final imageUrl = _imageUrlController.text.trim().isEmpty
        ? 'https://picsum.photos/id/60/600/400'
        : _imageUrlController.text.trim();

    final imageAlt = _imageAltController.text.trim().isEmpty
        ? 'Imatge publicada per l\'usuari'
        : _imageAltController.text.trim();

    PostProvider.instance.addPost(
      PostData(
        author: 'Sergi_DAM',
        time: 'ara mateix',
        description: _descController.text.trim(),
        imageAlt: imageAlt,
        imageUrl: imageUrl,
        initialLikes: 0,
        commentsCount: 0,
        isOwn: true,
      ),
    );

    if (!mounted) return;
    setState(() => _isPublishing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Semantics(
          liveRegion: true,
          child: const Text('Post publicat correctament.'),
        ),
      ),
    );

    // Tornem enrere i indiquem que s'ha publicat un post nou (true)
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nou post'),
        actions: [
          Semantics(
            label: 'Publicar post',
            button: true,
            child: TextButton(
              onPressed: _isPublishing ? null : _publish,
              child: const Text(
                'Publicar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // DESCRIPCIÓ
              const Text(
                'Descripció',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escriu una descripció per al teu post...',
                  border: OutlineInputBorder(),
                  labelText: 'Descripció del post',
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'La descripció és obligatòria' : null,
              ),

              const SizedBox(height: 24),

              // TRIA IMATGE D'EXEMPLE
              const Text(
                'Tria una imatge d\'exemple',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sampleImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final sample = _sampleImages[i];
                    final isSelected = _selectedSampleUrl == sample['url'];
                    return Semantics(
                      label:
                      '${sample['alt']}. ${isSelected ? 'Seleccionada.' : 'Toca per seleccionar.'}',
                      button: true,
                      child: GestureDetector(
                        onTap: () => _selectSample(sample),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              sample['url']!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // URL IMATGE (opcional, s'omple automàticament en triar)
              const Text(
                'O introdueix una URL d\'imatge pròpia (opcional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL de la imatge',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // TEXT ALTERNATIU
              const Text(
                'Text alternatiu de la imatge (accessibilitat)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageAltController,
                decoration: const InputDecoration(
                  labelText: 'Descripció de la imatge',
                  hintText: 'Ex: Posta de sol sobre la muntanya...',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // PREVIEW
              if (_imageUrlController.text.isNotEmpty) ...[
                const Text(
                  'Previsualització',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Previsualització: ${_imageAltController.text}',
                  image: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _imageUrlController.text,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        height: 200,
                        child: Center(child: Icon(Icons.broken_image, size: 48)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // BOTÓ PUBLICAR
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isPublishing ? null : _publish,
                  child: _isPublishing
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Publicar post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
