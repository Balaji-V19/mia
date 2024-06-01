

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  // Factory method to create a Message from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      role: map['role'] as String,
      content: map['content'] as String,
    );
  }

  // Method to convert a Message to a map
  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class FileUploadResponse {
  final Message message;

  FileUploadResponse({required this.message});

  // Factory method to create a Response from a map
  factory FileUploadResponse.fromMap(Map<String, dynamic> map) {
    return FileUploadResponse(
      message: Message.fromMap(map['message'] as Map<String, dynamic>),
    );
  }

  // Method to convert a Response to a map
  Map<String, dynamic> toMap() {
    return {
      'message': message.toMap(),
    };
  }
}
