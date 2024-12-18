import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/dialog_utils.dart';
import 'fieldoffice_dashboard.dart';
import 'home.dart'; // Import the login page

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to handle user signup
  void handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create user using email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Get the UID of the newly created user
        String userUID = userCredential.user?.uid ?? '';

        // Prepare user data to be stored in Firestore
        Map<String, dynamic> userData = {
          'name': nameController.text,
          'email': emailController.text,
          'contact': contactController.text,
          'role': 'field_officer', // Default role for signup
        };

        // Store user data in Firestore under the 'users' collection
        await _firestore.collection('users').doc(userUID).set(userData);

        // Navigate to the field officer dashboard (or any page as needed)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const FieldOfficerDashboard()),
        );
        showSuccessDialog(context, "You have successfully registered!");
      } catch (e) {
        // Show error message if signup fails
        print('Signup failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
                height: 120), // Reduced top space for the entire form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Center(
                      child: Text(
                        "Let's create an Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Full Name
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),

                    // Email Address
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "E-mail Address",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),

                    // Contact Number
                    TextFormField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: "Contact Number",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),

                    // Sign Up button
                    ElevatedButton(
                      onPressed: handleSignUp,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        textStyle: const TextStyle(fontSize: 18.0),
                        backgroundColor: Colors.lime.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 15.0),

                    // Already have an account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
