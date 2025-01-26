import 'package:flutter/material.dart';
import 'package:private_journal/api_service.dart';
import 'package:private_journal/screens/loginscreen.dart';
import 'package:private_journal/screens/dashboardscreen.dart';

class Signuppage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<Signuppage> {
  final dashboardpage = Dashboardpage();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  Map<String, dynamic> message = {'status': "Please fill in all fields"};

  Future<void> signUp() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      setState(() {
        message;
      });
      return;
    }

    final result = await apiService.signUp(username, email, password);
    setState(() {
      message = result;
    });

    if (result == "Sign up successful") {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Dashboardpage()),
      );
    }
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
                        foregroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Background color
                        backgroundColor:
                            Color.fromARGB(255, 34, 34, 34), // Text color
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signuppage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 255, 255, 255), // Background color
                          foregroundColor:
                              Color.fromARGB(255, 34, 34, 34), // Text color
                        ),
                        child: const Text(
                          'Sign up',
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
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                fontSize: 25,
                              ),
                              border: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
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
                        const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
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
                                await signUp();
                                if (message['status'] == "Sign up successful") {
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
                              'Sign up',
                              style: TextStyle(
                                fontSize: 27,
                                color: Color.fromARGB(255, 0, 214, 185),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
