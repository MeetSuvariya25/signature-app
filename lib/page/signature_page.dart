import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:signature_app/page/signature_preview_page.dart';

class SignaturePage extends StatefulWidget {
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  SignatureController controller;

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: <Widget>[
        Signature(
          controller: controller,
          backgroundColor: Colors.white,
        ),
        buildButtons(context),

      ],
    ),
  );



  Widget buildButtons(BuildContext context) => Container(
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildCheck(context),
        buildClear(),
      ],
    ),
  );

  Widget buildCheck(BuildContext context) => IconButton(
    iconSize: 36,
    icon: Icon(Icons.check, color: Colors.green),
    onPressed: () async {
      if (controller.isNotEmpty) {
        final signature = await exportSignature();

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SignaturePreviewPage(signature: signature),
        ));

        controller.clear();
      }
    },
  );

  Widget buildClear() => IconButton(
    iconSize: 36,
    icon: Icon(Icons.clear, color: Colors.red),
    onPressed: () => controller.clear(),
  );

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }


}
