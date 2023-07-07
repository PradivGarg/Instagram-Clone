import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociagram/providers/user_provider.dart';
import 'package:sociagram/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/utils.dart';
import 'package:sociagram/Resources/firestore_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  _selectImage(BuildContext parentcontext) async {
    return showDialog(
        context: parentcontext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: <Widget>[
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a photo'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Choose form Gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void PostImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = false;
    });

    //try catch block for posting image
    try {
      //upload  to storage and db
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar('Posted!', context);
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(res, context);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider UserProvider = Provider.of<userProvider>(context);
    return _file == null
        ? Center(
            child: IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => _selectImage(
                context), //TODO add functionality for adding post to database and navigating back to home
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => PostImage(
                      UserProvider.getUser.uid,
                      UserProvider.getUser.username,
                      UserProvider.getUser.photoURL),
                  child: const Text('Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ],
            ),
            body: Column(children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0.0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(UserProvider.getUser.photoURL),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'write a caption',
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        )),
                  ),
                  const Divider(),
                ],
              ),
            ]));
  }
}
