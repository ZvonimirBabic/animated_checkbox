import 'package:animated_checkbox/animated_checkbox.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Checkbox Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimatedCheckboxExamplePage(
          title: 'Animated Checkbox Example Page'),
    );
  }
}

class AnimatedCheckboxExamplePage extends StatefulWidget {
  const AnimatedCheckboxExamplePage({super.key, required this.title});

  final String title;

  @override
  State<AnimatedCheckboxExamplePage> createState() =>
      _AnimatedCheckboxExamplePageState();
}

class _AnimatedCheckboxExamplePageState
    extends State<AnimatedCheckboxExamplePage> {
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  void resetState() {
    setState(() {
      _checkbox1 = false;
      _checkbox2 = false;
      _checkbox3 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedCheckbox(
                    value: _checkbox1,
                    child: const Text('Cinnamon Agency'),
                    onChanged: (value) {
                      setState(() {
                        _checkbox1 = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AnimatedCheckbox(
                    value: _checkbox2,
                    lineColor: Colors.red,
                    checkColor: Colors.blue,
                    duration: const Duration(seconds: 2),
                    childPadding: const EdgeInsets.only(left: 32),
                    child: const Text('Cinnamon Agency 2 seconds'),
                    onChanged: (value) {
                      setState(() {
                        _checkbox2 = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AnimatedCheckbox(
                    value: _checkbox3,
                    lineColor: Colors.green,
                    checkColor: Colors.yellow,
                    duration: const Duration(seconds: 1),
                    childPadding: const EdgeInsets.only(left: 64),
                    child: const Text('Cinnamon Agency 1 second'),
                    onChanged: (value) {
                      setState(() {
                        _checkbox3 = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          disabledBackgroundColor: Colors.grey,
                        ),
                        onPressed: _checkbox1 && _checkbox2 && _checkbox3
                            ? resetState
                            : null,
                        child: const Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
