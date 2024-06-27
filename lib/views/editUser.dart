import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/userModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditUser extends StatefulWidget {
  final UserModel model;
  final VoidCallback reload;
  const EditUser(this.model, this.reload, {super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _key = GlobalKey<FormState>();
  String? level;
  String? selectedValue;

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    try {
      var uri = Uri.parse(BaseUrl.editUser);
      var request = http.MultipartRequest("POST", uri);

      request.fields['level'] = level!;
      request.fields['id'] = widget.model.id;

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Edit user berhasil");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Gagal mengedit user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    selectedValue = widget.model.level;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Edit User",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              Text(
                "Edit Level User : ${widget.model.name}",
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                child: DropdownButtonFormField<String>(
                  value: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                      level = newValue; // Set level to the selected value
                    });
                  },
                  validator: (val) =>
                      val!.isEmpty ? "Level tidak boleh kosong" : null,
                  items: <String>['1', '2']
                      .map<DropdownMenuItem<String>>((String value) {
                    String text = value == '1'
                        ? 'Admin'
                        : 'User'; // Change text based on value
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(text), // Use the updated text
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    labelText: "Level",
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
      ),
    );
  }
}
