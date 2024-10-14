import 'package:task1/core/utils/custom_appbar.dart';
import 'package:task1/core/utils/cu%C4%B1stom_navbar.dart';
import 'package:task1/features/file_list/viewmodel/file_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task1/features/file_upload/view/file_upload_view.dart';
import 'package:task1/features/signature/view/signature_view.dart';

class FileListView extends StatefulWidget {
  const FileListView({Key? key}) : super(key: key);

  @override
  State<FileListView> createState() => _FileListViewState();
}

class _FileListViewState extends State<FileListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FileListViewModel>(context, listen: false).fetchFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: CustomAppBar(title: 'Files'),
      body: Consumer<FileListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          } else if (viewModel.files.isEmpty) {
            return const Center(child: Text('Ürün bulunamadı.'));
          } else {
            return ListView.builder(
              itemCount: viewModel.files.length,
              itemBuilder: (context, index) {
                final file = viewModel.files[index];
                return ListTile(
                  title: Text(file.filename), 
                  subtitle: Text(file.location),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignatureView()),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FileUploadView()),
          ).then((_) {
            Provider.of<FileListViewModel>(context, listen: false).fetchFiles();
          });
        },
        backgroundColor: Colors.red, 
        child: const Icon(Icons.upload),
      ),
    );
  }
}
