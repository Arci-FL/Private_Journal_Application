import 'package:flutter/material.dart';
import 'package:private_journal/api_service.dart';
import 'package:private_journal/screens/signupscreen.dart';
import 'package:private_journal/screens/dashboardscreen.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Loginpage> {
  final dashboardpage = Dashboardpage();
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  Map<String, dynamic> message = {'status': "Please fill in all fields"};

  Future<void> logIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        message;
      });
      return;
    }

    final result = await apiService.logIn(email, password);
    setState(() {
      message = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 34, 34, 34), // Dark gray
              Color.fromARGB(255, 0, 214, 185), // Teal
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            color: const Color.fromARGB(255, 0, 214, 185),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Loginpage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Background color
                        foregroundColor:
                            Color.fromARGB(255, 34, 34, 34), // Text color
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signuppage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(
                              255, 255, 255, 255), // Background color
                          backgroundColor:
                              Color.fromARGB(255, 34, 34, 34), // Text color
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail Address',
                            labelStyle: TextStyle(
                              fontSize: 25,
                            ),
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 25,
                            ),
                            border: UnderlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await logIn();
                                  if (message['status'] == "Login successful") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboardpage(),
                                      ),
                                    );
                                  } else {
                                    // Show a message or highlight errors
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(message['status'] ??
                                              "An error occurred")),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Please fix the errors in the form")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 34, 34, 34), // Background color
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 214, 185),
                                side: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 0, 214, 185), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 27,
                                  color: Color.fromARGB(255, 0, 214, 185),
                                ),
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
