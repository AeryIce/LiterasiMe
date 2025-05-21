import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nicknameController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? birthDate;
  List<String> selectedGenres = [];
  String? readingStyle;
  String? location;
  String? readingGoal;
  String? readingTime;

  final List<String> genreOptions = [
    'Computer Science, Information',
    'Philosophy and Psychology',
    'Religion',
    'Social Sciences',
    'Language',
    'Science',
    'Technology',
    'Arts and Recreation',
    'Literature',
    'History and Geography',
  ];

  final List<String> readingGoals = [
    'Menambah ilmu',
    'Mengisi waktu',
    'Pengembangan diri',
    'Inspirasi spiritual',
  ];

  final List<String> readingTimes = [
    'Pagi hari',
    'Siang/sore',
    'Malam sebelum tidur',
  ];

  @override
  void initState() {
    super.initState();
    loadUserMeta();
  }

  Future<void> loadUserMeta() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('user_meta')
            .doc(user.uid)
            .get();

    final data = doc.data();
    if (data != null) {
      setState(() {
        nicknameController.text = data['nickname'] ?? '';
        location = data['location'];
        locationController.text = location ?? '';
        readingStyle = data['reading_style'];
        readingGoal = data['reading_goal'];
        readingTime = data['reading_time'];
        if (data['birth_date'] != null) {
          birthDate = DateTime.tryParse(data['birth_date']);
        }
        if (data['preferred_genres'] != null) {
          selectedGenres = List<String>.from(data['preferred_genres']);
        }
      });
    }
  }

  void saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final userMetaRef = FirebaseFirestore.instance
        .collection('user_meta')
        .doc(uid);

    await userMetaRef.set({
      'nickname': nicknameController.text.trim(),
      'birth_date': birthDate?.toIso8601String(),
      'preferred_genres': selectedGenres,
      'reading_style': readingStyle,
      'location': location,
      'reading_goal': readingGoal,
      'reading_time': readingTime,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil kamu sudah diperbarui ✨')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Hai, izinkan kami mengenalmu lebih dekat...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "Karena sahabat yang baik lebih memilih bertanya, daripada menerka.",
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Panggilan',
                  helperText: 'Akan digunakan untuk menyapamu di halaman utama',
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                title: Text(
                  birthDate == null
                      ? 'Tanggal Lahir'
                      : 'Lahir: ${birthDate!.toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => birthDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),

              const Text('Genre Favorit'),
              Wrap(
                spacing: 8.0,
                children:
                    genreOptions.map((genre) {
                      final selected = selectedGenres.contains(genre);
                      return FilterChip(
                        label: Text(genre),
                        selected: selected,
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.blue.shade100,
                        checkmarkColor: Colors.blue.shade800,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              selectedGenres.add(genre);
                            } else {
                              selectedGenres.remove(genre);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: readingStyle,
                items:
                    ['Cepat', 'Santai', 'Teliti']
                        .map(
                          (style) => DropdownMenuItem(
                            value: style,
                            child: Text(style),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => readingStyle = value),
                decoration: const InputDecoration(
                  labelText: 'Gaya Membaca',
                  helperText:
                      'Agar kami bisa menyesuaikan cara menampilkan buku',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi (opsional)',
                  helperText: 'Contoh: Jakarta, Bandung',
                ),
                onChanged: (value) => location = value,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: readingGoal,
                items:
                    readingGoals
                        .map(
                          (goal) =>
                              DropdownMenuItem(value: goal, child: Text(goal)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => readingGoal = value),
                decoration: const InputDecoration(
                  labelText: 'Tujuan Membaca',
                  helperText:
                      'Agar rekomendasi kami makin selaras dengan semangatmu',
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: readingTime,
                items:
                    readingTimes
                        .map(
                          (time) =>
                              DropdownMenuItem(value: time, child: Text(time)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => readingTime = value),
                decoration: const InputDecoration(
                  labelText: 'Waktu Favorit Membaca',
                  helperText:
                      'Kami ingin menyarankan buku di waktu yang pas 😊',
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
