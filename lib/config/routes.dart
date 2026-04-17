import 'package:englishcoach/pages/Forgotpassword/screen/forgot_password.dart';
import 'package:englishcoach/pages/Forgotpassword/screen/resetpassword.dart';
import 'package:englishcoach/pages/Modules/screens/carousal.dart';
import 'package:englishcoach/pages/Modules/screens/cngatsscreen.dart';
import 'package:englishcoach/pages/Modules/screens/excercises_overview_screen.dart';
import 'package:englishcoach/pages/Modules/screens/finalreport-detailscreen.dart';
import 'package:englishcoach/pages/Modules/screens/finaltest-reportscreen.dart';
import 'package:englishcoach/pages/Modules/screens/finaltest-taketestscreen.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/Modules/screens/module_detail_screen.dart';
import 'package:englishcoach/pages/Modules/screens/module_test_report_screen.dart';
import 'package:englishcoach/pages/Modules/screens/module_test_screen(updated).dart';
import 'package:englishcoach/pages/Modules/screens/module_test_screen.dart';
import 'package:englishcoach/pages/Modules/screens/topic_test_screen.dart';
import 'package:englishcoach/pages/Modules/screens/videos_screen.dart';
import 'package:englishcoach/pages/Modules/screens/youtube_videoscreen.dart';
import 'package:englishcoach/pages/audio/screen/audio_cngatsscreen.dart';
import 'package:englishcoach/pages/audio/screen/audio_dashboard.dart';
import 'package:englishcoach/pages/audio/screen/audio_reportdetail.dart';
import 'package:englishcoach/pages/audio/screen/audio_reportscreen.dart';
import 'package:englishcoach/pages/audio/screen/audio_taketestscreen.dart';
import 'package:englishcoach/pages/audio/screen/audio_testrules.dart';
import 'package:englishcoach/pages/audio/screen/sections_dashboard.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatintro.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatroom.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatroomintro.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatroomtrial.dart';
import 'package:englishcoach/pages/audiochattrial/pages/groupchatroom.dart';
import 'package:englishcoach/pages/dailypopup/screen/dailypopup_screen.dart';
import 'package:englishcoach/pages/payment/screens/PaymentPage.dart';
import 'package:englishcoach/pages/pictogram/Screens/Pictogramtestscreen.dart';
import 'package:englishcoach/pages/pictogram/Screens/sentencescreen.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcq_reportpage.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqlandingpage.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqrules.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqtaketest.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqtestscreen.dart';
import 'package:englishcoach/pages/preliminary2/screens/landing_page.dart';
import 'package:englishcoach/pages/preliminary2/screens/prelim_testrules_page.dart';
import 'package:englishcoach/pages/preliminary2/screens/prelims_scorecard.dart';
import 'package:englishcoach/pages/preliminary2/screens/report_page.dart';
import 'package:englishcoach/pages/preliminary2/screens/translation_test_page.dart';
import 'package:englishcoach/pages/profile/screen/edit_profile.dart';
import 'package:englishcoach/pages/profile/screen/update_studytime.dart';
import 'package:englishcoach/pages/trial/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/trial/screens/module_detail_screen.dart';
import 'package:englishcoach/pages/trial/screens/overview_videoscreen.dart';
import 'package:englishcoach/pages/trial/screens/video_screen.dart';
import 'package:englishcoach/pages/trialTest/screens/congratsscreen.dart';
import 'package:englishcoach/pages/trialTest/screens/trial_reportpage.dart';
import 'package:englishcoach/pages/trialTest/screens/trialreport_screen.dart';
import 'package:englishcoach/pages/trialTest/screens/trialtaketest.dart';
import 'package:showcaseview/showcaseview.dart';

import '../pages/trial/screens/video_screen_web.dart';
import '/pages/profile/screen/profilePage.dart';

import '/pages/otp/screen/verificationpage.dart';

import '/pages/signup/screen/signup.dart';
import 'package:flutter/material.dart';
import '/pages/splash/splash.dart';
import '/pages/login/screen/login.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/splash': (context) => SplashScreen(),
    LoginPage.routename: (context) => LoginPage(),
    SignupPage.routename: (context) => SignupPage(),
    PhoneVerification.routename: (context) => PhoneVerification(),
    ProfilePage.routename: (context) =>
        ShowCaseWidget(builder: Builder(builder: (context) => ProfilePage())),
    McqReportPage.routename: (context) => McqReportPage(),
    McqLandingPage.routename: (context) => McqLandingPage(),
    MCQRules.routename: (ctx) => MCQRules(),
    McqTaketest.routename: (ctx) => McqTaketest(),
    McqTestScreen.routename: (ctx) => McqTestScreen(),
    TransLandingPage.routeName: (ctx) => TransLandingPage(),
    Prelim2TestRules.routeName: (ctx) => Prelim2TestRules(),
    ScoreCard.routeName: (ctx) =>
        ShowCaseWidget(builder: Builder(builder: (context) => ScoreCard())),
    TransReportScreen.routename: (ctx) => TransReportScreen(),
    TranslationTest.routeName: (ctx) => TranslationTest(),
    DailyPopUpScreen.routeName: (ctx) => DailyPopUpScreen(),
    CarousalScreen.routeName: (ctx) => CarousalScreen(),
    Congrats.routename: (ctx) => Congrats(),
    ExcercisesoverviewScreen.routeName: (ctx) => ExcercisesoverviewScreen(),
    ReportDetailscreen.routename: (ctx) => ReportDetailscreen(),
    TestReportScreen.routename: (ctx) => TestReportScreen(),
    TaketestScreen.routename: (ctx) => TaketestScreen(),
    EditProfile.routeName: (ctx) => EditProfile(),
    AudioCongrats.routename: (ctx) => AudioCongrats(),
    AudioDashboard.routeName: (ctx) => AudioDashboard(),
    AudioReportDetail.routename: (ctx) => AudioReportDetail(),
    AudioTestReportScreen.routename: (ctx) => AudioTestReportScreen(),
    AudioTaketestScreen.routename: (ctx) => AudioTaketestScreen(),
    AudioTestRules.routeName: (ctx) => AudioTestRules(),
    SectionsDashboard.routeName: (ctx) => SectionsDashboard(),
    MenuDashboardPage.routeName: (ctx) => ShowCaseWidget(
        builder: Builder(builder: (context) => MenuDashboardPage())),
    PictogramTestScreen.routename: (ctx) => PictogramTestScreen(),
    SentenceScreen.routename: (ctx) => SentenceScreen(),
    ModuleDetailScreen.routeName: (ctx) => ModuleDetailScreen(),
    ModuleTestReportScreen.routeName: (ctx) => ModuleTestReportScreen(),
    ModuleTestScreen.routeName: (ctx) => ModuleTestScreen(),
    ModuleTest.routeName: (ctx) => ModuleTest(),
    TopicsTest.routeName: (ctx) => TopicsTest(),
    ModuleVideoPage.routeName: (ctx) => ModuleVideoPage(),
    YoutubeVideoScreen.routeName: (ctx) => YoutubeVideoScreen(),
    TrialDashboardPage.routeName: (ctx) => TrialDashboardPage(),
    CongratsScreen.routename: (ctx) => CongratsScreen(),
    TrialReportPage.routename: (ctx) => TrialReportPage(),
    TrialReportscreen.routename: (ctx) => TrialReportscreen(),
    TrialTaketest.routename: (ctx) => TrialTaketest(),
    TrialModuleDetailScreen.routeName: (ctx) => TrialModuleDetailScreen(),
    OverviewVideoScreen.routeName: (ctx) => OverviewVideoScreen(),
    VideoPage.routeName: (ctx) => VideoPage(),
    VideoPageWeb.routeName: (ctx) => VideoPageWeb(),
    PaymentPage.routename: (ctx) => PaymentPage(),
    ForgotPasswordscreen.routeName: (ctx) => ForgotPasswordscreen(),
    ResetPassword.routename: (ctx) => ResetPassword(),
    ChatRoomIntroPage.routeName: (ctx) => ChatRoomIntroPage(),
    ChatRoomTrialPage.routeName: (ctx) => ChatRoomTrialPage(),
    SelectStudyTime.routeName: (ctx) => SelectStudyTime(),
    ChatIntroPage.routeName: (ctx) => ChatIntroPage(),
    ChatRoomPage.routeName: (ctx) => ChatRoomPage(),
    GroupChatRoomPage.routeName: (ctx) => GroupChatRoomPage(),
  };
}
