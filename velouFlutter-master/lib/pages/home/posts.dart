import 'package:flutter/material.dart';
import 'add_post_screen.dart';
import 'post.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // Exemple de données statiques
  List<PostData> postsData = List.generate(
    10,
    (index) => PostData(
      id: index + 1,
      title: 'Event',
      description: 'Soyez nombreux!',
      privacy: 'Public',
      image: 'assets/images/bicycle.jpg',
      date: DateTime.now(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _navigateToAddPostScreen();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Titre')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Privacy')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Actions')),
          ],
          rows: postsData.map((post) {
            return DataRow(
              cells: [
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Text(post.id.toString()),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Text(post.title),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Text(post.description),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Text(post.privacy),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Image.asset(post.image),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Text(post.date.toString()),
                )),
                DataCell(
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Logique pour supprimer
                          _deletePost(post);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text('SUPPRIMER'),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // Logique pour modifier
                          _editPost(post);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text('Modifier'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _deletePost(PostData post) {
    setState(() {
      postsData.remove(post);
    });
  }

  void _editPost(PostData post) {
    // Logique pour modifier
  }

  void _navigateToPostPage(PostData post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(
          scaffoldKey: GlobalKey<ScaffoldState>(),
        ),
      ),
    );
  }

  void _navigateToAddPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddPostScreen(scaffoldKey: GlobalKey<ScaffoldState>()),
      ),
    );
  }
}

class PostData {
  final int id;
  final String title;
  final String description;
  final String privacy;
  final String image;
  final DateTime date;

  PostData({
    required this.id,
    required this.title,
    required this.description,
    required this.privacy,
    required this.image,
    required this.date,
  });
}
