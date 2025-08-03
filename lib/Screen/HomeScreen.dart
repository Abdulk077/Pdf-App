import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/Screen/PdfViewerScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _pdfFiles = [];
  List<String> _filteredFiles = [];
  bool _isSearching = false;
  void initState() {
    super.initState();
    baseDirectory();
  }

  Future<void> baseDirectory() async {
    PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.request();
    if (permissionStatus.isGranted) {
      var rootDirectory = await ExternalPath.getExternalStorageDirectories();
      // always add a null check
      await getFiles(rootDirectory!.first);
    }
  }

  // dont use list sync as it blocks the UI thread
  Future<void> getFiles(String directoryPath) async {
    try {
      var rootDirectory = Directory(directoryPath);
      var directories = rootDirectory.list(recursive: false);
      await for (var element in directories) {
        if (element is File) {
          if (element.path.endsWith('.pdf')) {
            setState(() {
              _pdfFiles.add(element.path);
              _filteredFiles = _pdfFiles;
            });
          }
        } else {
          await getFiles(element.path);
        }
      }
    } catch (e) {
      print("Error accessing directory: $e");
    }
  }

  void _filterFiles(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFiles = _pdfFiles;
      });
    } else {
      setState(() {
        _filteredFiles = _pdfFiles
            .where((file) => file
                .split('/')
                .last
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: !_isSearching
                ? Text(
                    "PDF Reader",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : TextField(
                    decoration: InputDecoration(
                      hintText: "Serching Pdfs..",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _filterFiles(value);
                    },
                  ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      _filteredFiles = _pdfFiles;
                    });
                  },
                  icon: Icon(_isSearching ? Icons.cancel : Icons.search))
            ]),
        body: _filteredFiles.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _filteredFiles.length,
                itemBuilder: (context, index) {
                  String filePath = _filteredFiles[index];
                  String fileName = path.basename(filePath);
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        fileName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              pdfName: fileName,
                              pdfPath: filePath,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                floatingActionButton: FloatingActionButton(
                  onPressed: (){
                    baseDirectory();
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child:Icon(Icons.refresh),
                ),
                );
  }
}
