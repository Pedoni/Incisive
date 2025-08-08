import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  double _currentPage = 0.0;

  final List<String> _images = ['assets/images/bedroom.jpeg', 'assets/images/living.jpeg', 'assets/images/balcony.jpeg'];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOverlayOpacity() {
    final diff = (_currentPage - _currentPage.round()).abs();
    return (diff * 4).clamp(0.0, 1.0) * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            itemBuilder: (context, index) => StanzaWidget(imagePath: _images[index]),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(16.0),
            height: 80,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(color: const Color.fromARGB(83, 255, 255, 255), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: const CircleBorder(), padding: EdgeInsets.zero),
                  child: const Icon(Icons.info_outline_rounded, size: 28, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: const CircleBorder(), padding: EdgeInsets.zero),
                  child: const Icon(Icons.account_circle_rounded, size: 28, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: const CircleBorder(), padding: EdgeInsets.zero),
                  child: const Icon(Icons.settings, size: 28, color: Colors.black),
                ),
              ],
            ),
          ),
          IgnorePointer(child: Container(color: Colors.black.withOpacity(_calculateOverlayOpacity()))),
        ],
      ),
    );
  }
}

class StanzaWidget extends StatelessWidget {
  final String imagePath;

  const StanzaWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Image.asset(imagePath, fit: BoxFit.cover));
  }
}
