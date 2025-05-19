class Post {
  final int? id;
  final String title;
  final String text;
  final String userName;
  final DateTime dateTime;
  final String? localImagePath;
  final String? imageUrl;
  final bool? isLiked;
  final int? likesCount;

  Post({
    this.id,
    required this.title,
    required this.text,
    required this.userName,
    required this.dateTime,
    this.localImagePath,
    this.imageUrl,
    this.likesCount,
    this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      userName: json['userName'] ?? 'Anonyme',
      dateTime: DateTime.parse(json['dateTime']),
      localImagePath: json['localImagePath'],
      imageUrl: json['imageUrl'],
      likesCount: json['likesCount'], // camelCase ici
      isLiked: json['isLiked'], // camelCase ici
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'userName': userName,
      'dateTime': dateTime.toIso8601String(),
      'localImagePath': localImagePath,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'isLiked': isLiked,
    };
  }

  Post copyWith({
    int? id,
    String? title,
    String? text,
    String? userName,
    DateTime? dateTime,
    String? localImagePath,
    String? imageUrl,
    bool? isLiked,
    int? likesCount,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      userName: userName ?? this.userName,
      dateTime: dateTime ?? this.dateTime,
      localImagePath: localImagePath ?? this.localImagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}
