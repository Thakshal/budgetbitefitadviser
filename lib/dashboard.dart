// dashboard.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'profile.dart'; // Import the profile screen

// class DashboardScreen extends StatelessWidget {
//   final String userId;

//   DashboardScreen({required this.userId});

//   Future<String> getUsername() async {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     return userDoc['username'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//       ),
//       body: FutureBuilder<String>(
//         future: getUsername(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error fetching username'));
//           }
//           String username = snapshot.data ?? 'User';
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
                      // MaterialPageRoute(builder: (context) => ProfileScreen(userId: userId)),
                //     );
                //   },
                //   child: Text(
                //     'Welcome, $username',
                //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Text(
                //   'Meal Plan',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                // Display meal plan details here
                // Expanded(
                //   child: ListView(
                //     children: [
                //       ListTile(
                //         title: Text('Breakfast'),
                //         subtitle: Text('Oatmeal with fruits'),
                //       ),
                //       ListTile(
                //         title: Text('Lunch'),
                //         subtitle: Text('Grilled chicken salad'),
                //       ),
                //       ListTile(
                //         title: Text('Dinner'),
                //         subtitle: Text('Steamed vegetables and fish'),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Text(
                //   'Fitness Schedule',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                // Display fitness schedule details here
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       ListTile(
//                         title: Text('Monday'),
//                         subtitle: Text('Cardio and Abs'),
//                       ),
//                       ListTile(
//                         title: Text('Wednesday'),
//                         subtitle: Text('Upper Body Strength'),
//                       ),
//                       ListTile(
//                         title: Text('Friday'),
//                         subtitle: Text('Lower Body Strength'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
