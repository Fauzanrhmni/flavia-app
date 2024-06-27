import 'dart:io';

import 'package:flavia_app/custom/currency.dart';
import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/produkModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditProduk extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  const EditProduk(this.model, this.reload, {super.key});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = GlobalKey<FormState>();
  String? namaProduk, qty, harga, idUsers, deskripsi;
  late TextEditingController txtName, txtQty, txtHarga, txtDeskripsi;

  setup() {
    txtName = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
    txtDeskripsi = TextEditingController(text: widget.model.deskripsi);
  }

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  File? _newImageFile;
  _pilihGaleri() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 2000,
      maxWidth: 2000,
    );
    if (image != null) {
      setState(() {
        _newImageFile = File(image.path);
      });
    }
  }

  submit() async {
    try {
      var uri = Uri.parse(BaseUrl.editProduk);
      var request = http.MultipartRequest("POST", uri);

      // Jika _newImageFile tidak null, tambahkan gambar baru ke request
      if (_newImageFile != null) {
        var stream =
            http.ByteStream(Stream.castFrom(_newImageFile!.openRead()));
        var length = await _newImageFile!.length();
        request.files.add(http.MultipartFile(
          "image",
          stream,
          length,
          filename: path.basename(_newImageFile!.path),
        ));
      }

      // Tambahkan data lain ke request
      request.fields['namaProduk'] = namaProduk!;
      request.fields['qty'] = qty!;
      request.fields['harga'] = harga!.replaceAll(".", "");
      request.fields['deskripsi'] = deskripsi!;
      request.fields['idProduk'] = widget.model.id;

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Edit produk berhasil");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Gagal mengedit produk. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = SizedBox(
      width: double.infinity,
      height: 150,
      child: Image.network('${BaseUrl.uploadProduk}${widget.model.image}'),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Edit Produk",
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
                "Edit Produk yang ingin dijual",
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
                child: _newImageFile == null
                    ? placeholder
                    : SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.file(
                          _newImageFile!,
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
                controller: txtName,
                onSaved: (e) => setState(
                    () => namaProduk = e!), // Perbarui nilai namaProduk
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
                controller: txtQty,
                onSaved: (e) => setState(
                    () => qty = e!),
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
                controller: txtHarga,
                onSaved: (e) => setState(
                    () => harga = e!),
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
                // enabled: false,
                controller: txtDeskripsi,
                onSaved: (e) => setState(
                    () => deskripsi = e!),
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
