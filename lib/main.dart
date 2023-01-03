import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isFilled = false;
  String qrResponse = " ";
  String inputValue = " ";

  //launch Url
  Future<void> _launchNewsUrl(String qrLink) async {
    var url = Uri.parse(qrLink);
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not launch $url",
          ),
        ),
      );
      throw 'Could not launch $url';
    }
  }

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
                    hintText: "Generate QR Code or Scan and paste QR link here",
                    focusedBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: (() async {
                        if (inputValue.contains("https:")) {
                          setState(() async {
                            await _launchNewsUrl(inputValue);
                          });

                          print(inputValue);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Insert a proper Url Link",
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
          String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", true, ScanMode.QR);
          setState(() async {
            if (barcodeScanResult == "-1") {
              qrResponse = "No QR found";
              await Clipboard.setData(ClipboardData(text: qrResponse)).then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "No QR found",
                      ),
                    ),
                  );
                },
              );
            } else if (barcodeScanResult.contains("http:")) {
              qrResponse = barcodeScanResult.replaceAll("http:", "https:");
              await Clipboard.setData(ClipboardData(text: qrResponse)).then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "QR Code copied to clipboard",
                      ),
                    ),
                  );
                },
              );
            }
          });
        },
        tooltip: 'Scan QRCode',
        label: const Text("Scan QRCode"),
      ),
    );
  }
}
