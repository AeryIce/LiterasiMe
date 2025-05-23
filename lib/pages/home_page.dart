import '../widgets/nyt_pure_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:literasime/models/book_model.dart';
import 'package:literasime/models/book_recommendation_model.dart';
import 'package:literasime/theme/colors.dart';
import '../services/google_books_service.dart';
import '../services/book_lookup_service.dart';
import 'book_detail_page.dart';
import 'scan_page.dart';
import '../widgets/home_greeting_widget.dart';
import 'package:html_unescape/html_unescape.dart';
//import '../widgets/nyt_profile_carousel.dart';
//import '../widgets/nyt_result_carousel.dart';
//import '../models/nyt_book_model.dart';
//import '../services/nyt_books_service.dart';
import '../models/hybrid_book_model.dart';
//import '../services/nyt_books_service_hybrid.dart';
//import '../utils/ddc_nyt_mapping.dart';
//import '../utils/book_category_to_nyt.dart';
import '../utils/book_category_to_nyt.dart';
import '../widgets/nyt_ready_to_read_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final isbnController = TextEditingController();
  final FocusNode _isbnFocus = FocusNode();
  final unescape = HtmlUnescape();

  List<Book> recommendations = [];
  Book? book;
  //   List<HybridBook> nytBooks = [];
  bool isLoading = false;
  bool isScanMode = false;

  @override
  void initState() {
    super.initState();
    fetchMultiGenreRecommendations();
  }

  @override
  void dispose() {
    _isbnFocus.dispose();
    super.dispose();
  }

  Future<void> fetchRecommendations(String category) async {
    final recs = await GoogleBooksService.fetchBooksByCategory(category);
    setState(() {
      recommendations = recs;
    });

    final recBox = Hive.box<BookRecommendation>('book_recommendation');
    recBox.clear();
    recBox.addAll(
      recs.map(
        (book) => BookRecommendation(
          title: book.title,
          authors: book.authors,
          thumbnail: book.thumbnail,
        ),
      ),
    );
  }

  void fetchNYTBooks() async {
    //     final result = await NYTBooksService.fetchHybridBooks();
    setState(() {
      //       nytBooks = result;
    });
  }

  void fetchMultiGenreRecommendations() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('user_meta')
            .doc(userId)
            .get();
    final genres = List<String>.from(doc['preferred_genres'] ?? []);
    print("🎯 Preferred genres user: $genres");

    //List<HybridBook> allBooks = [];

    for (final genre in genres) {
      //final mapped = subcategoryToNYTList[genre];
      //print("🧠 Mapping genre '\$genre' → \$mapped");
      //final mapped = subcategoryToNYTList[genre];
      final listName = smartMapGenreToNYT(genre);
      print("🧠 Smart Mapping: $genre → $listName");
      // if (mapped != null) {
      //       //   final books = await NYTBooksService.fetchHybridBooks(listName: mapped);
      //   allBooks.addAll(books);
      // }
      //print("🧠 Mapping genre '\$genre' → \$mapped");
      //final listName = subcategoryToNYTList[genre] ?? 'paperback-nonfiction';
      //       final books = await NYTBooksService.fetchHybridBooks(listName: listName);
      //allBooks.addAll(books);
    }

    //print("🔥 Total NYT buku yang dimuat: \${allBooks.length}");
    //print("🔥 Total NYT buku yang dimuat: ${allBooks.length}");
    setState(() {
      //       nytBooks = allBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('LiterasiMe 📚'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeGreetingWidget(),
            SizedBox(height: 16),
            Text(
              'Cari Buku Berdasarkan ISBN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ), // <<< INI TAMBAHAN KITA
            const SizedBox(height: 16),

            TextField(
              controller: isbnController,
              focusNode: _isbnFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan ISBN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Input", style: TextStyle(fontSize: 12)),
                      Switch(
                        value: isScanMode,
                        onChanged: (val) {
                          setState(() => isScanMode = val);
                        },
                        activeColor: kPrimaryColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const Text("Scan", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child:
                      isScanMode
                          ? OutlinedButton.icon(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _isbnFocus.unfocus();
                              final scannedISBN = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ScanPage(),
                                ),
                              );

                              if (scannedISBN != null &&
                                  scannedISBN.length >= 10) {
                                isbnController.text = scannedISBN;
                                setState(() => isLoading = true);
                                await handleScanResult(context, scannedISBN);
                                final result =
                                    await GoogleBooksService.fetchBookByISBN(
                                      scannedISBN,
                                    );

                                if (result != null) {
                                  if (result.categories.isNotEmpty) {
                                    await fetchRecommendations(
                                      result.categories[0],
                                    );
                                  }
                                }

                                setState(() {
                                  book = result;
                                  isLoading = false;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: kPrimaryColor,
                            ),
                            label: Text(
                              "Scan ISBN",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: kPrimaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          )
                          : ElevatedButton.icon(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _isbnFocus.unfocus();
                              SystemChannels.textInput.invokeMethod(
                                'TextInput.hide',
                              );
                              final isbn = isbnController.text.trim();
                              if (isbn.isEmpty) return;
                              setState(() => isLoading = true);
                              await handleScanResult(context, isbn);
                              final result =
                                  await GoogleBooksService.fetchBookByISBN(
                                    isbn,
                                  );

                              if (result != null) {
                                if (result.categories.isNotEmpty) {
                                  await fetchRecommendations(
                                    result.categories[0],
                                  );
                                }
                              }

                              setState(() {
                                book = result;
                                isLoading = false;
                              });
                            },
                            icon: const Icon(Icons.search),
                            label: const Text("Cari Buku"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 6,
                            ),
                          ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            //             nytBooks.isEmpty
            //               ? const Text("⚠️ NYT kosong")
            //                 : NYTProfileCarousel(books: nytBooks),
            //             if (book != null && nytBooks.isNotEmpty)
            //               NYTResultCarousel(books: nytBooks),
            if (book != null && !isLoading) ...[
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading:
                      book!.thumbnail.isNotEmpty
                          ? Image.network(book!.thumbnail, width: 50)
                          : Icon(Icons.book),
                  title: Text(book!.title),
                  subtitle: Text(
                    book!.subtitleOrSnippet.isNotEmpty
                        ? unescape.convert(book!.subtitleOrSnippet)
                        : 'Tanpa deskripsi',
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    if (book != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BookDetailPage(
                                isbn: (book! as HybridBook).isbn,
                              ),
                        ),
                      );
                    }
                  },
                ),
              ),

              //               nytBooks.isEmpty
              //                 ? const Text("⚠️ NYT kosong")
              //                   : NYTProfileCarousel(books: nytBooks),
              //               if (book != null && nytBooks.isNotEmpty)
              //                 NYTResultCarousel(books: nytBooks),
            ],
            const SizedBox(height: 12),
            const NYTReadyToReadWidget(),
            const SizedBox(height: 12),
            const NYTPureCarouselWidget(),
            // Riwayat dari Firestore
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('book_history')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SizedBox.shrink();
                }

                final docs = snapshot.data!.docs;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Riwayat Pencarian 📚',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),

                        itemBuilder: (context, index) {
                          final data =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () async {
                              setState(() => book = null);
                              final newBook =
                                  await GoogleBooksService.fetchBookByISBN(
                                    data['title'],
                                  );
                              setState(() => book = newBook);
                              await handleScanResult(context, data['title']);
                            },
                            child: Container(
                              width: 110,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.brown.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.brown.shade100,
                                  width: 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(121, 85, 72, 0.15),
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  data['thumbnail'] != null &&
                                          data['thumbnail'] != ''
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          data['thumbnail'],
                                          height: 80,
                                        ),
                                      )
                                      : Icon(
                                        Icons.book,
                                        size: 60,
                                        color: Colors.brown,
                                      ),
                                  const SizedBox(height: 6),
                                  Text(
                                    data['title'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            if (recommendations.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rekomendasi Buku 📌',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendations.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),

                  itemBuilder: (context, index) {
                    final rec = recommendations[index];
                    return GestureDetector(
                      onTap: () async {
                        setState(() => book = null);
                        final newBook =
                            await GoogleBooksService.fetchBookByISBN(rec.title);
                        setState(() => book = newBook);
                        await handleScanResult(context, rec.title);
                      },
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.brown.shade100,
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(121, 85, 72, 0.08),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            rec.thumbnail.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    rec.thumbnail,
                                    height: 130,
                                  ),
                                )
                                : Icon(
                                  Icons.book,
                                  size: 80,
                                  color: Colors.brown,
                                ),
                            const SizedBox(height: 6),
                            Text(
                              rec.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
