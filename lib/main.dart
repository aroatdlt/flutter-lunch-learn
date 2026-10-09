import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Counter',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;
  bool showCoffee = false;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      counter = prefs.getInt('coffee_counter') ?? 0;
    });
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coffee_counter', counter);
  }

  void _triggerCoffeeAnimation() {
    setState(() {
      showCoffee = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showCoffee = false;
      });
    });
  }

  Future<void> increment() async {
    setState(() {
      counter++;
    });

    _triggerCoffeeAnimation();
    await _saveCounter();
  }

  Future<void> decrement() async {
    setState(() {
      counter--;
    });

    _triggerCoffeeAnimation();
    await _saveCounter();
  }

  Future<void> reset() async {
    setState(() {
      counter = 0;
    });

    await _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reset,
          ),
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Cafés consumidos',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$counter',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              offset: showCoffee
                  ? const Offset(0, -3)
                  : const Offset(0, 0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: showCoffee ? 1 : 0,
                child: const Text(
                  '☕',
                  style: TextStyle(fontSize: 80),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'minus',
            onPressed: decrement,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'plus',
            onPressed: increment,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}