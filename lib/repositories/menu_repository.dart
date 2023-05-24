import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ted_yemek/models/error.dart';

// TODO: maybe add the List<String>? _favoriteDishes; thing here too
class MenuRepository {
  static final Uri menuUri = Uri.https("www.tedistanbul.com.tr", "/sofra/MobilHaftalik.aspx", {"school": "3"});
  static const String _cache = "cache.html";
  static const String _cacheExpr = "cache.html.expiration";

  final SharedPreferences preferences;
  const MenuRepository(this.preferences);

  Future<String?> getCachedHtml() async {
    final now = DateTime.now();
    final cacheExpiration = preferences.getInt(_cacheExpr); // EPOCH (MS)

    if (cacheExpiration != null && cacheExpiration > now.millisecondsSinceEpoch) {
      final htmlCache = preferences.getString(_cache);
      if (htmlCache != null) return htmlCache;
    }
    return null;
  }

  Future<void> setCacheHtml(String html) async {
    final now = DateTime.now();
    await preferences.setString(_cache, html);

    final expirationDate = DateTime(now.year, now.month, now.day).add(Duration(days: 8 - now.weekday));
    await preferences.setInt("cache.html.expiration", expirationDate.millisecondsSinceEpoch);
  }

  Future<void> clearCache() async {
    await preferences.remove(_cacheExpr);
    await preferences.remove(_cache);
  }

  Future<bool> get menuCacheValid async {
    final cacheExpiration = preferences.getInt(_cacheExpr);
    if (cacheExpiration == null) return false;

    final now = DateTime.now();

    return cacheExpiration > now.millisecondsSinceEpoch;
  }

  Future<String> fetchMenuHtml() async {
    final Response response;
    try {
      response = await http.get(menuUri);
    } catch (e) {
      throw AppError(
          "Bağlantı hatası",
          "Menü sitesine erişirken bir hata oluşmuştur. Lütfen internet bağlantınızı kontrol ediniz.",
          "${e.runtimeType}\n$e",
          Icons.wifi_off);
    }
    if (response.statusCode != 200) {
      throw AppError(
          "Site hatası", "Menü sitesi çökmüştür; lütfen sonra tekrar deneyiniz.", response.body, Icons.public_off);
    }
    return response.body;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
