import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'icon_list_screen.dart';
import 'package:dio/dio.dart';

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
  bool _imageVisible = false;
  File? _selectedImage;

  // Privacy options
  List<String> _privacyOptions = ['Private', 'Friends Only', 'Public'];
  String _selectedPrivacy = 'Private';

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Base URL for your API
  final String baseUrl = 'your_api_base_url_here';

  // Function to validate the form
  bool _validateForm() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedPrivacy.isEmpty ||
        _selectedImage == null) {
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

  // Function to add a post
  Future<void> _addPost() async {
    if (_validateForm()) {
      try {
        // Prepare FormData for the HTTP request
        FormData formData = FormData.fromMap({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'privacy': _selectedPrivacy,
          'image': await MultipartFile.fromFile(_selectedImage!.path),
        });

        // Send HTTP request to your API endpoint
        final response = await Dio().post(
          'http://localhost:5004/api/posts/add-post',
          data: formData,
        );

        if (response.statusCode == 201) {
          // Successfully added post
          _showSuccessAlert();
        } else {
          // Display an error message
          _showErrorAlert('Failed to add post');
        }
      } catch (error) {
        print(error);
        // Handle other errors if needed
        _showErrorAlert('An error occurred while adding the post.');
      }
    } else {
      // Show validation alert
      _showValidationAlert();
    }
  }

  // Fonction pour naviguer vers la page Dashboard
  void _navigateToDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  // Fonction pour naviguer vers la page PostPage
  void _navigateToPostPage() {
    Navigator.of(context).pushReplacementNamed('/post');
  }

  // Fonction pour afficher l'animation d'ajout de post
  void _animateAddPost() {
    // Ajoutez l'animation ici
    // Vous pouvez utiliser un AnimatedSwitcher ou une autre méthode d'animation
    // par exemple, vous pouvez utiliser le package "animated_floatingactionbutton"
    // https://pub.dev/packages/animated_floatingactionbutton
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
                          final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            setState(() {
                              _selectedImage = File(pickedFile.path);
                              _imageVisible = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: Text('Ajouter une Image'),
                      ),
                      SizedBox(height: 16.0),
                      if (_imageVisible)
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _selectedImage != null
                              ? Image.network(
                                  // Use the image path or URL here
                                  _selectedImage!.path,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),

                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Validation du formulaire avant la soumission
                          if (_validateForm()) {
                            // Soumettre le formulaire (Implémenter la logique ici)
                            _animateAddPost();
                          } else {
                            // Afficher l'alerte de validation
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
