import 'dart:convert';

import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/produkModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flavia_app/views/editProduk.dart';
import 'package:flavia_app/views/tambahProduk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Produk extends StatefulWidget {
  final String nameApi;
  const Produk({super.key, required this.nameApi});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final money = NumberFormat("#,###", "id_ID");

  String capitalize(String input) {
    return input.isNotEmpty
        ? '${input[0].toUpperCase()}${input.substring(1)}'
        : '';
  }

  var loading = false;
  final List<ProdukModel> list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse(BaseUrl.lihatProduk),
    );
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach(
        (api) {
          final ab = ProdukModel(
            id: api['id'],
            namaProduk: api['namaProduk'],
            qty: api['qty'],
            harga: api['harga'],
            deskripsi: api['deskripsi'],
            createdDate: api['createdDate'],
            idUsers: api['idUsers'],
            name: api['name'],
            image: api['image'],
          );
          list.add(ab);
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: <Widget>[
              const Text("Apakah kamu yakin ingin menghapus produk ini?"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Tidak"),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      _delete(id);
                    },
                    child: const Text("Ya"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _delete(String id) async {
    final response = await http.post(
      Uri.parse(BaseUrl.deleteProduk),
      body: {
        "idProduk": id,
      },
    ); 
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Produk",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TambahProduk(_lihatData),
            ),
          );
        },
        backgroundColor: GlobalColors.yellow,
        child: const Icon(
          Iconsax.box_add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity, // Memastikan widget penuh lebar
                  child: Align(
                    alignment:
                        Alignment.centerLeft, // Mengatur teks menjadi rata kiri
                    child: Text(
                      "Hai Admin ${capitalize(widget.nameApi)}!",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: GlobalColors.hitam,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity, // Memastikan widget penuh lebar
                  child: Align(
                    alignment:
                        Alignment.centerLeft, // Mengatur teks menjadi rata kiri
                    child: Text(
                      "Anda dapat menambahkan makanan atau\nminuman di halaman ini",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: GlobalColors.abu,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _lihatData,
              key: _refresh,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: GlobalColors.abu,
                                  width: 2.0,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                              ),
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Gambar di tengah vertikal
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        ClipOval(
                                          child: SizedBox(
                                            width: 100, // Ukuran gambar 1:1
                                            height: 100,
                                            child: Image.network(
                                              '${BaseUrl.uploadProduk}${x.image}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          x.namaProduk,
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              color: GlobalColors.hitam,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Deskripsi",
                                              style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    color: GlobalColors.abu,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Iconsax.eye4),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      title: Text(
                                                        'Deskripsi',
                                                        style:
                                                            GoogleFonts.inter(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  GlobalColors
                                                                      .hitam,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            x.deskripsi
                                                                    .isNotEmpty
                                                                ? Text(
                                                                    x.deskripsi,
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      textStyle: TextStyle(
                                                                          color: GlobalColors
                                                                              .hitam,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Tidak ada deskripsi',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      textStyle: TextStyle(
                                                                          color: GlobalColors
                                                                              .hitam,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Tutup',
                                                            style: GoogleFonts
                                                                .inter(
                                                              textStyle: TextStyle(
                                                                  color:
                                                                      GlobalColors
                                                                          .yellow,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Harga",
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        color: GlobalColors.abu,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Text(
                                                  money.format(
                                                      int.parse(x.harga)),
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        color:
                                                            GlobalColors.hitam,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Stok",
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        color: GlobalColors.abu,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Text(
                                                  x.qty,
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        color:
                                                            GlobalColors.hitam,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProduk(
                                                            x, _lihatData),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: GlobalColors
                                                      .hijau, // Warna kuning
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Radius bisa diubah
                                                  ),
                                                  minimumSize:
                                                      const Size(0, 35)),
                                              child: Text(
                                                "Edit",
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    color: GlobalColors.putih,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                dialogDelete(x.id);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: GlobalColors
                                                      .pinky, // Warna kuning
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Radius bisa diubah
                                                  ),
                                                  minimumSize:
                                                      const Size(0, 35)),
                                              child: Text(
                                                "Hapus",
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    color: GlobalColors.putih,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
