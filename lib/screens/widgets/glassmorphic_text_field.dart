import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mia/constants/app_colors.dart';
import 'package:mia/constants/app_textstyle.dart';

import '../../constants/string_constants.dart';


class GlassmorphicForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth * 0.45,
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.00, 1.00),
          end: Alignment(0, -1),
          colors: [Color(0xFF000212), Color(0xFF000314)],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To get started, please fill in your details below',
            style: AppTextStyles.text16w500,
          ),
          const SizedBox(height: 20),
          GlassmorphicTextField(),
          const SizedBox(height: 20),
          GlassmorphicFileUpload(),
          const SizedBox(height: 20),
          GlassmorphicButton(
            text: 'Get Started',
            onPressed: () {
              Navigator.pushNamed(context, StringConstants.LOADING_SCREEN);
            },
          ),
        ],
      ),
    );
  }
}

class GlassmorphicTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: AppColors.white.withOpacity(0.3)),
          hintText: 'What shall we address you as, Your Majesty?',
          hintStyle: AppTextStyles.text14w500.copyWith(
            color: AppColors.white.withOpacity(0.3)
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: AppTextStyles.text14w500,
      ),
    );
  }
}

class GlassmorphicFileUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().screenHeight * 0.3,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: AppColors.white.withOpacity(0.3), size: 30),
              const SizedBox(height: 10),
              Text(
                'Click to upload or drag and drop your resume',
                style: AppTextStyles.text14w500.copyWith(
                  color: AppColors.white.withOpacity(0.3)
                )
              ),
              const SizedBox(height: 5),
              Text(
                'Only PDF files are accepted',
                style: AppTextStyles.text12w500.copyWith(
                  color: AppColors.white.withOpacity(0.3)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassmorphicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GlassmorphicButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF2D31A5), Color(0xFF2C3282)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.text14w500,
          ),
        ),
      ),
    );
  }
}