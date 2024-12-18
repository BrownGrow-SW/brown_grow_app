import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brown_grow_app/widgets/side_nav_bar.dart';

import '../models/visitdetails_model.dart';

class AddVisit extends StatefulWidget {
  const AddVisit({Key? key}) : super(key: key);

  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _supplierCodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Dropdown initial values
  String? _selectedSupplier = 'Select Supplier';
  String? _selectedRegion = 'Select Region';
  String? _selectedMaterial = 'Select Material';

  // Checkbox values
  bool _isWashSelected = false;
  bool _isUnwashSelected = false;

  // Dropdown options
  final List<String> _suppliers = [
    'Select Supplier',
    'Saman',
    'Perera',
    'Nimal'
  ];
  final List<String> _regions = ['Select Region', 'Southern', 'North'];
  final List<String> _materials = [
    'Select Material',
    '7C-Chips',
    '9C-Chips',
    '10C-Chips',
    'Coco-Peet'
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create the model instance with data from the form
      VisitDetailsModel visitDetails = VisitDetailsModel(
        visitorName: _visitorNameController.text,
        supplierCode: _supplierCodeController.text,
        date: _dateController.text,
        selectedSupplier: _selectedSupplier!,
        selectedRegion: _selectedRegion!,
        selectedMaterial: _selectedMaterial!,
        isWashSelected: _isWashSelected,
        isUnwashSelected: _isUnwashSelected,
      );

      // Save data to Firestore
      try {
        await FirebaseFirestore.instance
            .collection('visit_details')
            .add(visitDetails.toMap()); // Add the data to Firestore

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Form Submitted Successfully!")),
        );

        // Clear the form after submission
        _visitorNameController.clear();
        _supplierCodeController.clear();
        _dateController.clear();
        setState(() {
          _selectedSupplier = 'Select Supplier';
          _selectedRegion = 'Select Region';
          _selectedMaterial = 'Select Material';
          _isWashSelected = false;
          _isUnwashSelected = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Visit Details"),
        centerTitle: true,
      ),
      drawer: SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visitor Name
                  TextFormField(
                    controller: _visitorNameController,
                    decoration: const InputDecoration(
                      labelText: 'Field Visitor\'s Name',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the field visitor\'s name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date Field with Date Picker
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context); // Open date picker when clicked
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),

                  // Supplier Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedSupplier,
                      items: _suppliers.map((String supplier) {
                        return DropdownMenuItem<String>(
                          value: supplier,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(supplier),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSupplier = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == 'Select Supplier') {
                          return 'Please select a supplier';
                        }
                        return null;
                      },
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Supplier Code
                  TextFormField(
                    controller: _supplierCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Code',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the supplier code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Region Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRegion,
                      items: _regions.map((String region) {
                        return DropdownMenuItem<String>(
                          value: region,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(region),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRegion = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == 'Select Region') {
                          return 'Please select a region';
                        }
                        return null;
                      },
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Material Status (Checkbox)
                  Row(
                    children: [
                      // Wash Checkbox
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isWashSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isWashSelected = value!;
                                });
                              },
                            ),
                            const Text('Wash'),
                          ],
                        ),
                      ),
                      // Unwash Checkbox
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                              value: _isUnwashSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isUnwashSelected = value!;
                                });
                              },
                            ),
                            const Text('Unwash'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Material Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedMaterial,
                      items: _materials.map((String material) {
                        return DropdownMenuItem<String>(
                          value: material,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(material),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMaterial = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == 'Select Material') {
                          return 'Please select a material';
                        }
                        return null;
                      },
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lime.shade700,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
