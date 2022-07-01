import 'package:flutter/material.dart';

class AllFolders extends StatefulWidget {
  const AllFolders({Key? key}) : super(key: key);

  @override
  State<AllFolders> createState() => _AllFoldersState();
}

class _AllFoldersState extends State<AllFolders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Folders Page"),),
    );
  }
}