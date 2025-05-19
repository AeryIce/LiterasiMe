import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeGreetingWidget extends StatelessWidget {
  const HomeGreetingWidget({super.key});

  String _getGreetingByTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 17) return 'Selamat siang';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid == null) {
      return const Text('Halo, Sobat Literasi');
    }

    final userMetaRef = FirebaseFirestore.instance
        .collection('user_meta')
        .doc(uid);
    final userStaticRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid);

    return FutureBuilder<List<DocumentSnapshot>>(
      future: Future.wait([userMetaRef.get(), userStaticRef.get()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const CircularProgressIndicator();
        }

        final metaData =
            snapshot.data![0].data() as Map<String, dynamic>? ?? {};
        final staticData =
            snapshot.data![1].data() as Map<String, dynamic>? ?? {};

        final nickname = metaData['nickname'] ?? 'Sobat';
        final genre =
            (metaData['preferred_genres'] as List?)?.join(', ') ?? '-';
        final photoUrl = metaData['photo_url'] ?? staticData['photoUrl'];

        return Card(
          elevation: 2,
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/avatar_placeholder.png')
                                as ImageProvider,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreetingByTime()}, $nickname!',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Genre Favorit: $genre',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Profil',
                  onPressed: () {
                    Navigator.pushNamed(context, '/profil');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
