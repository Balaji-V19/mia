import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mia/constants/app_colors.dart';
import 'package:mia/constants/app_textstyle.dart';
import 'package:mia/notifiers/interview_notifier.dart';
import 'package:provider/provider.dart';

import '../../constants/string_constants.dart';

class GlassmorphicForm extends StatefulWidget {
  @override
  State<GlassmorphicForm> createState() => _GlassmorphicFormState();
}

class _GlassmorphicFormState extends State<GlassmorphicForm> {
  Uint8List? _filePath;
  String fileName = "";
  final TextEditingController _userNameController = TextEditingController(text: "");

  bool _shouldShowButton() {
    return _userNameController.text.isNotEmpty && _filePath!=null;
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _filePath = file.bytes;
        fileName = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterviewNotifier>(
        builder: (context, interviewNotifier, _) {
      return Container(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To get started, please fill in your details below',
              style: AppTextStyles.text12w500
                  .copyWith(color: AppColors.white.withOpacity(0.72)),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.white.withOpacity(0.5), width: 0.2)),
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.white.withOpacity(0.7),
                    size: 24,
                  ),
                  hintText: 'What shall we address you as, Your Majesty?',
                  hintStyle: AppTextStyles.text14w500
                      .copyWith(color: AppColors.white.withOpacity(0.3)),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: AppTextStyles.text14w500,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                _pickPdf();
              },
              child: Container(
                height: ScreenUtil().screenHeight * 0.2,
                decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.white.withOpacity(0.5), width: 0.2)),
                child: Center(
                  child: fileName.isNotEmpty?
                  Text(
                  fileName,
                      style: AppTextStyles.text14w500.copyWith(
                          color: AppColors.white.withOpacity(0.3))):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file,
                          color: AppColors.white.withOpacity(0.7), size: 24),
                      const SizedBox(height: 10),
                      Text(fileName.isNotEmpty?
                      fileName:'Click to upload or drag and drop your resume',
                          style: AppTextStyles.text14w500.copyWith(
                              color: AppColors.white.withOpacity(0.3))),
                      const SizedBox(height: 5),
                      Text(
                        'Only PDF files are accepted',
                        style: AppTextStyles.text12w500
                            .copyWith(color: AppColors.white.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap:_shouldShowButton()?
                  () async{
                if(_filePath!=null) {
                  interviewNotifier.uploadResume(_userNameController.text, "1", _filePath).then((
                      value) {
                    if (value) {
                      Navigator.pushNamed(
                          context, StringConstants.LOADING_SCREEN);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to upload resume', style: AppTextStyles.text16w500,),
                          duration: const Duration(milliseconds: 1500),
                        ),
                      );
                    }
                  });
                }
              }: null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: _shouldShowButton()?
                BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFF2D31A5), Color(0xFF2C3282)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ): BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white.withOpacity(0.07)
                ),
                child: interviewNotifier.isLoading?
                Center(
                  child: SizedBox(
                    height: 14.h,
                    width: 14.h,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ):
                Center(
                  child: Text(
                    "Get Started",
                    style: AppTextStyles.text14w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
