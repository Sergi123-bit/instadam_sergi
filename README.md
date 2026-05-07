

📸 InstaDAM
Aplicació mòbil inspirada en Instagram desenvolupada amb Flutter com a projecte de pràctica DAM. Combina SQFlite per a la base de dades local i SharedPreferences per a les preferències de l'usuari.
---
🚀 Instal·lació
```bash
git clone https://github.com/el-teu-usuari/instadam.git
cd instadam
flutter pub get
flutter run
```
Dependències principals: `sqflite`, `path`, `shared_preferences`
---
🗂️ Estructura del projecte
```
lib/
├── main.dart               # Punt d'entrada i gestió del tema global
├── splash_screen.dart      # Pantalla de càrrega inicial
├── db_helper.dart          # SQFlite: usuaris, posts, likes i comentaris
├── post_provider.dart      # Singleton d'estat compartit dels posts
├── login_page.dart         # Login i registre
├── feed_page.dart          # Feed principal
├── post_card.dart          # Widget reutilitzable per a cada post
├── new_post_page.dart      # Formulari de creació de posts
├── profile_page.dart       # Perfil d'usuari
├── edit_profile_page.dart  # Edició de perfil i contrasenya
└── settings_page.dart      # Configuració de l'app
```
---
✅ Funcionalitats implementades
🔐 Login i Registre
Formulari amb validació de camps. Inclou l'opció "Recordar usuari" guardada amb SharedPreferences: si ja has iniciat sessió, l'app et porta directament al feed. Els usuaris es guarden a SQFlite.

📰 Feed principal
Mostra totes les publicacions en ordre invers. Cada post inclou imatge, autor, descripció, temps de publicació, likes i comptador de comentaris. El feed s'actualitza automàticament en afegir un nou post.

❤️ Likes
Pots donar i treure like a qualsevol publicació. El canvi es reflecteix a la UI a l'instant i es distingeix visualment amb icona plena/buida i color, sense dependre únicament del color (accessibilitat).

➕ Crear posts
Pantalla accessible des del botó `+` del feed. Permet triar una imatge de mostra o introduir una URL pròpia, escriure una descripció i afegir text alternatiu per a la imatge. Inclou previsualització abans de publicar.

💬 Comentaris
Cada post té el seu propi sistema de comentaris. Es poden veure i afegir des del `PostCard`. El comptador s'actualitza a l'instant i cada comentari mostra autor, text i temps.

👤 Perfil i edició
Mostra nom d'usuari, nom real, biografia i estadístiques. Inclou un grid amb els posts propis de l'usuari. Des de la pantalla d'edició es pot modificar el nom, el nom real i la contrasenya real (actualitzada a SQFlite). El correu apareix bloquejat i no es pot modificar. El resultat mostra feedback amb emoji: 👍 si ha anat bé, 👎 si hi ha hagut un error.

⚙️ Configuració
Tot guardat amb SharedPreferences:
Tema clar/fosc aplicat a tota l'app en temps real.
Idioma amb 3 opcions (Català, Español, English): la pàgina es tradueix completament en canviar-lo.
Notificacions activar/desactivar (simulació).
Tancar sessió amb diàleg de confirmació, elimina les dades de SharedPreferences i torna al login.
---

♿ Accessibilitat
L'aplicació ha estat dissenyada seguint les pautes WCAG 2.1 i és compatible amb TalkBack (Android) i VoiceOver (iOS).


👨‍💻 Autor
Sergi Terrones — CFGS Desenvolupament d'Aplicacions Multiplataforma (DAM)


