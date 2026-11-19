import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const FaunovaApp());

const forest = Color(0xFF173D32);
const leaf = Color(0xFF77A982);
const cream = Color(0xFFF1EBD9);
const gold = Color(0xFFD5A94D);

class AnimalEntry {
  AnimalEntry({required this.name, required this.category, required this.date, this.image});
  final String name;
  final String category;
  final DateTime date;
  final XFile? image;
}

class FaunovaApp extends StatefulWidget {
  const FaunovaApp({super.key});
  @override
  State<FaunovaApp> createState() => _FaunovaAppState();
}

class _FaunovaAppState extends State<FaunovaApp> {
  int selectedTab = 0;
  final List<AnimalEntry> animals = [];

  Future<void> addAnimal() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(children: [
          ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Tomar fotografía'), onTap: () => Navigator.pop(context, ImageSource.camera)),
          ListTile(leading: const Icon(Icons.photo_library), title: const Text('Elegir de galería'), onTap: () => Navigator.pop(context, ImageSource.gallery)),
        ]),
      ),
    );
    if (source == null) return;
    final photo = await picker.pickImage(source: source, imageQuality: 88);
    if (photo == null || !mounted) return;
    final nameController = TextEditingController(text: 'Animal por identificar');
    final categoryController = TextEditingController(text: 'Sin clasificar');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo descubrimiento'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del animal')),
          TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Categoría')),
          const SizedBox(height: 8),
          const Text('La identificación y el recorte automático se añadirán en una siguiente etapa.', style: TextStyle(fontSize: 12)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );
    if (saved == true && mounted) {
      setState(() {
        animals.insert(0, AnimalEntry(
          name: nameController.text.trim().isEmpty ? 'Animal sin nombre' : nameController.text.trim(),
          category: categoryController.text.trim().isEmpty ? 'Sin clasificar' : categoryController.text.trim(),
          date: DateTime.now(),
          image: photo,
        ));
        selectedTab = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(animals: animals, onCapture: addAnimal),
      DexPage(animals: animals, onCapture: addAnimal),
      CapturePage(onCapture: addAnimal),
      const SocialPage(),
      const ProfilePage(),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FAUNOVA',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: forest, surface: cream),
        scaffoldBackgroundColor: const Color(0xFFF7F6F0),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF7F6F0), foregroundColor: forest),
        cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      home: Scaffold(
        body: SafeArea(child: pages[selectedTab]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab,
          onDestinationSelected: (index) => setState(() => selectedTab = index),
          backgroundColor: Colors.white,
          indicatorColor: leaf.withValues(alpha: .22),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Mi Dex'),
            NavigationDestination(icon: Icon(Icons.camera_alt_outlined), selectedIcon: Icon(Icons.camera_alt), label: 'Capturar'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Social'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.subtitle = 'DESCUBRE. CAPTURA. COLECCIONA.'});
  final String subtitle;
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 46, height: 46, decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(15)),
      child: const Icon(Icons.pets, color: Colors.white, size: 27)),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('FAUNOVA', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: 1.1, color: forest)),
      Text(subtitle, style: const TextStyle(fontSize: 9, letterSpacing: 1.1, color: leaf, fontWeight: FontWeight.w700)),
    ]),
  ]);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.animals, required this.onCapture});
  final List<AnimalEntry> animals;
  final VoidCallback onCapture;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const BrandHeader(),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('TU MUNDO ANIMAL', style: TextStyle(color: Colors.white70, letterSpacing: 1.4, fontSize: 11)),
        const SizedBox(height: 8),
        const Text('Cada encuentro\\nes un descubrimiento.', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Row(children: [
          _Stat(value: '${animals.length}', label: 'REGISTROS'),
          const SizedBox(width: 24),
          const _Stat(value: '0', label: 'ESPECIES'),
        ]),
        const SizedBox(height: 18),
        FilledButton.icon(onPressed: onCapture, icon: const Icon(Icons.camera_alt), label: const Text('Capturar animal'),
          style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: forest)),
      ]),
    ),
    const SizedBox(height: 22),
    const Text('Tus descubrimientos recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: forest)),
    const SizedBox(height: 10),
    if (animals.isEmpty)
      const EmptyState(icon: Icons.pets, title: 'Tu colección comienza aquí', message: 'Fotografía un animal para crear tu primera ficha.')
    else
      ...animals.take(3).map((animal) => AnimalTile(animal: animal)),
    const SizedBox(height: 16),
    const Text('Explora el mundo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: forest)),
    const SizedBox(height: 10),
    const Wrap(spacing: 8, runSpacing: 8, children: [
      CategoryChip(label: 'Mamíferos', icon: Icons.pets),
      CategoryChip(label: 'Aves', icon: Icons.flutter_dash),
      CategoryChip(label: 'Reptiles', icon: Icons.ssid_chart),
      CategoryChip(label: 'Insectos', icon: Icons.bug_report),
      CategoryChip(label: 'Acuáticos', icon: Icons.water),
    ]),
  ]);
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1)),
  ]);
}

class DexPage extends StatelessWidget {
  const DexPage({super.key, required this.animals, required this.onCapture});
  final List<AnimalEntry> animals;
  final VoidCallback onCapture;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const BrandHeader(subtitle: 'TU ENCICLOPEDIA PERSONAL'),
    const SizedBox(height: 22),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Mi Dex', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: forest)),
      Text('${animals.length} registros', style: const TextStyle(color: leaf, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 12),
    if (animals.isEmpty)
      EmptyState(icon: Icons.menu_book, title: 'Todavía no hay animales', message: 'Tus fotografías guardadas aparecerán aquí.', action: onCapture)
    else
      ...animals.map((animal) => AnimalTile(animal: animal)),
  ]);
}

class CapturePage extends StatelessWidget {
  const CapturePage({super.key, required this.onCapture});
  final VoidCallback onCapture;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 112, height: 112, decoration: BoxDecoration(color: leaf.withValues(alpha: .18), shape: BoxShape.circle),
      child: const Icon(Icons.center_focus_strong, size: 58, color: forest)),
    const SizedBox(height: 22),
    const Text('Un nuevo descubrimiento te espera', textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: forest)),
    const SizedBox(height: 10),
    const Text('Toma una fotografía o selecciona una imagen para comenzar tu colección.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 22),
    FilledButton.icon(onPressed: onCapture, icon: const Icon(Icons.camera_alt), label: const Text('Abrir cámara o galería'),
      style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15))),
  ])));
}

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Padding(padding: EdgeInsets.all(28), child: EmptyState(
    icon: Icons.people_alt_outlined, title: 'La comunidad llegará pronto',
    message: 'Estamos preparando perfiles, publicaciones, amigos y controles de privacidad.'))));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const BrandHeader(subtitle: 'TU PERFIL DE EXPLORADOR'),
    const SizedBox(height: 30),
    const CircleAvatar(radius: 42, backgroundColor: leaf, child: Icon(Icons.person, size: 46, color: Colors.white)),
    const SizedBox(height: 12),
    const Center(child: Text('Explorador FAUNOVA', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: forest))),
    const Center(child: Text('Tu aventura comienza aquí', style: TextStyle(color: Colors.black54))),
    const SizedBox(height: 24),
    const Card(child: Column(children: [
      ListTile(leading: Icon(Icons.lock_outline), title: Text('Privacidad'), subtitle: Text('Configura quién puede ver tu colección')),
      Divider(height: 1),
      ListTile(leading: Icon(Icons.cloud_outlined), title: Text('Sincronización'), subtitle: Text('La conexión con la nube se configurará después')),
      Divider(height: 1),
      ListTile(leading: Icon(Icons.info_outline), title: Text('Acerca de FAUNOVA'), subtitle: Text('Versión inicial 0.1.0')),
    ])),
  ]);
}

class AnimalTile extends StatelessWidget {
  const AnimalTile({super.key, required this.animal});
  final AnimalEntry animal;
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
    contentPadding: const EdgeInsets.all(10),
    leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: animal.image == null
      ? Container(width: 62, height: 62, color: cream, child: const Icon(Icons.pets, color: forest))
      : Image.file(File(animal.image!.path), width: 62, height: 62, fit: BoxFit.cover)),
    title: Text(animal.name, style: const TextStyle(fontWeight: FontWeight.bold, color: forest)),
    subtitle: Text('${animal.category} · ${animal.date.day}/${animal.date.month}/${animal.date.year}'),
    trailing: const Icon(Icons.chevron_right),
  ));
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.action});
  final IconData icon;
  final String title, message;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
      Icon(icon, size: 42, color: leaf),
      const SizedBox(height: 10),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: forest)),
      const SizedBox(height: 5),
      Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
      if (action != null) ...[
        const SizedBox(height: 12),
        TextButton(onPressed: action, child: const Text('Agregar animal')),
      ],
    ]));
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, required this.icon});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Chip(avatar: Icon(icon, size: 17, color: forest), label: Text(label),
    backgroundColor: leaf.withValues(alpha: .16), side: BorderSide.none);
}
