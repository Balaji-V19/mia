import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mia/constants/app_colors.dart';
import 'package:mia/constants/app_textstyle.dart';
import 'package:mia/screens/widgets/glassmorphic_text_field.dart';

import '../constants/image_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    SvgPicture.asset(
                      ImageConstants.employerIcon,
                      width: 32.w,
                      height: 32.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: SvgPicture.asset(
                        ImageConstants.employerName,
                        height: 27.h,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100.r)),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 5.w),
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          "Senior Software Engineer",
                          style: AppTextStyles.text14w500,
                        )),
                    Text(
                      "Welcome to your voice interview!",
                      style: AppTextStyles.text32w600,
                    ),
                    GlassmorphicForm(),
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
