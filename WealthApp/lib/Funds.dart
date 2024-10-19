import 'dart:convert';
import 'dart:ffi';

import 'package:wealth_app/Profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wealth_app/globals.dart';
import 'package:wealth_app/FundInfoPage.dart';
import 'package:wealth_app/StartSIP.dart';

void main() {
  runApp(const Wealth2());
}

class Wealth2 extends StatefulWidget {
  const Wealth2({super.key});

  @override
  _Wealth2State createState() => _Wealth2State();
}


class _Wealth2State extends State<Wealth2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Funds(),
    );
  }
}


class Funds extends StatefulWidget {
  @override
  _FundsState createState() => _FundsState();
}

class _FundsState extends State<Funds> {
  double funds = basicbalance;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Row(
          children: [
            // Shifting the Image upwards
            Transform.translate(
              offset: Offset(0, -10), // Moves the image 10 pixels upwards
              child: const Image(
                image: AssetImage('lib/icons/w#logo 2.png'),
                height: 150,
                width: 150,
                alignment: Alignment.centerLeft,
              ),
            ),

            const SizedBox(width: 80),

            // Shifting the CircleAvatar upwards
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => UserProfile()),  // Replace with your target screen
                  );
                },
                child : Row(
                  children: [
                    Transform.translate(offset: const Offset(60, -4),
                      child: Container(
                        width: 50,
                        height: 50,
                        child : Image(image: AssetImage('lib/icons/Badges/diamond.png')),),),
                    // Shifting the CircleAvatar upwards and adding the initial letter fallback
                    Transform.translate(
                      offset: const Offset(70, -4),  // Moves the avatar 4 pixels upwards
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('lib/icons/user_img.png'),  // Image for avatar
                        child: Text(
                          'Y',  // Replace 'Y' with the initial of the username
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                )

            )
          ],

        ),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: FractionallySizedBox(
        heightFactor: 0.10,
        child: BottomNavigationBar(
          backgroundColor: Colors.green[100],
          selectedItemColor: Colors.green,
          selectedIconTheme: const IconThemeData(
            size: 35,
          ),
          selectedFontSize: 20,

          showUnselectedLabels: false,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.graduationCap),
              label:"Learn",

            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.handHoldingDollar),
              label:"Invest",

            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.briefcase),
              label:"Portfolio",

            ),
          ],


        ),
      ),
      body: SingleChildScrollView( // Added scrollable view
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Funds',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                // Remove fixed height or reduce it
                // height: 200,
                width: MediaQuery.of(context).size.width - 32, // Responsive width
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(16), // Rounded edges
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                  children: [
                    Text(
                      'Available Funds:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(// Add spacing
                    child : Text(

                      '\u20B9${funds.toStringAsFixed(2)}', // Placeholder for funds value
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),),
                    const SizedBox(height: 40), // Add spacing before buttons

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}