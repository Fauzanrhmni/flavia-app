import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Like extends StatefulWidget {
  const Like({super.key});

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Menu",
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
        child: Text("Like"),
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:flavia_app/model/api.dart';
// import 'package:flavia_app/utils/global.colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Like extends StatefulWidget {
//   const Like({super.key});

//   @override
//   State<Like> createState() => _LikeState();
// }

// class _LikeState extends State<Like> {
//   int jumlah = 1;

//   void _tambahJumlah() {
//     setState(() {
//       jumlah++;
//     });
//   }

//   void _kurangiJumlah() {
//     setState(() {
//       if (jumlah > 1) {
//         jumlah--;
//       }
//     });
//   }

//   String idUsers = '';
//   String name = '';

//   Future<void> _fetchUserData(String id) async {
//     final response = await http.post(
//       Uri.parse(BaseUrl.like),
//       body: {'id': id},
//     );

//     if (response.statusCode == 200) {
//       // Jika request berhasil
//       final jsonData = jsonDecode(response.body);
//       setState(() {
//         name = jsonData['name'];
//         idUsers = jsonData['idUsers'];
//       });
//     } else {
//       // Jika request gagal
//       setState(() {
//         name = 'Failed to load data';
//         idUsers = 'Failed to load data';
//       });
//     } 
//   }

//   getPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       idUsers = preferences.getString("id") ?? "";
//     });
//     _fetchUserData(idUsers);
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPref();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 70,
//         title: Text(
//           "Disukai",
//           style: GoogleFonts.inter(
//             textStyle: TextStyle(
//               color: GlobalColors.hitam,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 18.0, right: 11),
//           child: SvgPicture.asset(
//             'assets/svgs/head_logo.svg', // Path ke file SVG
//             height: 23,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: GlobalColors.abu,
//                 width: 2.0,
//               ),
//               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
//             ),
//             padding: const EdgeInsets.all(20),
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment:
//                         MainAxisAlignment.center, // Gambar di tengah vertikal
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       ClipOval(
//                         child: SizedBox(
//                           width: 80, // Ukuran gambar 1:1
//                           height: 80,
//                           child: Image.network(
//                             'assets/jpg/default.jpg',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "namaProduk",
//                         style: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                             color: GlobalColors.hitam,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Harga",
//                                 style: GoogleFonts.inter(
//                                   textStyle: TextStyle(
//                                       color: GlobalColors.abu,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12),
//                                 ),
//                               ),
//                               Text(
//                                 "harga",
//                                 style: GoogleFonts.inter(
//                                   textStyle: TextStyle(
//                                       color: GlobalColors.hitam,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 20),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: <Widget>[
//                           Container(
//                             height: 30,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: GlobalColors.yellow,
//                                 width: 1.5,
//                               ),
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(8.0)),
//                             ),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: IconButton(
//                                       onPressed: () {
//                                         _kurangiJumlah();
//                                       },
//                                       icon: Icon(
//                                         Iconsax.minus,
//                                         color: jumlah > 1
//                                             ? GlobalColors.yellow
//                                             : GlobalColors.hitam,
//                                         size: 15,
//                                       ),
//                                       padding: EdgeInsets.zero,
//                                       constraints: const BoxConstraints(),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 15,
//                                   ),
//                                   Text(
//                                     "$jumlah",
//                                     style: GoogleFonts.inter(
//                                       textStyle: TextStyle(
//                                         color: GlobalColors.hitam,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 15,
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: IconButton(
//                                       onPressed: () {
//                                         _tambahJumlah();
//                                       },
//                                       icon: Icon(
//                                         Iconsax.add,
//                                         color: GlobalColors.yellow,
//                                         size: 15,
//                                       ),
//                                       padding: EdgeInsets.zero,
//                                       constraints: const BoxConstraints(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 5.0),
//                             child: Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 color: GlobalColors.yellow,
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(8.0)),
//                               ),
//                               child: IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Iconsax.shopping_cart,
//                                   color: GlobalColors.putih,
//                                   size: 15,
//                                 ),
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 5.0),
//                             child: Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 color: GlobalColors.pinky,
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(8.0)),
//                               ),
//                               child: IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Iconsax.trash,
//                                   color: GlobalColors.putih,
//                                   size: 15,
//                                 ),
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: GlobalColors.abu,
//                 width: 2.0,
//               ),
//               borderRadius: const BorderRadius.all(Radius.circular(15.0)),
//             ),
//             padding: const EdgeInsets.all(20),
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment:
//                         MainAxisAlignment.center, // Gambar di tengah vertikal
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       ClipOval(
//                         child: SizedBox(
//                           width: 100, // Ukuran gambar 1:1
//                           height: 100,
//                           child: Image.network(
//                             'assets/jpg/default.jpg',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "namaProduk",
//                         style: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                             color: GlobalColors.hitam,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Deskripsi",
//                             style: GoogleFonts.inter(
//                               textStyle: TextStyle(
//                                   color: GlobalColors.abu,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Iconsax.eye4),
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     title: Text(
//                                       'Deskripsi',
//                                       style: GoogleFonts.inter(
//                                         textStyle: TextStyle(
//                                             color: GlobalColors.hitam,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 18),
//                                       ),
//                                     ),
//                                     content: SingleChildScrollView(
//                                       child: ListBody(
//                                         children: <Widget>[
//                                           Text(
//                                             'Tidak ada deskripsi',
//                                             style: GoogleFonts.inter(
//                                               textStyle: TextStyle(
//                                                   color: GlobalColors.hitam,
//                                                   fontSize: 13),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: Text(
//                                           'Tutup',
//                                           style: GoogleFonts.inter(
//                                             textStyle: TextStyle(
//                                                 color: GlobalColors.yellow,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Harga",
//                                 style: GoogleFonts.inter(
//                                   textStyle: TextStyle(
//                                       color: GlobalColors.abu,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12),
//                                 ),
//                               ),
//                               Text(
//                                 "harga",
//                                 style: GoogleFonts.inter(
//                                   textStyle: TextStyle(
//                                       color: GlobalColors.hitam,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 20),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Stok",
//                                 style: GoogleFonts.inter(
//                                   textStyle: TextStyle(
//                                       color: GlobalColors.abu,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12),
//                                 ),
//                               ),
//                               Text(
//                                 "qty",
//                                 style: GoogleFonts.inter(
//                                   textStyle: TextStyle(
//                                       color: GlobalColors.hitam,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: <Widget>[
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     GlobalColors.hijau, // Warna kuning
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       8.0), // Radius bisa diubah
//                                 ),
//                                 minimumSize: const Size(0, 35)),
//                             child: Text(
//                               "Edit",
//                               style: GoogleFonts.inter(
//                                 textStyle: TextStyle(
//                                   color: GlobalColors.putih,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     GlobalColors.pinky, // Warna kuning
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       8.0), // Radius bisa diubah
//                                 ),
//                                 minimumSize: const Size(0, 35)),
//                             child: Text(
//                               "Hapus",
//                               style: GoogleFonts.inter(
//                                 textStyle: TextStyle(
//                                   color: GlobalColors.putih,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
