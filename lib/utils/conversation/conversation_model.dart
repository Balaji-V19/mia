import 'dart:typed_data';

class ConversationModel {
  String user;
  String assistant;
  bool isEnded;
  final Uint8List audioFile;

  ConversationModel(
      {required this.user,
      required this.assistant,
      required this.audioFile,
      required this.isEnded});

  // Convert a Message object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'assistant': assistant,
      "audioFile": audioFile,
      "isEnded": isEnded
    };
  }

  // Create a Message object from a Map object
  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
        user: map['user'] ?? "",
        assistant: map['assistant'] ?? '',
        isEnded: map['isEnded'] ?? false,
        audioFile: map['audioFile']);
  }
}
