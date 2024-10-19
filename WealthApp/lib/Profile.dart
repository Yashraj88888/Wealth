import 'package:wealth/globals.dart';
import 'package:wealth/Invest.dart';
import 'package:wealth/Learn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wealth/user_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OurNavigationBar(),
    );
  }
}

class OurNavigationBar extends StatefulWidget {
  const OurNavigationBar({super.key});

  @override
  State<OurNavigationBar> createState() => _OurNavigationBarState();
}

class _OurNavigationBarState extends State<OurNavigationBar> {
  int current_index = 2;
  String str = "Profile";

  void travel(int val) {
    setState(() {
      current_index = val;
    });
    switch (current_index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Learn()));
        break;

      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Invest()));
        break;

      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Logo Image
            Image.asset(
              'lib/icons/wealth.png',
              height: 50,
            ),
            IconButton(
              icon: Icon(Icons.account_circle, size: 30),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile()));

              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icons/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Profile_body(),
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
          currentIndex: current_index,
          onTap: travel,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.graduationCap),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.handHoldingDollar),
              label: "Invest",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.briefcase),
              label: "Portfolio",
            ),
          ],
        ),
      ),
    );
  }
}

class Profile_body extends StatefulWidget {
  const Profile_body({super.key});

  @override
  State<Profile_body> createState() => _Profile_bodyState();
}

class _Profile_bodyState extends State<Profile_body> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("PORTFOLIO", 35),
            _buildInvestmentInfo(),
            _buildSectionTitle("HOLDINGS", 35),
            _buildHoldingsSection("SIP HOLDINGS", 'sip_holdings'),
            _buildHoldingsSection("ONE-TIME HOLDINGS", 'one_time_holdings'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double fontSize) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'fonts/DegularDisplay-BoldItalic.otf',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.green[800],
      ),
    );
  }

  Widget _buildInvestmentInfo() {
    return Container(
      height: 374,
      width: 374,
      decoration: BoxDecoration(
        color: Colors.green[100],
      ),
      child: Column(
        children: [
          const Text('INVESTMENTS'),
          Text("\u20B9$current_investment_price"),
        ],
      ),
    );
  }

  Widget _buildHoldingsSection(String title, String holdingsType) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title, 25),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No data found.'));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              List<dynamic> holdings = userData[holdingsType] ?? [];

              if (holdings.isEmpty) {
                return const Center(child: Text('No holdings found.'));
              }

              return _buildHoldingsList(holdings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingsList(List<dynamic> holdings) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: holdings.length,
      itemBuilder: (context, index) {
        var holding = holdings[index];

        // Check if scheme_no is null and handle it
        var schemeNo = holding['scheme_code'] ?? 'Not Available';

        // Convert Firestore Timestamp to DateTime if it exists
        var startDate = holding['start_date'] is Timestamp
            ? (holding['start_date'] as Timestamp).toDate()
            : null;

        var sipAmount = holding['amount'] ?? 'Not Available';
        var sipname = holding['scheme_name'] ?? 'Not Available';

        return Card(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Scheme No: $schemeNo",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Scheme Name: $sipname",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (startDate != null)
                  Text("Start Date: ${startDate.toLocal()}"),
                if (holding.containsKey('sip_amount'))
                  Text("SIP Amount: ₹$sipAmount"),
              ],
            ),
          ),
        );
      },
    );
  }

}



