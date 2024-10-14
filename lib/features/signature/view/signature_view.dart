import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:task1/features/signature/view_model/signature_viewmodel.dart';



class SignatureView extends StatelessWidget {
  const SignatureView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignatureViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('İmza Ekranı'),
        ),
        body: Consumer<SignatureViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: Signature(
                    controller: viewModel.controller,
                    height: 300,
                    backgroundColor: Colors.grey[300]!,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: viewModel.clearSignature,
                      child: const Text('Temizle'),
                    ),
                    ElevatedButton(
                      onPressed: viewModel.saveSignature,
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (viewModel.controller.isNotEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      final image = await viewModel.controller.toPngBytes();
                      if (image != null) {
                        // İmzayı görüntü olarak kaydet
                        saveImage(context, image); // context'i parametre olarak geç
                      }
                    },
                    child: const Text('İmzayı Görüntüle'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // context parametresi eklendi
  Future<void> saveImage(BuildContext context, Uint8List imageBytes) async {
    // Depolama iznini iste
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(imageBytes);
      if (result['isSuccess']) {
        // Görüntü başarıyla kaydedildi
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('İmza başarıyla kaydedildi!'),
        ));
      } else {
        // Görüntü kaydedilirken bir hata oluştu
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('İmza kaydedilirken bir hata oluştu!'),
        ));
      }
    } else {
      // İzin reddedildi
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Depolama izni gerekli!'),
      ));
    }
  }
}