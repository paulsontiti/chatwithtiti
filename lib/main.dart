import 'package:chat_app/firebase/firebase_config.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/responsive/mobile_screen_layout.dart';
import 'package:chat_app/responsive/responsive_layout_screen.dart';
import 'package:chat_app/responsive/web_screen_layout.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: FirebaseConfig.apiKey,
            appId: FirebaseConfig.appId,
            storageBucket: FirebaseConfig.storageBucket,
            messagingSenderId: FirebaseConfig.messagingSenderId,
            projectId: FirebaseConfig.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat with Titi',
            home: StreamBuilder(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  return switch (snapshot.connectionState) {
                    ConnectionState.active => snapshot.hasData
                        ? const ResponsiveLayout(
                            webScreenLayout: WebScreenLayout(),
                            mobileScreenLayout: MobileScreenLayout())
                        : snapshot.hasError
                            ? Center(
                                child: Text(snapshot.error.toString()),
                              )
                            : const LoginScreen(),
                    ConnectionState.waiting => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    _ => const LoginScreen()
                  };
                })));
  }
}
