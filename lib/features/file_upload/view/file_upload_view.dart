import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task1/core/network/network_manager.dart'; // NetworkManager'ı import edin
import 'package:task1/features/file_upload/view_model/file_upload_viewmodel.dart';

class FileUploadView extends StatefulWidget {
  const FileUploadView({Key? key}) : super(key: key);

  @override
  State<FileUploadView> createState() => _FileUploadViewState();
}

class _FileUploadViewState extends State<FileUploadView> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController(); // URL için controller

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FileUploadViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dosya Yükle'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Dosya URL',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen dosya URL\'sini girin';
                    }
                    // URL doğrulama ekleyebilirsiniz (opsiyonel)
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Consumer<FileUploadViewModel>(
                  builder: (context, viewModel, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await viewModel.uploadFileFromUrl(_urlController.text);
                            // Dosya başarıyla yüklenirse mesaj göster ve sayfayı kapat
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Dosya başarıyla yüklendi')),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            // Hata durumunda hata mesajını göster
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('Yükle'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}