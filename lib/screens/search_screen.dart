import 'package:chat_app/models/post.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTermController = TextEditingController();
  bool showUsers = false;
  @override
  void dispose() {
    super.dispose();
    _searchTermController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBgColor,
          title: TextFormField(
            decoration: const InputDecoration(labelText: "Search for a user"),
            onChanged: (String _) {
              setState(() {
                showUsers = true;
              });
            },
            controller: _searchTermController,
          ),
        ),
        body: showUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo:
                            _searchTermController.text.toUpperCase())
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  return switch (snapshot.connectionState) {
                    ConnectionState.waiting => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    _ => !snapshot.hasData
                        ? const Center(
                            child: Text("No user found"),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              UserModel user = UserModel.fromDocumentSnapshot(
                                  snapshot.data!.docs[index])!;

                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(uid: user.uid)));
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.dpUrl),
                                ),
                                title: Text(user.username),
                              );
                            })
                  };
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    default:
                      {
                        List<Widget> children = [];
                        int cellCount(int index) {
                          return MediaQuery.of(context).size.width > sm
                              ? 2
                              : index % 7 == 0
                                  ? 2
                                  : 1;
                        }

                        for (var i = 0; i < snapshot.data!.docs.length; i++) {
                          children.add(StaggeredGridTile.count(
                              crossAxisCellCount: cellCount(i),
                              mainAxisCellCount: cellCount(i),
                              child: Image.network(
                                  PostModel.fromDocumentSnapshot(
                                          snapshot.data!.docs[i])!
                                      .postUrl)));
                        }

                        return !snapshot.hasData || snapshot.data!.docs.isEmpty
                            ? const Center(
                                child: Text("No post"),
                              )
                            : StaggeredGrid.count(
                                crossAxisCount: 4,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                children: children,
                              );
                      }
                  }
                }));
  }
}
