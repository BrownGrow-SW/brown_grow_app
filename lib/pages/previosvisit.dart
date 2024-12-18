// previousvisit.dart

import 'package:flutter/material.dart';
import '../models/visitdetails_model.dart';
import '../services/firestore_helper.dart';
import 'package:brown_grow_app/widgets/side_nav_bar.dart';

class PreviousVisit extends StatefulWidget {
  final String visitorName; // Visitor name passed dynamically

  const PreviousVisit({
    super.key,
    required this.visitorName,
  });

  @override
  _PreviousVisitState createState() => _PreviousVisitState();
}

class _PreviousVisitState extends State<PreviousVisit> {
  List<VisitDetailsModel> visits = []; // List to store visit data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVisits();
  }

  // Fetch visits from Firestore based on visitorName
  Future<void> _fetchVisits() async {
    final visitsFromDb =
        await FirestoreHelper().getVisitsByVisitorName(widget.visitorName);

    setState(() {
      visits = visitsFromDb;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Visit Details'),
        centerTitle: true,
      ),
      drawer: const SideNavBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : visits.isEmpty
              ? const Center(child: Text('No visit details found'))
              : ListView.builder(
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    final visit = visits[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(visit.visitorName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Supplier: ${visit.selectedSupplier}'),
                            Text('Region: ${visit.selectedRegion}'),
                            Text('Material: ${visit.selectedMaterial}'),
                            Text('Supplier Code: ${visit.supplierCode}'),
                            Text(
                                'Wash Status: ${visit.isWashSelected ? "Wash" : "No Wash"}'),
                            Text(
                                'Unwash Status: ${visit.isUnwashSelected ? "Unwash" : "No Unwash"}'),
                          ],
                        ),
                        trailing: Text(visit.date),
                      ),
                    );
                  },
                ),
    );
  }
}
