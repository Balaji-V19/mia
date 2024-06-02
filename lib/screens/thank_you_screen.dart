import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_textstyle.dart';
import '../constants/image_constants.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
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
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: SizedBox(
                  width: ScreenUtil().screenWidth * 0.6,
                  height: ScreenUtil().screenHeight,
                  child: Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: SvgPicture.asset(
                          ImageConstants.thankYou,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Text(
                          "for interviewing with us.",
                          style: AppTextStyles.text14w500
                              .copyWith(color: AppColors.textBlue),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
