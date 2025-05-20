class Post {
  final int? id;
  final String title;
  final String text;
  final String userName;
  final DateTime dateTime;
  final String? localImagePath;
  final String? media;
  final bool? isLiked;
  final int? likesCount;
  final String? location;

  Post({
    this.id,
    required this.title,
    required this.text,
    required this.userName,
    required this.dateTime,
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
      userName: json['userName'] ?? 'Anonyme',
      dateTime: DateTime.parse(json['dateTime']),
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
      'userName': userName,
      'dateTime': dateTime.toIso8601String(),
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
    String? userName,
    DateTime? dateTime,
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
      userName: userName ?? this.userName,
      dateTime: dateTime ?? this.dateTime,
      localImagePath: localImagePath ?? this.localImagePath,
      media: imageUrl ?? this.media,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      location: location ?? this.location,
    );
  }
}
