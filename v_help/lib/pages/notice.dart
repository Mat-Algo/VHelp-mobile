import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PDFListPage(),
    );
  }
}

class PDFListPage extends StatelessWidget {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> fetchPDFUrls() async {
    ListResult result = await _storage.ref('pdfs').listAll();
    List<String> urls = [];
    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF List'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchPDFUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching PDFs'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('PDF Document ${index + 1}'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PDFViewPage(url: snapshot.data![index]),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No PDFs found'));
          }
        },
      ),
    );
  }
}

class PDFViewPage extends StatefulWidget {
  final String url;

  const PDFViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  String localPath = '';

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    final response = await http.get(Uri.parse(widget.url));
    final bytes = response.bodyBytes;
    final dir = (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir/${widget.url.split('/').last}');

    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: localPath.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath),
    );
  }
}
