import 'package:flutter/material.dart';
import 'package:incisive/ui/pages/balcony_page.dart';
import 'package:incisive/ui/pages/diary_page.dart';
import 'package:incisive/ui/pages/turntable_page.dart';

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
    return (diff * 4).clamp(0.0, 1.0);
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
            itemBuilder: (context, index) => StanzaWidget(imagePath: _images[index], stanzaIndex: index),
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
  final int stanzaIndex;

  const StanzaWidget({super.key, required this.imagePath, required this.stanzaIndex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
            if (stanzaIndex == 0)
              Positioned(
                left: width * 0.45,
                top: height * 0.47,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DiaryPage.routeName);
                  },
                  child: Hero(tag: "diario", child: Image.asset('assets/images/diary_icon.png', width: width * 0.12)),
                ),
              ),
            if (stanzaIndex == 1)
              Positioned(
                left: width * 0.6,
                top: height * 0.37,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, TurntablePage.routeName);
                  },
                  child: Hero(tag: "giradischi", child: Image.asset('assets/images/turntable.png', width: width * 0.2)),
                ),
              ),
            if (stanzaIndex == 2)
              Positioned(
                left: width * 0.42,
                top: height * 0.53,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, BalconyPage.routeName);
                  },
                  child: Hero(tag: "giradischi", child: Image.asset('assets/images/piantina.png', width: width * 0.3)),
                ),
              ),
          ],
        );
      },
    );
  }
}
