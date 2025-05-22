class Post {
  final int? id;
  final String title;
  final String text;
  final String username;
  final DateTime datetime;
  final String? localImagePath;
  final String? media;
  final bool? isLiked;
  final int? likesCount;
  final String? location;

  Post({
    this.id,
    required this.title,
    required this.text,
    required this.username,
    required this.datetime,
    this.localImagePath,
    this.media,
    this.likesCount,
    this.isLiked,
    this.location,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      username: json['username'] ?? 'Anonyme',
      datetime: DateTime.parse(json['datetime']),
      localImagePath: json['localImagePath'],
      media: json['media'],
      likesCount: json['likesCount'],
      isLiked: json['isLiked'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'username': username,
      'datetime': datetime.toIso8601String(),
      'localImagePath': localImagePath,
      'media': media,
      'likesCount': likesCount,
      'isLiked': isLiked,
      'location': location,
    };
  }

  Post copyWith({
    int? id,
    String? title,
    String? text,
    String? username,
    DateTime? datetime,
    String? localImagePath,
    String? imageUrl,
    bool? isLiked,
    int? likesCount,
    String? location,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      username: username ?? this.username,
      datetime: datetime ?? this.datetime,
      localImagePath: localImagePath ?? this.localImagePath,
      media: imageUrl ?? this.media,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      location: location ?? this.location,
    );
  }
}
