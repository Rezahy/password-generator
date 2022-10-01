import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:password_generator/widgets/custom_button.dart';
import 'package:password_generator/widgets/custom_card.dart';
import 'package:clipboard/clipboard.dart';

class ShowPasswordScreen extends StatefulWidget {
  const ShowPasswordScreen({Key? key, required this.password})
      : super(key: key);
  final String password;

  @override
  State<ShowPasswordScreen> createState() => _ShowPasswordScreenState();
}

class _ShowPasswordScreenState extends State<ShowPasswordScreen> {
  final player = AudioPlayer();
  bool isCopyButtonClicked = false;
  void copyToClipboard(BuildContext context) async {
    await FlutterClipboard.copy(widget.password);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        content: Text(
          'copied to clipboard',
        ),
      ),
    );
  }

  Future playAudio() async {
    try {
      await player.setAsset(
        'assets/sounds/pressed-7.mp3',
      );
      await player.setVolume(0.3);
      await player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
          child: Column(
            children: [
              CustomCard(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Text(widget.password,
                      style: TextStyle(color: Color(0xFFC7C7C7), fontSize: 20)),
                ),
              ),
              CustomButton(
                  text: 'Copy',
                  isSelected: isCopyButtonClicked,
                  onPressed: () {
                    print(widget.password.length);
                    playAudio();
                    setState(() {
                      isCopyButtonClicked = true;
                    });
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        isCopyButtonClicked = false;
                      });
                    });
                    copyToClipboard(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
