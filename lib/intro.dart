import 'package:flutter/material.dart';
import 'package:moodmap/reusables/theme_extension.dart';
import 'package:moodmap/theme_selector.dart';

// Intro Screen - Title(App Name) and Subtitle(Tagline)
// Subtitle shall fade as title moves to "top" and decreases in size
// while making way for theme selection
class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  // intital alignment of title
  // not center but vertical -0.12
  // same in value but opposite of subtitle vertical
  // thus they both together as one - center
  Alignment _titleAlignment = Alignment(0, -0.12);

  bool _subtitlePresent = true;
  double _subtitleOpacity = 1;

  double _themeSelectorOpacity = 0;

  @override
  void initState() {
    super.initState();
    // start animation
    _startAnimationAndNavigate();
  }

  void _startAnimationAndNavigate() async {
    // sensible pause for titles
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() {
      _subtitleOpacity = 0; // fade out subtitle
    });

    // wait subtitle to fade(300ms) + extra minimal buffer(25ms)
    await Future.delayed(const Duration(milliseconds: 325));

    if (!mounted) return;
    setState(() {
      // mark false after subtitle fades out
      // also trigger title font reducing
      _subtitlePresent = false;
      // move to "top"
      _titleAlignment = .topCenter;
    });

    // title moves in 250ms and themeselctor loads after wating 175ms
    await Future.delayed(const Duration(milliseconds: 175));

    if (!mounted) return;
    setState(() {
      _themeSelectorOpacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* 
    title does not cross the status bar or touches it as it reaches "top".
    sits perfectly had we used a AppBar with just title having the same
    text and style and toolBarHeight of 64
    */
    double topPaddingTitle = MediaQuery.of(context).padding.top + 10;

    // intial title style
    final TextStyle initialTitleStyle = context.textTheme.displayLarge!
        .copyWith(fontFamily: 'Pacifico');
    // final title style
    final TextStyle finallTitleStyle = context.textTheme.displaySmall!.copyWith(
      fontFamily: 'Pacifico',
    );

    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _themeSelectorOpacity,
            duration: const Duration(milliseconds: 300),
            child: themeSelect(context),
          ),

          AnimatedAlign(
            alignment: _titleAlignment,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 250),
            child: Padding(
              padding: EdgeInsets.only(top: topPaddingTitle),
              child: AnimatedDefaultTextStyle(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 250),
                style: _subtitlePresent ? initialTitleStyle : finallTitleStyle,
                child: const Text('MoodMap'),
              ),
            ),
          ),

          Align(
            // not center but vertical 0.12
            // same in value but opposite of title vertical
            alignment: const Alignment(0, 0.12),
            child: AnimatedOpacity(
              opacity: _subtitleOpacity,
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Every mood, every feeling, mapped',
                style: context.textTheme.labelLarge,
                textAlign: .center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
