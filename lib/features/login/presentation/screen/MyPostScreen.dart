import 'package:flutter/material.dart';

class MyPostScreen extends StatelessWidget {
  const MyPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PostModel> posts = [
      PostModel(
        title: 'गाई',
        price: 'रु. 30,000',
        age: '5 वर्षं',
        calves: '3',
        milk: '10 - 12 लिटर',
        views: 2,
        likes: 0,
        status: 'Active',
        imagePath: 'assets/images/gav2.png',
      ),
      PostModel(
        title: 'गाई',
        price: 'रु. 30,000',
        age: '5 वर्षं',
        calves: '3',
        milk: '10 - 12 लिटर',
        views: 2,
        likes: 0,
        status: 'Active',
        imagePath: 'assets/images/gav2.png',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Important for gradient visibility
        title: Text(
          'माझ्या पोस्ट',
          style: TextStyle(
            color: Colors.black, // Title color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {

            },
          ),
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2E7D32), // Green at top
                Color(0xFFFFFFFF), // White at bottom
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'सर्व पोस्ट पहा (${posts.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () async {
                              final RenderBox button =
                              context.findRenderObject() as RenderBox;
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;

                              final RelativeRect position =
                              RelativeRect.fromRect(
                                Rect.fromPoints(
                                  button.localToGlobal(Offset.zero,
                                      ancestor: overlay),
                                  button.localToGlobal(
                                      button.size.bottomRight(Offset.zero),
                                      ancestor: overlay),
                                ),
                                Offset.zero & overlay.size,
                              );

                              final selected = await showMenu(
                                context: context,
                                position: position,
                                items: const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              );

                              if (selected == 'edit') {
                                // Handle edit
                              } else if (selected == 'delete') {
                                // Handle delete
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          post.imagePath,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(post.price),
                            const SizedBox(height: 4),
                            Text('वय: ${post.age}'),
                            Text('बछडे: ${post.calves}'),
                            Text('दूध: ${post.milk}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text('व्ह्यूज: ${post.views}'),
                      const SizedBox(width: 12),
                      const Icon(Icons.favorite_border,
                          size: 16, color: Colors.pink),
                      const SizedBox(width: 4),
                      Text('लाईक्स: ${post.likes}'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Add your desired action here (optional)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          post.status,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PostModel {
  final String title;
  final String price;
  final String age;
  final String calves;
  final String milk;
  final int views;
  final int likes;
  final String status;
  final String imagePath;

  PostModel({
    required this.title,
    required this.price,
    required this.age,
    required this.calves,
    required this.milk,
    required this.views,
    required this.likes,
    required this.status,
    required this.imagePath,
  });
}
