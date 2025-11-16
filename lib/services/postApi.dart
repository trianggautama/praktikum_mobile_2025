import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/posts.dart';

class PostApi {
  static const String _baseUrl =
      'https://api-post.banjarmasinkota.xyz/api/posts';

  // GET: Ambil semua posts
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'Authorization': 'Bearer API_hS8a3KmtRpCnxEtA1UxAyQHV4AWBWxqX'},
    );

    print('Fetch Posts Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      List<dynamic> body;

      // Handle different response formats
      if (decodedResponse is Map<String, dynamic>) {
        // If response is wrapped in an object, try common keys
        if (decodedResponse.containsKey('data')) {
          body = decodedResponse['data'];
        } else if (decodedResponse.containsKey('posts')) {
          body = decodedResponse['posts'];
        } else if (decodedResponse.containsKey('results')) {
          body = decodedResponse['results'];
        } else {
          throw Exception('Unknown response format: ${response.body}');
        }
      } else if (decodedResponse is List) {
        // If response is directly a list
        body = decodedResponse;
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }

      return body.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts. Status: ${response.statusCode}');
    }
  }

  // POST: Tambah post baru
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer API_hS8a3KmtRpCnxEtA1UxAyQHV4AWBWxqX',
      },
      body: jsonEncode(post.toJson()),
    );

    print(
      'Create Response: ${response.statusCode} - ${response.body}',
    ); // Tambah logging

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      // Handle different response formats
      if (decodedResponse is Map<String, dynamic>) {
        // If response is wrapped, try common keys
        if (decodedResponse.containsKey('data')) {
          return Post.fromJson(decodedResponse['data']);
        } else if (decodedResponse.containsKey('post')) {
          return Post.fromJson(decodedResponse['post']);
        } else {
          // Try to parse the response directly
          return Post.fromJson(decodedResponse);
        }
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      throw Exception(
        'Failed to create post. Status: ${response.statusCode} - Body: ${response.body}',
      );
    }
  }

  // PUT: Update post
  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${post.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer API_hS8a3KmtRpCnxEtA1UxAyQHV4AWBWxqX',
      },
      body: jsonEncode(post.toJson()),
    );

    print('Update Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);

      // Handle different response formats
      if (decodedResponse is Map<String, dynamic>) {
        // If response is wrapped, try common keys
        if (decodedResponse.containsKey('data')) {
          return Post.fromJson(decodedResponse['data']);
        } else if (decodedResponse.containsKey('post')) {
          return Post.fromJson(decodedResponse['post']);
        } else {
          // Try to parse the response directly
          return Post.fromJson(decodedResponse);
        }
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      throw Exception(
        'Failed to update post. Status: ${response.statusCode} - Body: ${response.body}',
      );
    }
  }

  // DELETE: Hapus post
  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Authorization': 'Bearer API_hS8a3KmtRpCnxEtA1UxAyQHV4AWBWxqX'},
    );

    print('Delete Response: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post. Status: ${response.statusCode}');
    }
  }
}
