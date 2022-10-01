import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:password_generator/screens/show_password_screen.dart';
import 'package:password_generator/widgets/custom_button.dart';
import 'package:password_generator/widgets/custom_card.dart';
import 'dart:math' as math;

const uCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const lCase = "abcdefghijklmnopqrstuvwxyz";
const numbers = "0123456789";
const symbols = "!@#\$%^&*=-_";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  int passwordLength = 4;
  int minimumPasswordLength = 4;
  int maximumPasswordLength = 32;
  Map<String, bool> passwordOptionsInfo = {
    'uppercase': false,
    'lowercase': false,
    'numbers': false,
    'symbols': false,
  };
  final List<String> passwordOptionButtonsText = [
    'Uppercase',
    'Lowercase',
    'Numbers',
    'Symbols'
  ];

  bool isGeneratePasswordButtonClicked = false;

  Iterable<Widget> passwordOptionButtons = [];

  @override
  void initState() {
    super.initState();
    passwordOptionButtons =
        passwordOptionButtonsText.map((optionText) => CustomButton(
            text: optionText,
            isSelected: passwordOptionsInfo[optionText.toLowerCase()]!,
            onPressed: () {
              setState(() {
                passwordOptionsInfo[optionText.toLowerCase()] =
                    !passwordOptionsInfo[optionText.toLowerCase()]!;
              });
              playAudio();
            }));
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

  String generatePassword() {
    String allOptionsString = '';
    String password = '';
    if (passwordOptionsInfo['lowercase']!) {
      allOptionsString += lCase;
    }
    if (passwordOptionsInfo['uppercase']!) {
      allOptionsString += uCase;
    }
    if (passwordOptionsInfo['numbers']!) {
      allOptionsString += numbers;
    }
    if (passwordOptionsInfo['symbols']!) {
      allOptionsString += symbols;
    }
    for (int i = 0; i < passwordLength; i++) {
      int randomNumber = math.Random().nextInt(allOptionsString.length);
      password += allOptionsString[randomNumber];
    }
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  'Password Length',
                  style: TextStyle(color: Color(0xFFC7C7C7), fontSize: 18),
                ),
                SizedBox(
                  height: 9,
                ),
                CustomCard(
                  child: Column(
                    children: [
                      Text(
                        '$passwordLength',
                        style:
                            TextStyle(color: Color(0xFFC7C7C7), fontSize: 18),
                      ),
                      Slider(
                        min: minimumPasswordLength.toDouble(),
                        max: maximumPasswordLength.toDouble(),
                        value: passwordLength.toDouble(),
                        onChanged: (newValue) {
                          setState(() {
                            passwordLength = newValue.toInt();
                          });
                        },
                        thumbColor: const Color(0xFFC7C7C7),
                        activeColor: const Color(0xFFC7C7C7),
                        inactiveColor: Colors.white24.withOpacity(0.15),
                      ),
                    ],
                  ),
                ),
                Text('Password Includes',
                    style: TextStyle(
                      color: Color(0xFFC7C7C7),
                      fontSize: 18,
                    )),
                SizedBox(
                  height: 9,
                ),
                CustomCard(
                    child: Column(
                  children: passwordOptionButtons.toList(),
                )),
                CustomButton(
                    text: 'Generate Password',
                    isSelected: isGeneratePasswordButtonClicked,
                    onPressed: () {
                      setState(() {
                        isGeneratePasswordButtonClicked = true;
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          isGeneratePasswordButtonClicked = false;
                        });
                      });
                      playAudio();
                      if (passwordOptionsInfo['lowercase']! ||
                          passwordOptionsInfo['uppercase']! ||
                          passwordOptionsInfo['numbers']! ||
                          passwordOptionsInfo['symbols']!) {
                        String generatedPassword = generatePassword();
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) => ShowPasswordScreen(
                                password: generatedPassword)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                'you must select at least one password include options!',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3)),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
