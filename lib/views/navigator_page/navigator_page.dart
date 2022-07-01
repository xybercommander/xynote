import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xynote/utils/theme.dart';
import 'package:xynote/views/auth/providers/user_provider.dart';
import 'package:xynote/views/folders/all_folders.dart';
import 'package:xynote/views/notes/screens/all_notes.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, UserProvider userProvider, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.primaryColor,
              elevation: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: CachedNetworkImageProvider(userProvider.imageUrl),
                    radius: 20,
                  ),
                  SizedBox(width: 12,),
                  Text(userProvider.username, style: TextStyle(color: AppTheme.textColor),),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.search, color: AppTheme.widgetColor,)
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.more_horiz, color: AppTheme.widgetColor,)
                ),
              ],
              bottom: TabBar(
                indicatorColor: AppTheme.widgetColor,
                tabs: [
                  Tab(child: Text("All Notes", style: TextStyle(color: AppTheme.textColor)),),
                  Tab(child: Text("Folders", style: TextStyle(color: AppTheme.textColor)),),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AllNotes(),
                AllFolders()
              ],
            ),
          ),
        );
      }
    );
  }
}