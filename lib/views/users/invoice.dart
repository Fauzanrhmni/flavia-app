import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Invoice",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: GlobalColors.hitam,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 11),
          child: SvgPicture.asset(
            'assets/svgs/head_logo.svg', // Path ke file SVG
            height: 23,
          ),
        ),
      ),
      body: Center(
        child: Text("Invoice"),
      ),
    );
  }
}
