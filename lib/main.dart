import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  final TextEditingController _controller = TextEditingController();
  bool isFilled = false;
  String qrResponse = " ";
  String inputValue = " ";

  ////launch Url
  // Future<void> _launchNewsUrl(String newsUrl) async {
  //   var url = Uri.parse(newsUrl);
  //   if (!await launchUrl(url)) {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade400,
                ),
                child: TextFormField(
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        inputValue = " ";
                      });
                    } else {
                      setState(() {
                        inputValue = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Genererate QR Code or Scan and paste code here",
                    focusedBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: (() {
                        if (inputValue.contains("http") ||
                            inputValue.contains("https")) {
                          print("launch url");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Insert Url Link",
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            //Shows QR Code
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: inputValue, //convert the text input to a QR Code
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30),
            Text(qrResponse),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", true, ScanMode.QR);

          setState(
            () async {
              qrResponse =
                  barcodeScanRes == "-1" ? "No QR found" : barcodeScanRes;
              // await Clipboard.setData(ClipboardData(text: qrResponse));
              await Clipboard.setData(ClipboardData(text: qrResponse)).then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(barcodeScanRes == "-1"
                          ? "No QR found"
                          : barcodeScanRes),
                    ),
                  );
                },
              );
            },
          );
        },
        tooltip: 'Scan QRCode',
        label: const Text("Scan QRCode"),
      ),
    );
  }
}
