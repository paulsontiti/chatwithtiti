import 'dart:typed_data';

import 'package:chat_app/consumers/user_provider/post_textbutton.dart';
import 'package:chat_app/consumers/user_provider/user_dp_username.dart';
import 'package:chat_app/firebase/firestore/firestore_methods.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  void _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera, context);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Select photo from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file =
                      await pickImage(ImageSource.gallery, context);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _clearPost() {
    setState(() {
      _file = null;
    });
  }

  void _postImage(String uid, String username, String dp) async {
    debugPrint("I'm here");
    if (_descriptionController.text == "") {
      showSnackbar('Please write a caption', context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        String res = await FirestoreMethods()
            .uploadPost(_descriptionController.text, _file!, uid, username, dp);
        res == 'success'
            ? showSnackbar(
                'Post successful, waiting for Admin to approve. Thanks for sharing',
                context)
            : showSnackbar(res, context);
        setState(() {
          _isLoading = false;
        });
        _clearPost();
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(err.toString(), context);
        _clearPost();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: GestureDetector(
            onTap: () => _selectImage(context),
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.upload), Text("Upload a photo")]),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBgColor,
              leading: IconButton(
                  onPressed: _clearPost,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                  )),
              title: const Text(
                "Share your beautiful picture",
                style: TextStyle(fontSize: 16),
              ),
              centerTitle: false,
              actions: [PostTextButton(postImage: _postImage)],
            ),
            body: Column(children: [
              const SizedBox(
                height: 12,
              ),
              _isLoading ? const LinearProgressIndicator() : Container(),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserDpUserName(false),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: primaryColor,
                    thickness: 5,
                    height: 5,
                  ),
                ],
              )
            ]));
  }
}
