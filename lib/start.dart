import 'package:flutter/material.dart';
import 'package:moodmap/reusables/theme_extension.dart';
import 'package:moodmap/services/theme_service.dart';
import 'package:moodmap/theme_selector.dart';
import 'package:moodmap/auth/auth.dart';

// Start Screen - Title(App Name) and Subtitle(Tagline)
// Subtitle shall fade as title moves to "top" and decreases in size
// while making way for theme selection or Auth
class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  // initial alignment of title
  // not center but vertical -0.12
  // same in value but opposite of subtitle vertical
  // thus they both together as one - center
  Alignment _titleAlignment = const Alignment(0, -0.12);

  bool _subtitlePresent = true;
  double _subtitleOpacity = 1;

  // controls visibility of theme selector
  double _themeSelectorOpacity = 0;

  // controls visibility of auth content
  double _authContentOpacity = 0;

  // offsets for slide up animation
  Offset _themeSelectorOffset = Offset.zero; // default theme selector centered
  // default auth content starts off-screen
  Offset _authContentOffset = const Offset(0, 1);

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
      // wait for title movement (500ms) but load theme selectior after 250ms
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _themeSelectorOpacity = 1;
        _authContentOpacity = 1;
      });
    } else {
      setState(() {
        _authContentOffset = Offset.zero;
      });
      // wait for title movement (500ms) but load auth conten after 250ms
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _authContentOpacity = 1;
      });
    }
  }

  // triggered when "Continue" is pressed in ThemeSelector
  void _slideUpThemeToAuth() {
    setState(() {
      // fade out and slide theme selector up
      _themeSelectorOpacity = 0;
      _themeSelectorOffset = const Offset(0, -1.5);
      // Slide auth content up and in
      _authContentOffset = Offset.zero;
    });
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
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: .only(top: topPaddingTitle),
              // AnimatedDefaultTextStyle: animates changes in size/color/font
              child: AnimatedDefaultTextStyle(
                curve: Curves.easeOutCirc,
                duration: const Duration(milliseconds: 500),
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

          AnimatedSlide(
            offset: _themeSelectorOffset,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
            child: AnimatedOpacity(
              opacity: _themeSelectorOpacity,
              duration: !ThemeService.isThemeSet
                  // fade in duration
                  ? const Duration(milliseconds: 300)
                  // fade out duration as it slides up
                  : const Duration(milliseconds: 200),
              child: IgnorePointer(
                // ignore touches if opacity is 0 OR if it has slid up
                ignoring:
                    _themeSelectorOpacity != 1 || _themeSelectorOffset.dy != 0,
                child: themeSelector(context, onContinue: _slideUpThemeToAuth),
              ),
            ),
          ),

          AnimatedSlide(
            offset: _authContentOffset,
            curve: Curves.easeInOutCubic,
            duration: !ThemeService.isThemeSet
                // slide up duration as theme selector slides up
                ? const Duration(milliseconds: 500)
                // no slide duration if theme selector not shown
                : const Duration(milliseconds: 0),
            child: AnimatedOpacity(
              opacity: _authContentOpacity,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                // Ignore tocuhes if opacity is 0 OR if it hasn't slid in yet
                ignoring:
                    _authContentOpacity != 1 || _authContentOffset.dy != 0,
                child: const Auth(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
