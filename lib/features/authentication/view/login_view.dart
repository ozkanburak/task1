import 'package:task1/features/authentication/viewmodel/login_viewmodel.dart';
import 'package:task1/features/file_list/view/file_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>  
 {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool  _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(  

      create: (context) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 183, 58, 58),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Consumer<LoginViewModel>(
                builder: (context, viewModel, child) {
                  // Listener ekleyin
                  viewModel.addListener(() {
                    if (viewModel.user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const FileListView()),
                      );
                    }
                  });
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0), 

                        ),
                        child: const Icon(
                          Icons.login,
                          size: 64.0,
                          color: Color.fromARGB(255, 183, 58, 58),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // ECORP Yazısı
                      const Text(
                        'File Signature',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // Form
                      Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), 
                          child: Form(
                            key: _formKey,
                            child: Column(  
                              children: [
                                // Email
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.person),  

                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Lütfen email adresinizi girin';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                // Şifre
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText; 
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Lütfen şifrenizi girin';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                // Şifremi Unuttum
                                TextButton(
                                  onPressed: () {
                                    // TODO: Şifremi Unuttum işlemleri
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                // Giriş Yap Butonu
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                    textStyle: const TextStyle(fontSize: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      viewModel.login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                  },
                                  child: const Text('LOGIN'),
                                ),
                                const SizedBox(height: 8.0),
                                // Kayıt Ol Butonu
                                TextButton(
                                  onPressed: () {
                                  },
                                  child: const Text(
                                    'SIGNUP',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                                if (viewModel.errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      viewModel.errorMessage,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}