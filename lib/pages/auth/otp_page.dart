import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/auth_container.dart';
import 'package:quiz_app/components/otp_input_component.dart';
import 'package:quiz_app/notifiers/auth/register_notifier.dart';
import 'package:quiz_app/utils/format_time.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  static final maxSeconds = 15 * 60;

  final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  int seconds = maxSeconds;
  Timer? timer;
  bool canResendOTP = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;

          // if the remaining time is 5 minutes or less
          // enable resend OTP
          if (seconds <= 5 * 60) {
            canResendOTP = true;
          }
        });
      } else {
        timer?.cancel();
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      seconds = maxSeconds;
      canResendOTP = false;
    });
  }

  void restartTimer() async {
    bool result = await ref.read(registerProvider.notifier).resendOtp();

    if (result == true) {
      resetTimer();
      startTimer();
    }
  }

  Future<bool> onSubmitOtpCode() async {
    var otpCode = '';

    for (var controller in controllers) {
      otpCode += controller.text;
    }

    return await ref.read(registerProvider.notifier).checkOtp(otpCode);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(registerProvider);

    return Scaffold(
      backgroundColor: colors.primary,
      body: AuthContainer(
        title: "OTP",
        child: Column(
          children: [
            Text(
              'Email telah dikirimkan ke email ${state.user!.email}',
              style: TextStyle(
                fontSize: 17
              ),  
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...controllers.asMap().entries.map((c) {
                  var controller = c.value;
                  var index = c.key;

                  return OtpInputComponent(
                    controller: controller,
                    focusNode: focusNodes[index],
                    autoFocus: index < 1,
                    onChange: (value) async {
                      if (value.length == 1) {
                        if (index < 3) {
                          focusNodes[index + 1].requestFocus();
                        } else {
                          focusNodes[index].unfocus();
                                    
                          final result = await onSubmitOtpCode();

                          if (result == true && context.mounted) {
                            context.go("/login");
                          }
                        }
                      }
                    },
                    onPrevious: () {
                      if (index > 0) {
                        focusNodes[index - 1].requestFocus();
                        controllers[index - 1].text = '';
                      }
                    },
                  );
                })
                ,
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Kode OTP akan berakhir pada:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            Text(
              formatTime(seconds),
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () async {
                var result = await context.push("/change-email");

                if (result != null && result == true) {
                  resetTimer();
                  startTimer();
                }
              },
              child: Text(
                "Ganti email",
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 16
                ),
              ),
            ),
            SizedBox(height: 25),
            if (canResendOTP)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum menerima kode OTP? '),
                  GestureDetector(
                    onTap: () {
                      restartTimer();
                    },
                    child: Text(
                      'Kirim ulang.',
                      style: TextStyle(
                        color: Colors.blue
                      ),
                    ),
                  )
                ],
              ),
            // authController.isLoadingVerifyAccount.value
            //   ? CircularProgressIndicator(color: Colors.blue)
            //   : SizedBox()
          ],
        )
      ),
    );
  }
}