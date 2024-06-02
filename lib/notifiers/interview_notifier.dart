
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mia/repos/interview_repo.dart';

import '../utils/chat/chat_model.dart';
import '../utils/file_response/file_response.dart';


class InterviewNotifier extends ChangeNotifier{
  late InterviewRepo initRepo;
  InterviewNotifier(){
    initRepo = InterviewRepo();
  }
  bool _isLoading = false;
  FileUploadResponse? _fileUploadResponse;
  List<ChatModel> _chatModel = [];
  bool _isConversationCompleted = false;
  String _userId = "1";
  String _clientId = "1";


  bool get isLoading => _isLoading;
  FileUploadResponse? get fileUploadResponse => _fileUploadResponse;
  List<ChatModel> get chatModel => _chatModel;
  bool get isConversationCompleted => _isConversationCompleted;

  Future<bool> uploadResume(String userId, String clientId, Uint8List? filePath) async{
    _isLoading = true;
    _userId = userId;
    _clientId = clientId;
    notifyListeners();
    try{
      var res = await initRepo.uploadResume(userId, clientId, filePath!);
      if(res.isSuccess) {
        _fileUploadResponse = res.data;
        _chatModel.add(ChatModel(isClient: false, message: res.data?.assistant ?? ""));
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
    _isLoading = true;
    notifyListeners();
    try{
      var res = await initRepo.getSpeechAudio(audioBytes, _userId, _clientId);
      if(res.isSuccess) {
        _chatModel.add(ChatModel(isClient: true, message: res.data?.user ?? ""));
        _chatModel.add(ChatModel(isClient: false, message: res.data?.assistant ?? ""));
        _isConversationCompleted = res.data?.isEnded ?? false;
        _isLoading = false;
        notifyListeners();
        return res.data?.audioFile;
      } else {
        print("Error not success ${res.message}");
        _isLoading = false;
        notifyListeners();
      }
    }catch(e){
      print("Error while $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}