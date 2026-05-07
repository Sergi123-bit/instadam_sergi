📸 InstaDAM
Aplicació mòbil inspirada en Instagram desenvolupada amb Flutter com a projecte de pràctica DAM. Combina SQFlite per a la base de dades local i SharedPreferences per a les preferències de l'usuari.

🚀 Instal·lació

git clone https://github.com/el-teu-usuari/instadam.git
cd instadam
flutter pub get
flutter run

Dependències principals: sqflite, path, shared_preferences

🗂️ Estructura del projecte

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

✅ Funcionalitats implementades

🔐 Login i Registre
Formulari amb validació de camps. Inclou l'opció "Recordar usuari" guardada amb SharedPreferences: si ja has iniciat sessió, l'app et porta directament al feed. Els usuaris es guarden a SQFlite.

📰 Feed principal
Mostra totes les publicacions en ordre invers. Cada post inclou imatge, autor, descripció, temps de publicació, likes i comptador de comentaris. El feed s'actualitza automàticament en afegir un nou post.

❤️ Likes
Pots donar i treure like a qualsevol publicació. El canvi es reflecteix a la UI a l'instant i es distingeix visualment amb icona plena/buida i color, sense dependre únicament del color (accessibilitat).

➕ Crear posts
Pantalla accessible des del botó + del feed. Permet triar una imatge de mostra o introduir una URL pròpia, escriure una descripció i afegir text alternatiu per a la imatge. Inclou previsualització abans de publicar.

💬 Comentaris
Cada post té el seu propi sistema de comentaris. Es poden veure i afegir des del PostCard. El comptador s'actualitza a l'instant i cada comentari mostra autor, text i temps.

👤 Perfil i edició
Mostra nom d'usuari, nom real, biografia i estadístiques. Inclou un grid amb els posts propis de l'usuari. Des de la pantalla d'edició es pot modificar el nom, el nom real i la contrasenya real (actualitzada a SQFlite). El correu apareix bloquejat i no es pot modificar. El resultat mostra feedback amb emoji: 👍 si ha anat bé, 👎 si hi ha hagut un error.

⚙️ Configuració
Tot guardat amb SharedPreferences:

Tema clar/fosc aplicat a tota l'app en temps real.
Idioma amb 3 opcions (Català, Español, English): la pàgina es tradueix completament en canviar-lo.
Notificacions activar/desactivar (simulació).
Tancar sessió amb diàleg de confirmació, elimina les dades de SharedPreferences i torna al login.

♿ Accessibilitat

L'aplicació ha estat dissenyada seguint les pautes WCAG 2.1 i és compatible amb TalkBack (Android) i VoiceOver (iOS).

Semàntica i navegació

Tots els elements interactius tenen Semantics amb label descriptiu i clar.
MergeSemantics agrupa elements relacionats (capçalera del post, comentaris, estadístiques del perfil) perquè TalkBack els llegeixi com una unitat.
ExcludeSemantics oculta elements purament decoratius com avatars i comptadors duplicats.
onTapHint als botons contextuals indica l'acció concreta ("Donar m'agrada", "Veure comentaris").

Estat i feedback

liveRegion: true als SnackBar perquè TalkBack anunciï els canvis d'estat sense que l'usuari hagi de moure el focus (likes, comentaris enviats, canvi de tema...).
toggled als SwitchListTile per indicar correctament l'estat actiu/inactiu (tema fosc, notificacions).
Feedback visual i textual simultani: mai es transmet informació únicament mitjançant el color.

Disseny inclusiu

Mida mínima de 48dp en tots els botons i elements tàctils.
Els camps de formulari sempre tenen labelText visible, mai només hintText com a única referència.
Les icones van acompanyades de text o Semantics label (mai icones soles sense context).
El text escala amb les preferències del sistema: no es fixa cap textScaleFactor.

🎨 Decisió de colors

La paleta de colors s'ha triat tenint en compte el contrast mínim WCAG AA (4.5:1) per garantir la llegibilitat.

Element	Color clar	Color fosc	Motiu
Color primari	#1565C0 (blau fosc)	#1565C0	Contrast alt sobre blanc i negre
Fons Splash	#1565C0	#1565C0	Identitat visual de l'app
Like actiu	Colors.red + icona plena	Colors.red + icona plena	Doble senyal: color + forma
Feedback èxit	Colors.green[700] + 👍	Colors.green[700] + 👍	Color + emoji, no depèn d'un sol codi
Feedback error	Colors.red[700] + 👎	Colors.red[700] + 👎	Color + emoji, no depèn d'un sol codi
Camp bloquejat	Colors.grey[200]	Colors.grey[800]	Indica visualment que no és editable
Botó de logout	Colors.red + text blanc	Colors.red + text blanc	Acció destructiva clarament diferenciada

El tema clar i fosc s'aplica globalment des de main.dart mitjançant ThemeMode, sense forçar cap color fix a les pantalles individuals, de manera que tots els widgets s'adapten automàticament.

🛠️ Tecnologies

Tecnologia	Ús
Flutter / Dart	Framework i llenguatge principal
SQFlite	Usuaris, posts, likes i comentaris
SharedPreferences	Sessió, tema, idioma i perfil
Semantics API	Accessibilitat (TalkBack / VoiceOver)

---

👨‍💻 Autor
Sergi Terrones — CFGS Desenvolupament d'Aplicacions Multiplataforma (DAM)
