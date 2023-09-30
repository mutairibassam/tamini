import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:tamini_app/app.dart';
import 'package:tamini_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// default will load [.env] file which located in project root
  await dotenv.load();
  var config = await Firebase.initializeApp(
      options: DefaultFirebaseOptions().currentPlatform);
  if (kDebugMode) {
    print(config);
  }
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
