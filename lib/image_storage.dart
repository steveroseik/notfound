import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CachedImage extends StatefulWidget {
  final String imageUrl;
  BoxFit? fit;

  CachedImage({this.fit, required this.imageUrl});

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  String? _cachedImagePath;
  bool _isLoading = true;
  BlackBox? box;

  @override
  void initState() {
    super.initState();
    _loadCachedImage();
  }

  Future<void> _loadCachedImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = widget.imageUrl.split('/').last;
    final savedImage = File('${appDir.path}/$fileName');
    if (await savedImage.exists()) {
      _cachedImagePath = savedImage.path;
      print(_cachedImagePath);
    }else{
      await _downloadAndSaveImage();
    }

    _isLoading = false;
    setState(() {});
  }

  Future<void> _downloadAndSaveImage() async {
    final response = await http.get(Uri.parse(widget.imageUrl));
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = widget.imageUrl.split('/').last;
    final savedImage = File('${appDir.path}/$fileName');
    await savedImage.writeAsBytes(response.bodyBytes);
    _cachedImagePath = savedImage.path;
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
    child: (!_isLoading) ? Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.file(File(_cachedImagePath!), fit: widget.fit?? BoxFit.cover,)):
    const Center(child: CircularProgressIndicator())) ;
  }
}

Future<void> _deleteCachedImages() async {
  final appDir = await getApplicationDocumentsDirectory();
  final directory = Directory(appDir.path);
  final imageFiles = directory.listSync();

  for (var file in imageFiles) {
    if (file is File) {
      await file.delete();
    }
  }
}