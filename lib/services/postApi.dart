import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/posts.dart';

class PostApi {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // GET: Ambil semua posts
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // POST: Tambah post baru
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    print(
      'Create Response: ${response.statusCode} - ${response.body}',
    ); // Tambah logging

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post. Status: ${response.statusCode}');
    }
  }

  // PUT: Update post
  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    print('Update Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update post. Status: ${response.statusCode}');
    }
  }

  // DELETE: Hapus post
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    print('Delete Response: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post. Status: ${response.statusCode}');
    }
  }
}
