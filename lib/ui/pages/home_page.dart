import 'package:flutter/material.dart';
import 'package:incisive/ui/pages/diary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  double _currentPage = 0.0;
  int currentIndex = 0;
  bool _isAnimating = false;

  final List<String> _images = ['assets/images/bedroom_unity.png', 'assets/images/living_unity.png', 'assets/images/garden_unity.png'];

  Widget _buildFloatingBar() {
    return Positioned(
      bottom: 5,
      left: 30,
      right: 30,
      child: SafeArea(
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color.fromARGB(128, 218, 193, 150),

            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.bed, 0),
              _navItem(Icons.chair, 1),
              _navItem(Icons.grass_sharp, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        _isAnimating = true;

        setState(() {
          currentIndex = index;
        });

        _controller
            .animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            )
            .then((_) {
              _isAnimating = false;
            });
      },

      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 141, 90, 35) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.white : Colors.white,
        ),
      ),
    );
  }

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
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (index) {
              if (_isAnimating) return;

              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) => StanzaWidget(imagePath: _images[index], stanzaIndex: index),
          ),
          SafeArea(
            child: Container(
              alignment: Alignment.center,
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
          ),
          IgnorePointer(child: Container(color: Colors.black.withOpacity(_calculateOverlayOpacity()))),
          _buildFloatingBar(),
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
                left: width * 0.1,
                top: height * 0.503,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DiaryPage.routeName);
                  },
                  child: Hero(
                    tag: "diary",
                    transitionOnUserGestures: true,
                    child: Image.asset('assets/images/diary.png', width: width * 0.12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
