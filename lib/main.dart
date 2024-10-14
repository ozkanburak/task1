import 'package:task1/features/authentication/view/login_view.dart';
import 'package:task1/features/authentication/viewmodel/login_viewmodel.dart';
import 'package:task1/features/file_list/viewmodel/file_list_viewmodel.dart'; // FileListViewModel'i import et
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()), // FileListViewModel provider'ını ekle
        ChangeNotifierProvider(create: (context) => FileListViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosya İmzalama Uygulaması',
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      //SignatureView()
    );
  }
}