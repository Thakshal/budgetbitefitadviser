import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import the login file

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  double bmiResult = 0.0;
  String bmiCategory = '';
  User? user;
  int? selectedAge;
  String? username;
  String? selectedGender;
  List<String> genders = ['Male', 'Female'];
  List<String> fractures = [
    'No fractures',
    'Knee pain',
    'Shoulder injury or shoulder pain',
    'Elbow or wrist pain',
    'Back / Lower back injury or pain'
  ];
  String? selectedFracture = 'No fractures';
  List<String> timeRanges = ['Per hour', 'Two hours'];
  String? selectedTimeRange;
  List<String> budgetRanges = [
    'LKR 0 - 5000',
    'LKR 5000 - 15000',
    'LKR 15000 and above'
  ];
  String? selectedBudget;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUserData();
  }

  void fetchUserData() async {
    if (user != null) {
      print('User UID: ${user!.uid}'); // Add this line
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        setState(() {
          username = userDoc['username']; // Update username here
          selectedGender = userDoc['gender'];
          selectedAge = userDoc['age'];
          selectedFracture = userDoc['fracture'];
          selectedTimeRange = userDoc['timeRange'];
          selectedBudget = userDoc['budget'];
          heightController.text =
              userDoc['height'] != null ? userDoc['height'].toString() : '';
          weightController.text =
              userDoc['weight'] != null ? userDoc['weight'].toString() : '';
        });
      } catch (e) {
        print('Error fetching user data: $e');
        // Handle error as needed
      }
    } else {
      print('User is null'); // Add this line
    }
  }

  void calculateBMI() {
    double height =
        double.parse(heightController.text) / 100; // convert height to meters
    double weight = double.parse(weightController.text);
    double heightSquared = height * height;
    double bmi = weight / heightSquared;

    setState(() {
      bmiResult = bmi;
      bmiCategory = getBMICategory(bmi);
    });

    // Save all data to Firestore
    saveDataToFirestore();
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  void saveDataToFirestore() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(user!.uid).set({
        'username': username, // Update username here
        'email': user!.email,
        'bmi': bmiResult,
        'bmiCategory': bmiCategory, // Save BMI category
        'age': selectedAge,
        'gender': selectedGender,
        'fracture': selectedFracture,
        'budget': selectedBudget,
        'timeRange': selectedTimeRange,
        'height': heightController.text,
        'weight': weightController.text,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge with existing data
      print('Data saved to Firestore');
    } catch (e) {
      print('Failed to save data: $e');
      // Handle error as needed
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(username ?? ''),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                child: Image.asset(
                  'lib/assets/logo1.png', // Update with your logo image
                  height: 150,
                ),
              ),
            ),
            ListTile(
              title: Text('Meal Plan'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Fitness Schedule'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              _buildInfoCard('Name', username ?? ''),
              _buildInfoCard('Email', user?.email ?? ''),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: selectedAge,
                items: List.generate(83, (index) => index + 18).map((int age) {
                  return DropdownMenuItem<int>(
                    value: age,
                    child: Text('$age'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedAge = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Calculate BMI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (heightController.text.isNotEmpty &&
                      weightController.text.isNotEmpty) {
                    calculateBMI();
                  }
                },
                child: Text('Calculate'),
              ),
              SizedBox(height: 10),
              Text(
                'Your BMI: ${bmiResult.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Category: $bmiCategory',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Fracture',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedFracture,
                items: fractures.map((String fracture) {
                  return DropdownMenuItem<String>(
                    value: fracture,
                    child: Text(fracture),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFracture = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Fracture',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedBudget,
                items: budgetRanges.map((String budget) {
                  return DropdownMenuItem<String>(
                    value: budget,
                    child: Text(budget),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBudget = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Expected Budget per month (LKR)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedTimeRange,
                items: timeRanges.map((String timeRange) {
                  return DropdownMenuItem<String>(
                    value: timeRange,
                    child: Text(timeRange),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeRange = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Timing for per day',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveDataToFirestore();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
