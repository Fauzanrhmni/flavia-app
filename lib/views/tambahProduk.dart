import 'dart:io';

import 'package:flavia_app/custom/currency.dart';
import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class TambahProduk extends StatefulWidget {
  final VoidCallback reload;
  const TambahProduk(this.reload, {super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  // final money = NumberFormat("#,###", "id_ID");
  String? namaProduk, qty, harga, idUsers, deskripsi;
  final _key = GlobalKey<FormState>();
  File? _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  _pilihGaleri() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Atur kualitas gambar
      maxHeight: 2000,
      maxWidth: 2000,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  _pilihKamera() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80, // Atur kualitas gambar
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      if (_imageFile == null) {
        print("Image file is null");
        return;
      }

      var stream = http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      var uri = Uri.parse(BaseUrl.tambahProduk);
      var request = http.MultipartRequest("POST", uri);
      request.fields['namaProduk'] = namaProduk!;
      request.fields['qty'] = qty!;
      request.fields['harga'] = harga!.replaceAll(".", "");
      request.fields['deskripsi'] = deskripsi!;
      request.fields['idUsers'] = idUsers!;

      request.files.add(http.MultipartFile(
        "image",
        stream,
        length,
        filename: path.basename(_imageFile!.path),
      ));

      var response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Image uploaded");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = SizedBox(
      width: double.infinity,
      height: 150,
      child: Image.asset('assets/jpg/default.jpg'),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Tambah Produk",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: GlobalColors.hitam,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SvgPicture.asset(
              'assets/svgs/head_logo.svg', // Path ke file SVG
              height: 23,
            ),
          ),
        ],
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 25), // Jarak 8.0 di bawah teks
              child: Text(
                "Tambahkan Produk yang ingin dijual",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 150,
              child: InkWell(
                onTap: () {
                  _pilihGaleri();
                },
                child: _imageFile == null
                    ? placeholder
                    : SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.file(
                          _imageFile!,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                onSaved: (e) => namaProduk = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Nama Produk",
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                onSaved: (e) => qty = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Stok",
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormat(),
                ],
                onSaved: (e) => harga = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Harga",
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                onSaved: (e) => deskripsi = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Deskripsi",
                ),
              ),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: GlobalColors.yellow,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
