import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import '../../widgets/circular_fab_widget.dart';

class PostPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PostPage({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _likeCount = 0;
  List<String> _comments = ["wwwwwww", "what an event", "Good Work!"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Post'),
      ),
      body: Stack(
        children: [
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
                      child: Image.asset(
                        'assets/images/bicycle.jpg',
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
                              _likePost();
                            },
                            icon: Icon(Icons.heart_broken),
                            label: Text('Like'),
                          ),
                          GestureDetector(
                            onTap: () {
                              _likePost();
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
                              child: Text(
                                '$_likeCount Like${_likeCount != 1 ? 's' : ''}',
                                key: ValueKey<int>(_likeCount),
                                style: TextStyle(fontSize: 16.0),
                              ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _likePost() {
    setState(() {
      _likeCount++;
    });
  }

  void _showCommentPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPopupSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150.0,
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
                        placeholder: 'Ajouter un commentaire...',
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        // Logic to add the comment to the list
                        // You can retrieve the text from the text field
                        // and add it to the _comments list
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
