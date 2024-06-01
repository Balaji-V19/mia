import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mia/notifiers/interview_notifier.dart';
import 'package:mia/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:mia/router.dart' as Router;
import 'constants/app_colors.dart';
import 'constants/app_textstyle.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const MiaHome());
}


class MiaHome extends StatefulWidget {
  const MiaHome({Key? key}) : super(key: key);

  @override
  State<MiaHome> createState() => _MiaHomeState();
}

class _MiaHomeState extends State<MiaHome> {

  late InterviewNotifier _initNotifier;

  @override
  void initState() {
    super.initState();
    _initNotifier = InterviewNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _initNotifier),
        ],
        builder: (context, child) {
          ScreenUtil.init(context);
          return MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: AppColors.primary,
                hintColor: AppColors.secondary,
                textTheme: TextTheme(
                  bodyLarge: AppTextStyles.text16w600,
                  bodyMedium: AppTextStyles.text14w500,
                ),
                appBarTheme:
                const AppBarTheme(backgroundColor: AppColors.primary)),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AppColors.secondary,
              hintColor: AppColors.primary,
              appBarTheme:
              const AppBarTheme(backgroundColor: AppColors.primary),
              textTheme: TextTheme(
                bodyLarge:
                AppTextStyles.text16w600.copyWith(color: AppColors.white),
                bodyMedium:
                AppTextStyles.text14w500.copyWith(color: AppColors.white),
              ),
            ),
            themeMode: ThemeMode.system,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Mia',
            home: const SplashScreen(),
            onGenerateRoute: Router.Router().routes,
          );
        });
  }
}