import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dashboard/model/post_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../widgets/circular_fab_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Post post;

  const PostPage({Key? key, required this.scaffoldKey, required this.post})
      : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<String> _comments = ["wwwwwww", "what an event", "Good Work!"];
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // Fetch post details when the widget is created
    _fetchPostDetails();
  }

  void _fetchPostDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5004/api/posts/${widget.post.id}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> postDetails = json.decode(response.body);

        setState(() {
          _comments = postDetails['comments'] != null
              ? List<String>.from(postDetails['comments'])
              : [];
        });
      } else {
        print(
            'Failed to fetch post details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching post details: $error');
    }
  }

  Uint8List convert(String img) {
    List<dynamic> decodedList = jsonDecode(img);
    Uint8List image = Uint8List.fromList(decodedList.cast<int>());
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Post'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CircularFabWidget(), // Your CircularFabWidget here
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      title: Text('Hammoudi Ayoub'),
                    ),
                    ClipRect(
                      child: Image.memory(
                        convert(widget.post
                            .image), // Utilisez la méthode convert pour décoder l'image binaire
                        fit: BoxFit.cover,
                        height: 200.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            icon: Icon(Icons.heart_broken),
                            label: Text('Like'),
                            style: ElevatedButton.styleFrom(
                              primary: isLiked ? Colors.red : null,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // _likePost();
                            },
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  child: child,
                                  scale: animation,
                                );
                              },
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showCommentPopup(context);
                            },
                            icon: Icon(Icons.comment),
                            label: Text('Comment'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _sharePost();
                            },
                            icon: Icon(Icons.share),
                            label: Text('Share'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Ajustez l'espacement entre le titre et la date
                        children: [
                          Text(
                            widget.post.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getCurrentDate(),
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to get the current date in the format "dd/MM/yyyy"
  String _getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  void _showCommentPopup(BuildContext context) {
    TextEditingController _commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      title: Text('Ayoub'),
                      subtitle: Text(_comments[index]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _commentController,
                        placeholder: 'Ajouter un commentaire...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        // Retrieve the text from the text field
                        String newComment = 'Ayoub: ' + _commentController.text;

                        // Check for bad words
                        if (_containsBadWord(newComment)) {
                          _showBadWordAlert(context);
                        } else {
                          // Add the new comment to the list
                          setState(() {
                            _comments.add(newComment);
                          });
                          // Clear the text field
                          _commentController.clear();
                          // Close the comment popup
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Envoyer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _containsBadWord(String comment) {
    // Liste de mots interdits
    List<String> badWords = ['shit', 'shut up', 'fuck you'];

    // Vérifie si le commentaire contient l'un des mots interdits
    for (String word in badWords) {
      if (comment.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }

  void _showBadWordAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mots inappropriés détectés !'),
          content: Text('Veuillez ne pas utiliser de langage offensant.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Ferme la boîte de dialogue
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _sharePost() {
    // Replace 'Your Post Content' with the content you want to share
    final String postContent = 'Upcoming Event';

    // Replace 'Your App Name' with the name of your app
    final String appName = 'Velou';

    // Replace 'Your App Store URL' with the URL of your app on the App Store
    final String appStoreUrl = 'Velou.tn';

    // Generate a shareable message
    final String message =
        '$postContent\n\nShared via $appName.\nGet the app: $appStoreUrl';

    // Share the message using the share_plus package
    Share.share(message);
  }
}
