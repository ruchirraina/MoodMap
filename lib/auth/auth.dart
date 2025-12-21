import 'package:flutter/material.dart';
import 'package:moodmap/reusables/theme_extension.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // Internal state to toggle between Login and Signup
  bool _atLogin = true;

  late final FocusNode _passwordFocusNode;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      _atLogin = !_atLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detect keyboard visibility
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Alignment logic:
    // When keyboard is open, push up slightly (-0.5) to stay visible
    // but not so high that it hits the 'MoodMap' header.
    final Alignment mainTileAlignment = isKeyboardVisible
        ? const Alignment(0, -0.5)
        : Alignment.center;

    return SafeArea(
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // 1. Main Form Card
            AnimatedAlign(
              alignment: mainTileAlignment,
              curve: Curves.easeOutCirc,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  // clamp physics prevents scrolling unless absolutely necessary
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dynamic Welcome Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        child: Text(
                          _atLogin ? 'Welcome Back!' : 'Welcome to MoodMap!',
                          key: ValueKey<bool>(
                            _atLogin,
                          ), // ensures animation triggers
                          style: context.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: context.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          floatingLabelStyle: context.textTheme.bodyMedium!
                              .copyWith(color: context.colorScheme.primary),
                          errorStyle: context.textTheme.labelSmall!.copyWith(
                            color: context.colorScheme.error,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.mail),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        focusNode: _passwordFocusNode,
                        obscureText: _passwordFocusNode.hasFocus
                            ? _obscurePassword
                            : true,
                        style: context.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          labelStyle: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          floatingLabelStyle: context.textTheme.bodyMedium!
                              .copyWith(color: context.colorScheme.primary),
                          errorStyle: context.textTheme.labelSmall!.copyWith(
                            color: context.colorScheme.error,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
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

                      // Forgot Password (only for Login)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _atLogin
                            ? Align(
                                alignment: Alignment.centerRight,
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

                      // Action Button (Log In / Sign Up)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 100),
                            child: Text(
                              _atLogin ? 'Log In' : 'Sign Up',
                              key: ValueKey<bool>(_atLogin),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Switch Mode Link
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isKeyboardVisible ? 0 : 1,
                        child: IgnorePointer(
                          ignoring: isKeyboardVisible,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _switchAuthMode,
                                style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 100),
                                  child: Text(
                                    _atLogin
                                        ? 'New User? Sign Up'
                                        : 'Already Signed Up? Log In',
                                    key: ValueKey<bool>(_atLogin),
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
            ),

            // 2. Google / Social Login (Bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                // Hide completely when keyboard is up to save space
                opacity: isKeyboardVisible ? 0 : 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
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
                            crossAxisAlignment: WrapCrossAlignment.center,
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
            ),
          ],
        ),
      ),
    );
  }
}
