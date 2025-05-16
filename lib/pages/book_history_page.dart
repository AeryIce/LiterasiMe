
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookHistoryPage extends StatelessWidget {
  const BookHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pencarian')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('book_history')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada riwayat pencarian 😶'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final tags = List<String>.from(data['tags'] ?? []);

              return ListTile(
                leading: data['thumbnail'] != null && data['thumbnail'] != ''
                    ? Image.network(data['thumbnail'], width: 50)
                    : Icon(Icons.book),
                title: Text(data['title'] ?? 'Tanpa Judul'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((data['authors'] as List?)?.join(', ') ?? 'Tanpa Penulis'),
                    Text('ISBN: ${data['isbn']}', style: TextStyle(fontSize: 12)),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: -10,
                        children: tags
                            .take(5)
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      ),
                  ],
                ),
                trailing: Text(
                  '📅',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
