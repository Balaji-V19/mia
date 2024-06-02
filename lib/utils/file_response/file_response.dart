

import 'dart:typed_data';

class FileUploadResponse {
  final Uint8List audioFile;
  final String assistant;

  FileUploadResponse({required this.audioFile, required this.assistant});

  // Factory method to create a Response from a map
  factory FileUploadResponse.fromMap(Map<String, dynamic> map) {
    return FileUploadResponse(
      audioFile: map['audioFile'] as Uint8List,
      assistant: map['assistant'] as String
    );
  }

}
