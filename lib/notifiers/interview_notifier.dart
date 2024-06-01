
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mia/repos/interview_repo.dart';


class InterviewNotifier extends ChangeNotifier{
  late InterviewRepo initRepo;
  InterviewNotifier(){
    initRepo = InterviewRepo();
  }
  bool _isLoading = false;
  Uint8List? _fileUploadResponse;
  String _userId = "1";
  String _clientId = "1";


  bool get isLoading => _isLoading;
  Uint8List? get fileUploadResponse => _fileUploadResponse;

  Future<bool> uploadResume(String userId, String clientId, Uint8List? filePath) async{
    _isLoading = true;
    _userId = userId;
    _clientId = clientId;
    notifyListeners();
    try{
      var res = await initRepo.uploadResume(userId, clientId, filePath!);
      if(res.isSuccess) {
        _fileUploadResponse = res.data;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }catch(e){
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<Uint8List?> getSpeechAudio(Uint8List audioBytes) async{
    print("Sent the new audio here");
    _isLoading = true;
    notifyListeners();
    try{
      var res = await initRepo.getSpeechAudio(audioBytes, _userId, _clientId);
      if(res.isSuccess) {
        _isLoading = false;
        notifyListeners();
        return res.data;
      } else {
        _isLoading = false;
        notifyListeners();
      }
    }catch(e){
      print("Error from chat $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}