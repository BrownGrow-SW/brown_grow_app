import 'package:flutter/material.dart';
import 'package:brown_grow_app/widgets/side_nav_bar.dart';
import 'addvisit.dart';
import 'previosvisit.dart'; // Import the AddVisit page

class FieldOfficerDashboard extends StatefulWidget {
  const FieldOfficerDashboard({super.key});

  @override
  _FieldOfficerDashboardState createState() => _FieldOfficerDashboardState();
}

class _FieldOfficerDashboardState extends State<FieldOfficerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the Column vertically and horizontally
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center
            crossAxisAlignment:
                CrossAxisAlignment.center, // Horizontally center
            children: [
              const Text(
                "Field Officer Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              // Displaying the buttons in a GridView
              GridView.count(
                shrinkWrap: true, // Prevent GridView from taking too much space
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16, // Spacing between columns
                mainAxisSpacing: 16, // Spacing between rows
                children: [
                  _buildDashboardButton(
                      context, "Add New Visit Detail", Icons.add_box, () {
                    // Navigate to AddVisit page when button is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddVisit()),
                    );
                  }),
                  _buildDashboardButton(context, "View Previous Visit Details",
                      Icons.view_carousel, () {
                    // Add navigation logic for View Previous Visit Details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PreviousVisit(
                                visitorName: 'Naveen',
                              )),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A helper function to build buttons
  Widget _buildDashboardButton(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blueAccent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
