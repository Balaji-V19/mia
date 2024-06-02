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
import 'package:mia/utils/chat/chat_model.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:js/js.dart';
import '../constants/app_textstyle.dart';
import '../constants/image_constants.dart';
import '../constants/string_constants.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var interviewNotifier = Provider.of<InterviewNotifier>(context, listen: false);
      if (interviewNotifier.fileUploadResponse != null) {
        await _playAudioFromBytes(
            interviewNotifier.fileUploadResponse!.audioFile, true);
      }
      _onAudioRecorded = allowInterop((Uint8List audioBytes) async {
        var res = await interviewNotifier.getSpeechAudio(audioBytes);
        if (res != null) {
          await _playAudioFromBytes(res);
        }
      });
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        startRecording();
      }
    });
  }

  Future<void> _playAudioFromBytes(Uint8List audioBytes,
      [bool restartRecording = false]) async {
    var interviewNotifier = Provider.of<InterviewNotifier>(context, listen: false);
    final blob = html.Blob([audioBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    await _audioPlayer.setUrl(url);
    _audioPlayer.play().then((value) {
      if(interviewNotifier.isConversationCompleted){
        Navigator.of(context).pushNamedAndRemoveUntil(
          StringConstants.THANK_YOU_SCREEN,
              (Route<dynamic> route) => false,
        );
      }
    });

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
    stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterviewNotifier>(
        builder: (context, interviewNotifier, _) {
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
                          style: AppTextStyles.text14w500
                              .copyWith(color: AppColors.textBlue),
                        ),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          if (playerState?.processingState ==
                                  ProcessingState.ready &&
                              _audioPlayer.playing) {
                            return Column(
                              children: [
                                SiriWave(
                                    style: SiriWaveStyle.ios_9,
                                    options: SiriWaveOptions(height: 64.h)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 2.w),
                                      child: SvgPicture.asset(
                                        ImageConstants.employerIcon,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Mia is talking...",
                                        style: AppTextStyles.text14w400
                                            .copyWith(
                                                height: 1.5,
                                                color: AppColors.textBlue),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                SiriWave(
                                    style: SiriWaveStyle.ios_7,
                                    controller: SiriWaveController(
                                      frequency: 4,
                                      speed: 0.15,
                                    ),
                                    options: SiriWaveOptions(height: 64.h)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 2.w),
                                      child: Icon(
                                        Icons.person,
                                        size: 20.r,
                                        color: AppColors.userChatColor,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Now it’s your turn to speak....",
                                        style:
                                            AppTextStyles.text14w400.copyWith(
                                          height: 1.5,
                                          color: AppColors.userChatColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      Container(
                        width: ScreenUtil().screenWidth * 0.4,
                        height: ScreenUtil().screenHeight * 0.6,
                        margin: EdgeInsets.only(top: 40.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(-0.00, 1.00),
                            end: Alignment(0, -1),
                            colors: [Color(0xFF000212), Color(0xFF000314)],
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor.withOpacity(0.08),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(
                                  0, -4), // Changes position of shadow to top
                            ),
                            BoxShadow(
                              color: AppColors.shadowColor.withOpacity(0.08),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(
                                  -4, 0), // Changes position of shadow to left
                            ),
                            BoxShadow(
                              color: AppColors.shadowColor.withOpacity(0.08),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(
                                  4, 0), // Changes position of shadow to right
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(24.r),
                        child: SingleChildScrollView(
                          child: Column(
                            children: interviewNotifier.chatModel.map((e) {
                              if (e.isClient) {
                                return userChatBubble(e);
                              } else {
                                return miaChatBubble(e);
                              }
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Align miaChatBubble(ChatModel e) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          width: e.message.length > 50 ? ScreenUtil().screenWidth * 0.3 : null,
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.shadowColor.withOpacity(0.5), width: 1.5),
            color: AppColors.white.withOpacity(0.07),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.r),
              topLeft: Radius.circular(8.r),
              bottomLeft: const Radius.circular(0),
              bottomRight: Radius.circular(8.r),
            ),
          ),
          padding:
              EdgeInsets.only(top: 4.h, bottom: 6.h, left: 2.w, right: 3.w),
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: SvgPicture.asset(
                  ImageConstants.employerIcon,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              Flexible(
                child: Text(
                  e.message,
                  style: AppTextStyles.text14w400.copyWith(height: 1.5),
                ),
              ),
            ],
          )),
    );
  }

  Align userChatBubble(ChatModel e) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          width: e.message.length > 50 ? ScreenUtil().screenWidth * 0.3 : null,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.userChatColor, width: 1.5),
            color: AppColors.white.withOpacity(0.07),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.r),
              topLeft: Radius.circular(8.r),
              bottomRight: const Radius.circular(0),
              bottomLeft: Radius.circular(8.r),
            ),
          ),
          padding:
              EdgeInsets.only(top: 4.h, bottom: 6.h, left: 2.w, right: 3.w),
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.person,
                  size: 20.r,
                  color: AppColors.userChatColor,
                ),
              ),
              Flexible(
                child: Text(
                  e.message,
                  style: AppTextStyles.text14w400.copyWith(height: 1.5),
                ),
              ),
            ],
          )),
    );
  }
}
