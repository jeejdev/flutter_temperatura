import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Temperature Monitor'),
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
  double? currentTemperature;
  bool isLedOn = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchTemperature();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchTemperature();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTemperature() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/temperature'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentTemperature = data['temperature'].toDouble();
          isLedOn = currentTemperature! > 45;
        });
      } else {
        throw Exception('Failed to load temperature');
      }
    } catch (e) {
      print('Error fetching temperature: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current Temperature:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              currentTemperature != null
                  ? '${currentTemperature!.toStringAsFixed(1)} °C'
                  : 'Loading...',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.lightbulb,
              color: isLedOn ? Colors.yellow : Colors.grey,
              size: 100,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchTemperature,
              child: const Text('Refresh Now'),
            ),
          ],
        ),
      ),
    );
  }
}