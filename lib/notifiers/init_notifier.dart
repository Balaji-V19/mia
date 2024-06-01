
import 'package:flutter/material.dart';
import 'package:mia/repos/init_repo.dart';

class InitNotifier extends ChangeNotifier{
  late InitRepo initRepo;
  InitNotifier(){
    initRepo = InitRepo();
  }
  bool _isLoading = false;


}