import 'package:flutter/material.dart';
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter QR_Code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter QR_Code'),
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
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                     Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Colors.grey
               
            ),
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter Text to generate QR Code",
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
            TextField(
              onChanged: ((value) {
                //print(":::::::::::::::::::onchanged value $value");
              }),
              decoration: InputDecoration(
                hintText: "Search names",
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.cancel ,
                  ),
                ),
              ),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
