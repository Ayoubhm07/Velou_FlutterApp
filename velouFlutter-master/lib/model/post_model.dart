enum PostState { private, public, friendsOnly }

class Post {
  final String title;
  final String description;
  final String image; // Chemin ou URL de l'image
  final DateTime date;
  final PostState state;
  final String category;

  Post({
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.state,
    required this.category,
  });
}
