class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  // Factory constructor untuk parsing JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title'], body: json['body']);
  }

  // Method untuk konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      // Untuk update, kita perlu mengirim ID juga
      if (id != 0) 'id': id,
    };
  }
}
