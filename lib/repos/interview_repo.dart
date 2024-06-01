
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mia/utils/response/responser.dart';

class InterviewRepo{

  Future<Responser<Uint8List>> uploadResume(String userId, String clientId, Uint8List filePath) async{
    var headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://13.126.39.3/resume?user_id=$userId&client_id=$clientId&job_id=1'));
    request.files.add(http.MultipartFile.fromBytes('file', filePath,));
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.toBytes();
      return Responser(message: "SuccessFully Uploaded", isSuccess: true, data: res);
    }
    else {
      return Responser(message: "Failed to upload", isSuccess: false);
    }
  }

  Future<Responser<Uint8List>> getSpeechAudio(Uint8List audioBytes,String userId, String clientId,) async{
    var headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://13.126.39.3/chat?user_id=$userId&client_id=$clientId&job_id=1'));
    request.files.add(http.MultipartFile.fromBytes('file', audioBytes,));
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.toBytes();
      return Responser(message: "SuccessFully Uploaded", isSuccess: true, data: res);
    }
    else {
      return Responser(message: "Failed to upload", isSuccess: false);
    }
  }
}