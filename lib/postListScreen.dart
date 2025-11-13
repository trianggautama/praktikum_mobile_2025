import 'package:flutter/material.dart';
import 'package:todo_app/models/posts.dart';
import 'package:todo_app/services/postApi.dart';
import 'package:todo_app/PostForm.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> futurePosts;
  final PostApi postAPI = PostApi();

  @override
  void initState() {
    super.initState();
    futurePosts = postAPI.fetchPosts();
  }

  void _refreshPosts() {
    setState(() {
      futurePosts = postAPI.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          final posts = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _refreshPosts(),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(
                        post.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostForm(post: post),
                                ),
                              );
                              if (result == true) _refreshPosts();
                            },
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await postAPI.deletePost(post.id);
                              _refreshPosts();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      // Add button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostForm()),
          );
          if (result == true) _refreshPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
