import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';

  // Dynamic comment logic
  int commentCount = 0;
  List<String> comments = [];

  // Like logic
  bool isLiked = false;
  int likeCount = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      showHeart = true;
    });
    _animationController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          showHeart = false;
        });
      });
    });
  }

  void _addComment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController _commentController = TextEditingController();
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Add a Comment",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                TextField(
                  controller: _commentController,
                  decoration:
                      const InputDecoration(hintText: "Write your comment..."),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    String comment = _commentController.text.trim();
                    if (comment.isNotEmpty) {
                      setState(() {
                        comments.add(comment);
                        commentCount = comments.length;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Post"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAllComments() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          children: [
            const Text("All Comments",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: comments.isEmpty
                  ? const Center(child: Text("No comments yet."))
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.comment),
                        title: Text(comments[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _highlightText(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];

    final matches =
        RegExp(RegExp.escape(query), caseSensitive: false).allMatches(text);
    if (matches.isEmpty) return [TextSpan(text: text)];

    List<TextSpan> spans = [];
    int last = 0;

    for (final match in matches) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }

      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(
          backgroundColor: Color(0xFFD6EEFF),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
      last = match.end;
    }

    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    return spans;
  }

  final String name = 'Akhilesh Yadav';
  final String subtitle = 'Founder at Google';
  final String post = '''
The Briggs–Rauscher Reaction: A Mesmerizing Chemical Dance 🌈

This captivating process uses hydrogen peroxide, potassium iodate, malonic acid, manganese sulfate, and starch.
Iodine and iodate ions interact to form compounds that shift the solution's color, while starch amplifies the blue color before it breaks down and starts again. 💡

Follow @Science for more
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A73),
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'CATA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: 'LIFT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: const [
          Icon(Icons.person_outline, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.chat_bubble_outline, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0A73),
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'Explore Mentors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: 'Courses'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.purple),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.purple),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const CircleAvatar(radius: 24),
              title: RichText(
                text: TextSpan(
                  children: _highlightText(name, searchQuery),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: _highlightText(subtitle, searchQuery),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              trailing: const Icon(Icons.person_add_alt),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                text: TextSpan(
                  children: _highlightText(post, searchQuery),
                  style: const TextStyle(
                      height: 1.5, fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/1.jpeg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (showHeart)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isLiked ? Icons.star : Icons.star_border,
                        color: isLiked ? Colors.amber : Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text('$likeCount Stars'),
                    ],
                  ),
                  GestureDetector(
                    onTap: _showAllComments,
                    child: Text('$commentCount comments',
                        style: const TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            const Divider(),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _handleLike,
                        child: Icon(
                          isLiked ? Icons.star : Icons.star_border,
                          color: isLiked ? Colors.amber : Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: _addComment,
                        child: const Icon(Icons.chat_bubble_outline),
                      ),
                      const Icon(Icons.send_outlined),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
