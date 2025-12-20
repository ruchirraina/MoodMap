import 'package:flutter/material.dart';
import 'package:moodmap/reusables/custom_navigation.dart';
import 'package:moodmap/reusables/theme_extension.dart';

class Auth extends StatefulWidget {
  final bool atLogin;
  const Auth({this.atLogin = true, super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // focusnode tracks if the textfield is active/clicked
  // needed to show the eye icon only when the user is actually typing
  late final FocusNode _passwordFocusNode;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();

    // addListener runs every time focus changes (click in/out)
    // we call setState to refresh the UI and show/hide the eye icon
    _passwordFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    // dispose clears the node from system memory
    // nodes are "heavy" objects; if not closed, they cause memory leaks
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // viewInsets.bottom tells us how many pixels the keyboard takes up
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // alignment uses coordinates where 0 is center and -1 is top
    // we move to -0.7 to "tuck" the form under the header when typing
    final Alignment mainTileAlignment = isKeyboardVisible
        ? const Alignment(0, -0.7)
        : .center;

    return Scaffold(
      // prevents scaffold from automatically squishing the layout
      // allows our AnimatedAlign to handle the movement smoothly instead
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "MoodMap",
          style: context.textTheme.displaySmall!.copyWith(
            fontFamily: 'Pacifico',
          ),
        ),
        toolbarHeight: 64,
      ),
      body: SafeArea(
        child: GestureDetector(
          // unfocus() removes focus from fields and hides keyboard
          // .opaque ensures the tap works even on empty background space
          onTap: FocusScope.of(context).unfocus,
          behavior: .opaque,
          child: Stack(
            children: [
              // easeOutCirc: starts with a burst of speed then snaps into place
              // provides a very responsive, high-end feel for UI transitions
              AnimatedAlign(
                alignment: mainTileAlignment,
                curve: Curves.easeOutCirc,
                duration: const Duration(milliseconds: 250),
                child: Padding(
                  padding: const .symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Text(
                          widget.atLogin
                              ? 'Welcome Back!'
                              : 'Welcome to MoodMap!',
                          style: context.textTheme.titleLarge!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          keyboardType: .emailAddress,
                          style: context.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            border: OutlineInputBorder(
                              borderRadius: .circular(12),
                            ),
                            prefixIcon: const Icon(Icons.mail),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          focusNode: _passwordFocusNode,
                          // only show dots if the field is active
                          obscureText: _passwordFocusNode.hasFocus
                              ? _obscurePassword
                              : true,
                          style: context.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            border: OutlineInputBorder(
                              borderRadius: .circular(12),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            // suffixIcon appears only when the user clicks the field
                            suffixIcon: _passwordFocusNode.hasFocus
                                ? IconButton(
                                    onPressed: () => setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    }),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  )
                                : null,
                          ),
                        ),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: widget.atLogin
                              ? Align(
                                  alignment: .centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: context.textTheme.labelMedium!
                                          .copyWith(
                                            color: context.colorScheme.tertiary,
                                          ),
                                    ),
                                  ),
                                )
                              : const SizedBox(height: 28),
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {},
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: widget.atLogin
                                  ? Text(
                                      'Log In',
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(
                                            color:
                                                context.colorScheme.onPrimary,
                                          ),
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(
                                            color:
                                                context.colorScheme.onPrimary,
                                          ),
                                    ),
                            ),
                          ),
                        ),

                        // AnimatedOpacity fades the widget out but keeps its space
                        // this prevents the rest of the column from jumping/jittering
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isKeyboardVisible ? 0 : 1,
                          curve: Curves.easeOut,
                          child: IgnorePointer(
                            // IgnorePointer stops clicks on the button when it's invisible
                            ignoring: isKeyboardVisible,
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: _switchAuthMode,
                                  style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: Text(
                                    widget.atLogin
                                        ? 'New User? Sign Up'
                                        : 'Already Signed Up? Log In',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Positioned(bottom: 0) anchors this to the physical bottom of screen
              // stays put because we disabled resizeToAvoidBottomInset
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const .only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    children: [
                      Text(
                        'Or continue with',
                        style: context.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Wrap(
                            spacing: 8,
                            crossAxisAlignment: .center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              Text(
                                'Google',
                                style: context.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _switchAuthMode() {
    if (!mounted) return;
    navigateFade(context, Auth(atLogin: !widget.atLogin));
  }
}
