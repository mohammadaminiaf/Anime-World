import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/common/widgets/loading_dialog.dart';
import 'screen_login.dart';
import 'screen_register.dart';

class ScreenAuthentication extends StatelessWidget {
  const ScreenAuthentication({super.key});

  static const route = '/authentication-screen';

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer(builder: (context, ref, child) {
    // Listen to your provider here
    // final error = ref.watch(authErrorProvider);
    // final isLoading =
    //     ref.watch(authNotifierProvider.select((state) => state.isLoading));

    // if (error != null && error.isNotEmpty) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: const Text("Error"),
    //         content: Text(error),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               ref.read(authNotifierProvider.notifier).clearError();
    //             },
    //             child: const Text("OK"),
    //           ),
    //         ],
    //       ),
    //     );
    //   });
    // } else if (isLoading) {
    //   _showLoadingIndicator(context);
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push(ScreenLogin.routeName);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push(ScreenRegister.routeName);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
