import 'dart:ui';
import 'package:englishcoach/config/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/responsive.dart';

class Congrats extends StatefulWidget {
  static const routename = '/congratscreen';
  @override
  _CongratsState createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = data['userId'];
    final modId = data['mod'];
    final totalMark = data['total'];
    final topic = data['topic'];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: totalMark >= 80
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/images/confitte.json',
                        height: Responsive.isDesktop(context) ||
                                Responsive.isTablet(context)
                            ? 300
                            : null,
                      ),
                      Text(
                        'Congratulations ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        child: topic
                            ? Text(
                                'താങ്കൾ ഈ ടോപ്പിക്ക് ടെസ്റ്റ് പാസായിരിക്കുന്നു.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                'താങ്കൾ ഈ മോഡ്യൂളിലെ ടെസ്റ്റ് പാസായിരിക്കുന്നു.\n\n\nഈ മോഡ്യൂളിലെ വീഡിയോ കണ്ട് കൂടുതൽ വിവരങ്ങൾ മനസ്സിലാക്കൂ.\n\n\nഒപ്പം വൊകാബുലറി എക്സർസൈസ് ചെയ്ത് നിങ്ങളുടെ ഇംഗ്ലീഷ് പരിജ്ഞാനം വർധിപ്പിക്കൂ.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentcolor,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/images/4970-unapproved-cross.json',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Test Failed \n Please Try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentcolor,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
