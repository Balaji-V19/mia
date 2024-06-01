import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mia/constants/app_colors.dart';
import 'package:mia/notifiers/interview_notifier.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:js/js.dart';
import '../constants/app_textstyle.dart';
import '../constants/image_constants.dart';



@JS()
external void startRecording();

@JS()
external void stopRecording();

@JS('onAudioRecorded')
external set _onAudioRecorded(void Function(Uint8List audioBytes) f);

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({Key? key}) : super(key: key);

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _continueRecording = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var authNotifier = Provider.of<InterviewNotifier>(context, listen: false);
      if(authNotifier.fileUploadResponse!=null){
        await _playAudioFromBytes(authNotifier.fileUploadResponse!, true);
      }
      _onAudioRecorded = allowInterop((Uint8List audioBytes) async{
        print("Audio recorded");
        var res = await authNotifier.getSpeechAudio(audioBytes);
        if(res!=null){
          print("Git the response");
          await _playAudioFromBytes(res);
        }
      });
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        print("Start recording again");
        startRecording();
      }
    });
  }

  Future<void> _playAudioFromBytes(Uint8List audioBytes, [bool restartRecording = false]) async {
    final blob = html.Blob([audioBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
    if (restartRecording) {
      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          startRecording();
        }
      });
    }
  }

  @override
  void dispose() {
    _continueRecording = false;
    stopRecording();
    super.dispose();
  }

  void _toggleRecording() {
    print("Should i record $_isRecording");
    if (_isRecording) {
      _continueRecording = false;
      stopRecording();
    } else {
      _continueRecording = true;
      startRecording();
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Stack(
          children: [
            Positioned(
              left: 0.0,
              child: Image.asset(
                ImageConstants.bgImageWebp,
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
              ),
            ),
            SvgPicture.asset(
              ImageConstants.stars,
              width: ScreenUtil().screenWidth * 0.4,
              height: ScreenUtil().screenHeight,
            ),
            Positioned(
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                width: ScreenUtil().screenWidth * 0.6,
                height: ScreenUtil().screenHeight,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: SvgPicture.asset(
                        ImageConstants.mia,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Text(
                        "Your Ai interviewer for this round",
                        style: AppTextStyles.text16w500
                            .copyWith(color: AppColors.textColor),
                      ),
                    ),
                    SiriWave(),
                    Container(
                      width: ScreenUtil().screenWidth * 0.4,
                      margin: EdgeInsets.only(top: 40.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-0.00, 1.00),
                          end: Alignment(0, -1),
                          colors: [Color(0xFF000212), Color(0xFF000314)],
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.08),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, -4), // Changes position of shadow to top
                          ),
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.08),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(-4, 0), // Changes position of shadow to left
                          ),
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.08),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(4, 0), // Changes position of shadow to right
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        children: [
                          _isRecording? Text("Recording....."): Text("Thinking.....")
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
