import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

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
      final fileExt = p.extension(fileToUpload.path);
      final fileName = '$userId${DateTime.now().millisecondsSinceEpoch}$fileExt';
      
      // Upload file to 'avatars' bucket
      await _supabase.storage.from('avatars').upload(
        fileName,
        fileToUpload,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // Get Public URL
      final publicUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
      return publicUrl;
      
    } catch (e) {
      // If we can't upload, we return null or throw. 
      // For now let's rethrow so UI can show error.
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
        final res = await _supabase.storage.from('avatars').remove([fileName]);
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
