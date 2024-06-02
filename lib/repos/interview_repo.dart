
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mia/utils/response/responser.dart';

import '../utils/conversation/conversation_model.dart';
import '../utils/file_response/file_response.dart';

class InterviewRepo{

  Future<Responser<FileUploadResponse>> uploadResume(String userId, String clientId, Uint8List filePath) async{
    var headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://13.126.39.3/resume?user_id=$userId&client_id=$clientId&job_id=1'));
    request.files.add(http.MultipartFile.fromBytes('file', filePath,));
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.toBytes();
      FileUploadResponse fileUploadResponse = FileUploadResponse(assistant:
      response.headers['assistant'] ?? "", audioFile: res);
      return Responser(message: "SuccessFully Uploaded", isSuccess: true, data: fileUploadResponse);
    }
    else {
      return Responser(message: "Failed to upload", isSuccess: false);
    }
  }

  Future<Responser<ConversationModel>> getSpeechAudio(Uint8List audioBytes,String userId, String clientId,) async{
    var headers = {
      'Content-Type': 'application/octet-stream',
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://13.126.39.3/chat?user_id=$userId&client_id=$clientId&job_id=1'));
    request.files.add(http.MultipartFile.fromBytes('file', audioBytes,filename: 'audio.mp3'));
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Header is ${response.headers}");
      var res = await response.stream.toBytes();
      ConversationModel conversationModel = ConversationModel(
        audioFile: res,
        assistant: response.headers['assistant'] ?? "",
        isEnded: (response.headers['end'] ?? "0")=="0"? false : true,
        user: response.headers['user'] ?? ""
      );
      return Responser(message: "SuccessFully Uploaded", isSuccess: true, data: conversationModel);
    }
    else {
      return Responser(message: "Failed to upload", isSuccess: false);
    }
  }
}