import 'package:flutter/material.dart';
import 'package:moodmap/reusables/custom_navigation.dart';
import 'package:moodmap/reusables/theme_extension.dart';
import 'package:moodmap/services/theme_service.dart';
import 'package:moodmap/theme_selector.dart';
import 'package:moodmap/auth/auth.dart';

// Intro Screen - Title(App Name) and Subtitle(Tagline)
// Subtitle shall fade as title moves to "top" and decreases in size
// while making way for theme selection
class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  // initial alignment of title
  // not center but vertical -0.12
  // same in value but opposite of subtitle vertical
  // thus they both together as one - center
  Alignment _titleAlignment = const Alignment(0, -0.12);

  bool _subtitlePresent = true;
  double _subtitleOpacity = 1;

  @override
  void initState() {
    super.initState();
    // start animation immediately on load
    _startAnimationAndNavigate();
  }

  void _startAnimationAndNavigate() async {
    // sensible pause for user to read the titles
    await Future.delayed(const Duration(milliseconds: 1500));

    // mounted check: ensures the screen wasn't closed during the delay
    // prevents "setState called after dispose" errors
    if (!mounted) return;
    setState(() {
      _subtitleOpacity = 0; // trigger fade out
    });

    // wait for subtitle to finish fading (300ms) + extra buffer (100ms)
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      // mark false to trigger the font size reduction in AnimatedDefaultTextStyle
      _subtitlePresent = false;
      // move to "top" header position
      _titleAlignment = .topCenter;
    });

    // check if it's the user's first time (theme not set)
    if (!ThemeService.isThemeSet) {
      // wait for title movement (400ms) then move to theme selection
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      navigateFade(context, const ThemeSelector(), durationMs: 300);
    } else {
      // already set? go straight to login
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      navigateFade(context, const Auth(), durationMs: 300);
    }
  }

  @override
  Widget build(BuildContext context) {
    /* title does not cross the status bar or touches it as it reaches "top".
    sits perfectly had we used a AppBar with just title having the same
    text and style and toolBarHeight of 64
    */
    // padding.top is the "notch" or status bar area height
    double topPaddingTitle = MediaQuery.of(context).padding.top + 10;

    // initial title style
    final TextStyle initialTitleStyle = context.textTheme.displayLarge!
        .copyWith(fontFamily: 'Pacifico');
    // final title style
    final TextStyle finallTitleStyle = context.textTheme.displaySmall!.copyWith(
      fontFamily: 'Pacifico',
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // AnimatedAlign: moves children smoothly between two Alignment points
          AnimatedAlign(
            alignment: _titleAlignment,
            curve: Curves.easeOutCirc,
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: .only(top: topPaddingTitle),
              // AnimatedDefaultTextStyle: animates changes in size/color/font
              child: AnimatedDefaultTextStyle(
                curve: Curves.easeOutCirc,
                duration: const Duration(milliseconds: 400),
                style: _subtitlePresent ? initialTitleStyle : finallTitleStyle,
                child: const Text('MoodMap'),
              ),
            ),
          ),

          // tagline positioning
          Align(
            // fixed at 0.12 to mirror the title's starting -0.12
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
