import 'package:flutter/material.dart';
import 'package:private_journal/screens/loginscreen.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Journal',
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        ),
        body: Center(
          child: MyHome(),
        ),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 214, 185),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 214, 185),
                  width: 2.0,
                ),
              ),
              child: const Text(
                'WELCOME!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(height: 100),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 34, 34, 34), // Background color
                  foregroundColor: const Color.fromARGB(255, 0, 214, 185),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 0, 214, 185), // Border color
                    width: 2.0, // Border width
                  ), // Text color
                ),
                child: Text(
                  'Get Started >',
                  style: TextStyle(
                    fontSize: 27,
                    color: const Color.fromARGB(255, 0, 214, 185),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
