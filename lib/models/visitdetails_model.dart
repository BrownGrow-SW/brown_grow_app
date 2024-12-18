class VisitDetailsModel {
  final String visitorName;
  final String supplierCode;
  final String date;
  final String selectedSupplier;
  final String selectedRegion;
  final String selectedMaterial;
  final bool isWashSelected;
  final bool isUnwashSelected;

  VisitDetailsModel({
    required this.visitorName,
    required this.supplierCode,
    required this.date,
    required this.selectedSupplier,
    required this.selectedRegion,
    required this.selectedMaterial,
    required this.isWashSelected,
    required this.isUnwashSelected,
  });

  // Method to convert Firestore data to model
  factory VisitDetailsModel.fromMap(Map<String, dynamic> data) {
    return VisitDetailsModel(
      visitorName: data['visitorName'] ?? '',
      supplierCode: data['supplierCode'] ?? '',
      date: data['date'] ?? '',
      selectedSupplier: data['selectedSupplier'] ?? '',
      selectedRegion: data['selectedRegion'] ?? '',
      selectedMaterial: data['selectedMaterial'] ?? '',
      isWashSelected: data['isWashSelected'] ?? false,
      isUnwashSelected: data['isUnwashSelected'] ?? false,
    );
  }

  // Method to convert model to Firestore data map
  Map<String, dynamic> toMap() {
    return {
      'visitorName': visitorName,
      'supplierCode': supplierCode,
      'date': date,
      'selectedSupplier': selectedSupplier,
      'selectedRegion': selectedRegion,
      'selectedMaterial': selectedMaterial,
      'isWashSelected': isWashSelected,
      'isUnwashSelected': isUnwashSelected,
    };
  }
}
