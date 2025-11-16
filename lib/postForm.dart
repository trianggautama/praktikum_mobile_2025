import 'package:flutter/material.dart';
import 'package:todo_app/models/posts.dart';
import 'package:todo_app/services/postApi.dart';
import 'package:todo_app/navigationBar.dart';

class PostForm extends StatefulWidget {
  final Post? post; // Null untuk create, ada untuk update

  const PostForm({super.key, this.post});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final PostApi postApi = PostApi();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Jika mode edit, isi form dengan data existing
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        final post = Post(
          id: widget.post?.id ?? 0, // Tidak digunakan untuk create
          title: _titleController.text,
          body: _bodyController.text,
        );

        print('Attempting to save post: ${post.toJson()}');

        if (widget.post == null) {
          // Create new post
          print('Creating new post...');
          await postApi.createPost(post);
          print('Post created successfully');
        } else {
          // Update existing post
          print('Updating post with ID: ${post.id}');
          await postApi.updatePost(post);
          print('Post updated successfully');
        }

        print('Navigating back to MainNavigator with Posts tab...');
        // Navigate back to MainNavigator and set to Posts tab (index 2)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainNavigator(initialIndex: 2),
          ),
          (Route<dynamic> route) => false,
        );
        print('Navigation completed');
      } catch (e) {
        print('Error in savePost: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Add Post' : 'Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Body field
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit button
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _savePost,
                      child: Text(widget.post == null ? 'Create' : 'Update'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
