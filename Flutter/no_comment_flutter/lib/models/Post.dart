class Post {
  final String title;
  final String text;
  final String userName;
  final DateTime dateTime;
  final String? localImagePath;
  final String? imageUrl; // <-- ajouté

  Post({
    required this.title,
    required this.text,
    required this.userName,
    required this.dateTime,
    this.localImagePath,
    this.imageUrl, // <-- ajouté
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      userName: json['user_name'] ?? '',
      dateTime: DateTime.parse(json['created_at']),
      localImagePath: json['local_image_path'], // peut être null
      imageUrl: json['image_url'], // ou 'imageUrl' selon ta clé JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'user_name': userName,
      'created_at': dateTime.toIso8601String(),
      'local_image_path': localImagePath,
      'image_url': imageUrl,
    };
  }
}
