import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mia/constants/app_colors.dart';
import 'package:siri_wave/siri_wave.dart';

import '../constants/app_textstyle.dart';
import '../constants/image_constants.dart';


class InterviewScreen extends StatefulWidget {
  const InterviewScreen({Key? key}) : super(key: key);

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
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
