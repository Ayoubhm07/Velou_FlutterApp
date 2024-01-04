// icon_list_screen.dart
import 'package:flutter/material.dart';
import 'add_post_screen.dart'; // Importez votre fichier AddPostScreen
import 'posts.dart'; // Importez votre fichier PostsPage

class IconListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste d\'icônes'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              // Action à effectuer lorsque l'élément est tapé
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Ajouter'),
            onTap: () {
              // Naviguer vers AddPostScreen lorsque l'élément est tapé
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddPostScreen(scaffoldKey: GlobalKey<ScaffoldState>()),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.post_add),
          //   title: Text('Posts'),
          //   onTap: () {
          //     // Naviguer vers PostsPage lorsque l'élément est tapé
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => PostsPage()),
          //     );
          //   },
          // ),
          // Ajoutez d'autres éléments de liste au besoin
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action à effectuer lorsque le bouton est pressé
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
