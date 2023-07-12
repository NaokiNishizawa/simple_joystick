import 'package:flutter/material.dart';
import 'package:simple_joystick/simple_joystick.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple JoyStick Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simple JoyStick Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Alignment currentAlignment = const Alignment(0, 0);

  @override
  Widget build(BuildContext context) {
    void move(Alignment alignment) {
      currentAlignment = alignment;
      setState(() {});
    }

    final ball = AnimatedAlign(
      alignment: currentAlignment,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ball,
            ),
            JoyStick(
              150,
              50,
              (details) {
                // nothing
                move(details.alignment);
              },
            ),
          ],
        ),
      ),
    );
  }
}
