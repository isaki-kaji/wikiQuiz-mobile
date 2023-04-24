import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_wiki_quiz/pages/category_page.dart';
import 'package:what_wiki_quiz/pages/home_ranking_page.dart';
import 'package:what_wiki_quiz/pages/play_page.dart';
import 'package:what_wiki_quiz/pages/prepare_page.dart';
import 'package:what_wiki_quiz/pages/result_page.dart';
import 'package:what_wiki_quiz/pages/time_up_page.dart';
import 'package:what_wiki_quiz/view_model.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: RealWikiQuiz()));
}

class RealWikiQuiz extends StatelessWidget {
  const RealWikiQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const HomePage(),
        '/category': (context) => const CategoryPage(),
        '/prepare': (context) => PreparePage(),
        '/play': (context) => const PlayPage(),
        '/result': (context) => const ResultPage(),
        '/time': (context) => const TimeUpPage(),
        '/ranking': (context) => const RankingPage(),
      },
    );
  }
}

class Handler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    if (viewModelProvider.auth.currentUser == null) {
      viewModelProvider.auth.signInAnonymously();
      viewModelProvider.getUid();
      viewModelProvider.register();
      viewModelProvider.getUser();
      print("nullです");
      print(viewModelProvider.uid);
    } else {
      viewModelProvider.getUid();
      viewModelProvider.getUser();
      print(viewModelProvider.uid);
    }
    return const HomePage();
  }
}
