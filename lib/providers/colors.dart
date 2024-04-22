import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './color.dart';

class MultiColor with ChangeNotifier {
  final List<SingleColor> _colors = [];

  List<SingleColor> get colors => _colors;

  initialData() async {
    Uri url = Uri.parse(
        "https://checkbox-77781-default-rtdb.firebaseio.com/colors.json");

    var hasil = await http.get(url);

    var hasilData = jsonDecode(hasil.body);
    
    if (hasilData != null && hasilData is Map<String, dynamic>) {
      hasilData.forEach(
        (key, value) {
          _colors.add(
            SingleColor(
              id: key,
              title: value["title"],
              status: value["status"],
            ),
          );
        },
      );
      notifyListeners();
    }
  }

  void selectAll(bool nilai) {
    if (nilai) {
      for (var element in _colors) {
        element.status = true;
      }
    } else {
      for (var element in _colors) {
        element.status = false;
      }
    }
    notifyListeners();
  }

  checkAllStatus() {
    var hasil = _colors.every((element) => element.status == true);
    return hasil;
  }

  void addColor(String title) async {
    Uri url = Uri.parse(
        "https://checkbox-77781-default-rtdb.firebaseio.com/colors.json");

    try {
      var hasil = await http.post(
        url,
        body: jsonEncode({
          "title": title,
          "status": false,
        }),
      );

      if (hasil.statusCode >= 200 && hasil.statusCode < 300) {
        _colors.add(
          SingleColor(
            id: jsonDecode(hasil.body)["name"].toString(),
            title: title,
          ),
        );
        notifyListeners();
      } else {
        throw (hasil.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }

  void deleteColor(String id) async {
    Uri url = Uri.parse(
        "https://checkbox-77781-default-rtdb.firebaseio.com/colors/$id.json");

    try {
      var hasil = await http.delete(url);

      if (hasil.statusCode >= 200 && hasil.statusCode < 300) {
        _colors.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        throw (hasil.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }
}
