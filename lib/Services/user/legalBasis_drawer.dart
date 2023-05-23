import 'package:ardu_illuminate/Screens/homePage.dart';
import 'package:flutter/material.dart';

class LegalBasisDrawer extends StatefulWidget {
  const LegalBasisDrawer({super.key});

  @override
  State<LegalBasisDrawer> createState() => _LegalBasisDrawerState();
}

class _LegalBasisDrawerState extends State<LegalBasisDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Terms of Service',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: MediaQuery.of(context).size.width * 0.05,
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
          height: MediaQuery.of(context).size.height * 0.09,
          color: Colors
              .transparent, // Set the color of the bottom navigation bar to transparent
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 0, 71, 255),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    children: [
                      Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.04,
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
}
