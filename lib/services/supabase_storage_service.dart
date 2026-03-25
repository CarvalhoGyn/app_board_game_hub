import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../env/env.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SupabaseStorageService {
  final SupabaseClient _supabase;

  SupabaseStorageService() : _supabase = Supabase.instance.client;

  Future<String?> uploadAvatar(File file, String userId) async {
    try {
      // Compress image
      final dir = await getTemporaryDirectory();
      final targetPath = p.join(dir.path, '${userId}_${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');
      
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, 
        targetPath,
        quality: 70,
        minWidth: 500,
        minHeight: 500,
      );

      final fileToUpload = compressedFile != null ? File(compressedFile.path) : file;
      final fileExt = p.extension(fileToUpload.path).toLowerCase();
      
      final extensionWithoutDot = fileExt.replaceFirst('.', '');
      final contentType = extensionWithoutDot == 'jpg' || extensionWithoutDot == 'jpeg' 
          ? 'image/jpeg' 
          : 'image/$extensionWithoutDot';

      final fileName = '$userId${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final bucketName = 'profile_images';
      
      // Manual HTTP Upload using 'http' package to bypass SDK 404 bugs on iOS
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Env.supabaseUrl}/storage/v1/object/$bucketName/$fileName'),
      );

      request.headers.addAll({
        'apikey': Env.supabaseAnonKey,
        'Authorization': 'Bearer ${_supabase.auth.currentSession?.accessToken ?? Env.supabaseAnonKey}',
        'x-upsert': 'false',
      });

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        fileToUpload.path,
        contentType: MediaType.parse(contentType),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        print('Manual Upload Failed: ${response.statusCode} - ${response.body}');
        throw Exception('Upload failed with status ${response.statusCode}');
      }
      
      print('Manual Upload successful: $fileName');

      // Get Public URL
      final publicUrl = '${Env.supabaseUrl}/storage/v1/object/public/$bucketName/$fileName';
      
      // Append timestamp to force refresh on UI
      return '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}';
      
    } catch (e) {
      print('General Upload Error: $e');
      throw Exception('Upload failed: $e');
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      String fileName = path;
      if (path.startsWith('http')) {
        final uri = Uri.parse(path);
        // We assume files are in root of bucket as per upload implementation.
        // URL: .../avatars/filename.jpg
        if (uri.pathSegments.isNotEmpty) {
           fileName = uri.pathSegments.last;
        }
      }

      if (fileName.isNotEmpty) {
        print('Deleting old avatar: $fileName');
        final res = await _supabase.storage.from('profile_images').remove([fileName]);
        // Note: remove returns List<FileObject> of deleted items.
        // If list is empty, deletion failed or file didn't exist.
        if (res.isEmpty) {
           print('Warning: Delete returned empty list for $fileName');
        } else {
           print('Deleted $fileName successfully.');
        }
      }
    } catch (e) {
      print('Error deleting old avatar: $e');
    }
  }
}
