class Post {
  final String? id;
  final String title;
  final String description;
  final String image; // Chemin ou URL de l'image
  final String datep;
  final String state;
  final String category;

  Post({
    this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.datep,
    required this.state,
    required this.category,
  });
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      datep: json['datep'] ?? '',
      state: json['state'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
