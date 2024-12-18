import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brown_grow_app/models/visitdetails_model.dart'; // Adjust the import to your model

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add visit details to Firestore
  Future<void> addVisitDetails(VisitDetailsModel visitDetails) async {
    try {
      await _firestore.collection('visit_details').add(visitDetails.toMap());
    } catch (e) {
      print('Error adding visit details to Firestore: $e');
    }
  }

  // Method to fetch visits by visitorName
  Future<List<VisitDetailsModel>> getVisitsByVisitorName(
      String visitorName) async {
    try {
      // Query Firestore collection based on visitorName
      final querySnapshot = await _firestore
          .collection('visit_details')
          .where('visitorName',
              isEqualTo: visitorName) // Query by visitorName field
          .get();

      // Convert Firestore documents to VisitDetailsModel list
      return querySnapshot.docs.map((doc) {
        return VisitDetailsModel.fromMap(
            doc.data()); // Assuming you have a fromMap method
      }).toList();
    } catch (e) {
      print('Error fetching visits by visitorName: $e');
      return []; // Return an empty list on error
    }
  }

// Optionally, you can add a method to update or delete visit details as needed
}
