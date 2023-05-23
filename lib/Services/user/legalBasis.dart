import 'package:flutter/material.dart';

class LegalBasis extends StatefulWidget {
  const LegalBasis({super.key});

  @override
  State<LegalBasis> createState() => _LegalBasisState();
}

class _LegalBasisState extends State<LegalBasis> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text(
            'Terms of Service',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height *
                        0.03), // adds 16 pixels of left indentation
                child: Text(
                  'Ardu-Illuminate - is a software application that allows users to control smart light bulbs, with different features provided. The App is owned and operated by Computer Science students in University of Cebu. By downloading and using the App, you agree to these terms and conditions. Please read these Terms carefully before using the App. If you do not agree to these Terms, do not use the App.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                '2. License to Use the App',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  'The Company grants you a limited, non-exclusive, non-transferable license to download, install, and use the App on your personal mobile device solely for your own personal, non-commercial use. You may not reproduce, distribute, modify, or create derivative works based on the App.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                '3. User Account',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  'In order to use certain features of the App, you may be required to create a user account. You agree to provide accurate and complete information when creating your account and to update your information as necessary. You are solely responsible for maintaining the confidentiality of your account information and for any activity that occurs under your account.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                '4. Smart Light Bulbs',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  'The App is designed to work with certain smart light bulbs. The Company makes no guarantee that the App will work with all smart light bulbs or that it will work perfectly with any specific smart light bulb. The Company is not responsible for any damage or malfunction that may occur to your smart light bulbs as a result of using the App.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                '5. Privacy Policy',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  "The Company's privacy policy governs the collection, use, and storage of your personal information. By using the App, you agree to the terms of the Company's privacy policy.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.09,
          ),
          child: Container(
            color: Color(0xFFf59e0b),
            child: BottomAppBar(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFD30000),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.02), // add some spacing between the text and icon
                        Icon(
                          Icons.close,
                          color: Color(0XFFD30000),
                          size: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Text(
                          'Accept',
                          style: TextStyle(
                            color: const Color(0xFF0047FF),
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Icon(
                          Icons.check,
                          color: const Color(0xFF0047FF),
                          size: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
