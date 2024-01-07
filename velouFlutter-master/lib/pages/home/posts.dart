import 'dart:convert';
import 'dart:typed_data';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/home/add_post_screen.dart';
import 'package:flutter_dashboard/pages/home/post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dashboard/model/post_model.dart';
import 'package:intl/intl.dart';

class PostsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  PostsPage({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post> posts = [];
  bool sortByStateAscending = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response = await http
        .get(Uri.parse('http://localhost:5004/api/posts/get-all-posts'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        posts = responseData.map((post) => Post.fromJson(post)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void _deletePost(Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce post ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Ferme la boîte de dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Effectue la suppression du post
                await _performDeletePost(post);
                Navigator.pop(context); // Ferme la boîte de dialogue
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeletePost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5004/api/posts/delete-post'),
        body: {'postId': post.id}, // Assurez-vous que 'id' est le bon attribut
      );

      if (response.statusCode == 200) {
        // Suppression réussie
        // Vous pouvez également mettre à jour l'état local pour refléter les changements
        setState(() {
          posts.remove(post);
        });

        // Affichez un message à l'utilisateur si nécessaire
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post supprimé avec succès')),
        );
      } else {
        // Gestion des erreurs
        print(
            'Échec de la suppression du post. Code d\'état: ${response.statusCode}');
      }
    } catch (error) {
      // Gestion des erreurs
      print('Erreur lors de la suppression du post: $error');
    }
  }

  Uint8List convert(String img) {
    List<dynamic> decodedList = jsonDecode(img);
    Uint8List image = Uint8List.fromList(decodedList.cast<int>());
    return image;
  }

  String formatDateString(String dateString) {
    print("date");
    try {
      DateTime dateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parseUtc(dateString);

      // Formatez la date comme vous le souhaitez
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);

      return formattedDate;
    } catch (e) {
      // Gérer l'erreur si la conversion échoue
      return 'Date invalide';
    }
  }

  void _sortPostsByState() {
    setState(() {
      sortByStateAscending = !sortByStateAscending;
      posts.sort((a, b) {
        return sortByStateAscending
            ? a.state.compareTo(b.state)
            : b.state.compareTo(a.state);
      });
    });
  }

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
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _sortPostsByState();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Titre')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Privacy')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Actions')),
          ],
          rows: posts.map((post) {
            return DataRow(
              cells: [
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
                  child: Text(post.state),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Image.memory(convert(post.image)),
                )),
                DataCell(InkWell(
                  onTap: () {
                    _navigateToPostPage(post);
                  },
                  child: Text(post.datep),
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
                          // _editPost(post);
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

  void _navigateToPostPage(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(
          scaffoldKey: widget.scaffoldKey,
          post: post,
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
