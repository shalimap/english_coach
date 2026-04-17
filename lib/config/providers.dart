import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/pages/Modules/providers/examples.dart';
import 'package:englishcoach/pages/Modules/providers/final_test_answers.dart';
import 'package:englishcoach/pages/Modules/providers/final_test_marksheet.dart';
import 'package:englishcoach/pages/Modules/providers/final_test_questions.dart';
import 'package:englishcoach/pages/Modules/providers/final_test_tests.dart';
import 'package:englishcoach/pages/Modules/providers/module_answers.dart';
import 'package:englishcoach/pages/Modules/providers/module_marksheet.dart';
import 'package:englishcoach/pages/Modules/providers/module_questions.dart';
import 'package:englishcoach/pages/Modules/providers/module_tests.dart';
import 'package:englishcoach/pages/Modules/providers/module_unlock.dart';
import 'package:englishcoach/pages/Modules/providers/modules.dart';
import 'package:englishcoach/pages/Modules/providers/structures.dart';
import 'package:englishcoach/pages/Modules/providers/topictest_answers.dart';
import 'package:englishcoach/pages/Modules/providers/topictest_marksheet.dart';
import 'package:englishcoach/pages/Modules/providers/topictest_questions.dart';
import 'package:englishcoach/pages/Modules/providers/topictest_tests.dart';
import 'package:englishcoach/pages/Modules/providers/videos.dart';
import 'package:englishcoach/pages/audio/provider/audioanswers.dart';
import 'package:englishcoach/pages/audio/provider/audiolocks.dart';
import 'package:englishcoach/pages/audio/provider/audiomarksheets.dart';
import 'package:englishcoach/pages/audio/provider/audioquestions.dart';
import 'package:englishcoach/pages/audio/provider/audios.dart';
import 'package:englishcoach/pages/audio/provider/audiotests.dart';
import 'package:englishcoach/pages/audio/provider/sections.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiochatrooms.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiochatusers.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiocontents.dart';
import 'package:englishcoach/pages/dailypopup/provider/dailypopups.dart';
import 'package:englishcoach/pages/dailypopup/provider/popuplists.dart';
import 'package:englishcoach/pages/payment/providers/banks.dart';
import 'package:englishcoach/pages/payment/providers/coupon.dart';
import 'package:englishcoach/pages/payment/providers/online_payments.dart';
import 'package:englishcoach/pages/payment/providers/tokens.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogram.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogramanswer.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogramcompleted.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_answered.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_options.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_questions.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_tests.dart';
import 'package:englishcoach/pages/preliminary2/providers/answers.dart';
import 'package:englishcoach/pages/preliminary2/providers/marksheets.dart';
import 'package:englishcoach/pages/preliminary2/providers/questions.dart';
import 'package:englishcoach/pages/preliminary2/providers/tests.dart';
import 'package:englishcoach/pages/profile/provider/profile_provider.dart';
import 'package:englishcoach/pages/trial/providers/examples.dart';
import 'package:englishcoach/pages/trial/providers/modules.dart';
import 'package:englishcoach/pages/trial/providers/structures.dart';
import 'package:englishcoach/pages/trial/providers/videos.dart';
import 'package:englishcoach/pages/trialTest/providers/module_unlock.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_answered.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_options.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_questions.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_tests.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (ctx) => Userprovider()),
    ChangeNotifierProvider(create: (ctx) => ProfileProvider()),
    ChangeNotifierProvider(create: (ctx) => McqTest()),
    ChangeNotifierProvider(create: (ctx) => McqQuestion()),
    ChangeNotifierProvider(create: (ctx) => McqOption()),
    ChangeNotifierProvider(create: (ctx) => McqAnswered()),
    ChangeNotifierProvider(create: (ctx) => PrelimTransAnswers()),
    ChangeNotifierProvider(create: (ctx) => PrelimTransMarksheets()),
    ChangeNotifierProvider(create: (ctx) => PrelimTransQuestions()),
    ChangeNotifierProvider(create: (ctx) => PrelimTransTests()),
    ChangeNotifierProvider(create: (ctx) => DailyPopUps()),
    ChangeNotifierProvider(create: (ctx) => PopUpLists()),
    ChangeNotifierProvider(create: (ctx) => AudioAnswers()),
    ChangeNotifierProvider(create: (ctx) => AudioLocks()),
    ChangeNotifierProvider(create: (ctx) => AudioMarksheets()),
    ChangeNotifierProvider(create: (ctx) => AudioQuestions()),
    ChangeNotifierProvider(create: (ctx) => Audios()),
    ChangeNotifierProvider(create: (ctx) => AudioTests()),
    ChangeNotifierProvider(create: (ctx) => Sections()),
    ChangeNotifierProvider(create: (ctx) => PictogramList()),
    ChangeNotifierProvider(create: (ctx) => PictogramAnswerList()),
    ChangeNotifierProvider(create: (ctx) => PictogramCompleted()),
    ChangeNotifierProvider(create: (ctx) => Examples()),
    ChangeNotifierProvider(create: (ctx) => FinaltestAnswers()),
    ChangeNotifierProvider(create: (ctx) => FinaltestMarksheet()),
    ChangeNotifierProvider(create: (ctx) => FinaltestQuestions()),
    ChangeNotifierProvider(create: (ctx) => FinalTestChecks()),
    ChangeNotifierProvider(create: (ctx) => ModuleAnswers()),
    ChangeNotifierProvider(create: (ctx) => ModuleMarkSheet()),
    ChangeNotifierProvider(create: (ctx) => ModuleQuestions()),
    ChangeNotifierProvider(create: (ctx) => ModuleTests()),
    ChangeNotifierProvider(create: (ctx) => ModuleUnlock()),
    ChangeNotifierProvider(create: (ctx) => Modules()),
    ChangeNotifierProvider(create: (ctx) => Structures()),
    ChangeNotifierProvider(create: (ctx) => TopicTestAnswer()),
    ChangeNotifierProvider(create: (ctx) => TopicTestMarksheet()),
    ChangeNotifierProvider(create: (ctx) => TopicTestQuestion()),
    ChangeNotifierProvider(create: (ctx) => TopicTests()),
    ChangeNotifierProvider(create: (ctx) => ModuleVideos()),
    ChangeNotifierProvider(create: (ctx) => TrialModuleUnlock()),
    ChangeNotifierProvider(create: (ctx) => TrialAnswered()),
    ChangeNotifierProvider(create: (ctx) => TrialOption()),
    ChangeNotifierProvider(create: (ctx) => TrialQuestion()),
    ChangeNotifierProvider(create: (ctx) => TrialTest()),
    ChangeNotifierProvider(create: (ctx) => Banks()),
    ChangeNotifierProvider(create: (ctx) => Coupons()),
    ChangeNotifierProvider(create: (ctx) => OnlinePayments()),
    ChangeNotifierProvider(create: (ctx) => Tokens()),
    ChangeNotifierProvider(create: (ctx) => TrialExamples()),
    ChangeNotifierProvider(create: (ctx) => TrialStructures()),
    ChangeNotifierProvider(create: (ctx) => TrialModules()),
    ChangeNotifierProvider(create: (ctx) => TrialVideo()),
    ChangeNotifierProvider(create: (ctx) => AudioContents()),
    ChangeNotifierProvider(create: (ctx) => AudioChatUsers()),
    ChangeNotifierProvider(create: (ctx) => AudioChatRooms()),
  ];
}
