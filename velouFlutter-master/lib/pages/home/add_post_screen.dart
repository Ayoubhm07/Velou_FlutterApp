import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dashboard/pages/home/posts.dart';
import 'package:image_picker/image_picker.dart';
import 'icon_list_screen.dart';
import 'package:flutter_dashboard/model/post_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPostScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AddPostScreen({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Privacy options
  List<String> _privacyOptions = ['Private', 'Friends Only', 'Public'];
  String _selectedPrivacy = 'Private';

  var imageForSendToAPI;
  var img;
  var tempp;

  Future<void> _imgFromGallery() async {
    final temp = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    print(temp);
    imageForSendToAPI = await temp?.readAsBytes();
    //print(imageForSendToAPI);
    setState(() {
      tempp = temp;
      img = imageForSendToAPI;
    });
  }

  // Base URL for your API
  final String baseUrl = 'http://localhost:5004';

  Future<void> _addPost(Post newPost) async {
    if (_validateForm()) {
      try {
        final String url = 'http://localhost:5004/api/posts/add-post-and';

        // Create a new http.MultipartRequest
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['title'] = newPost.title;
        request.fields['desc'] = newPost.description;
        request.fields['state'] = newPost.state;
        request.fields['date'] = newPost.datep;
        request.fields['category'] = newPost.category;
        request.fields['image'] = newPost.image;

        // Add the image file

        // Send the request
        var response = await request.send();

        if (response.statusCode == 201) {
          // Decode the response data
          final responseData =
              json.decode(await response.stream.bytesToString());

          print('Post added successfully: $newPost');

          _showSuccessAlert();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PostsPage(scaffoldKey: widget.scaffoldKey),
            ),
          );
        } else {
          _showErrorAlert('Failed to add post');
        }
      } catch (error) {
        print(error);
        _showErrorAlert('An error occurred while adding the post.');
      }
    } else {
      _showValidationAlert();
    }
  }

  // Function to validate the form
  bool _validateForm() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedPrivacy.isEmpty ||
        imageForSendToAPI == null) {
      return false;
    } else if (!_titleController.text[0]
        .toUpperCase()
        .contains(RegExp('[A-Z]'))) {
      return false;
    }

    return true;
  }

  // Function to show validation alert
  void _showValidationAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Validation Error'),
          content: Text('Please fill in all the fields.'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show success alert
  void _showSuccessAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Success'),
          content: Text('Post added successfully!'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show error alert
  void _showErrorAlert(String errorMessage) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour naviguer vers la page Dashboard
  void _navigateToDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  // Fonction pour naviguer vers la page PostPage
  void _navigateToPostPage() {
    Navigator.of(context).pushReplacementNamed('/post');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IconListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/bicycle.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              color: Colors.white.withOpacity(0.7),
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Titre'),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                      SizedBox(height: 16.0),
                      // Privacy Choice Chip
                      Wrap(
                        spacing: 8.0,
                        children: _privacyOptions.map((option) {
                          return ChoiceChip(
                            label: Text(option),
                            selected: _selectedPrivacy == option,
                            onSelected: (selected) {
                              setState(() {
                                _selectedPrivacy = option;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Choose an image from gallery
                          await _imgFromGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: Text('Ajouter une Image'),
                      ),
                      SizedBox(height: 16),
                      imageForSendToAPI != null
                          ? Image.memory(imageForSendToAPI)
                          : Container(),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Validation du formulaire avant la soumission
                          if (_validateForm()) {
                            Post newPost = Post(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                image: img.toString(),
                                datep: DateTime.now().toIso8601String(),
                                state: _selectedPrivacy,
                                category: "");

                            _addPost(newPost);
                          } else {
                            _showValidationAlert();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: Text('Ajouter le Post'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
