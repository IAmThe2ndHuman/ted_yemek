import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ted_yemek/models/error.dart';
import 'package:ted_yemek/repositories/settings_repository.dart';

// TODO: maybe add the List<String>? _favoriteDishes; thing here too
class MenuRepository {
  static const String _cache = "cache.html";
  static const String _cacheExpr = "cache.html.expiration";

  static String _getCachePathOfSchool(SchoolType schoolType) =>
      "$_cache.${schoolType.id}";
  static String _getCacheExprPathOfSchool(SchoolType schoolType) =>
      "$_cacheExpr.${schoolType.id}";

  final SharedPreferences preferences;
  const MenuRepository(this.preferences);

  Future<String?> getCachedHtml(SchoolType schoolType) async {
    final now = DateTime.now();
    final cacheExpiration =
        preferences.getInt(_getCacheExprPathOfSchool(schoolType)); // EPOCH (MS)

    if (cacheExpiration != null &&
        cacheExpiration > now.millisecondsSinceEpoch) {
      final htmlCache =
          preferences.getString(_getCachePathOfSchool(schoolType));
      if (htmlCache != null) return htmlCache;
    }
    return null;
  }

  Future<void> setCacheHtml(String html, SchoolType schoolType) async {
    final now = DateTime.now();
    await preferences.setString(_getCachePathOfSchool(schoolType), html);

    final expirationDate = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 8 - now.weekday));
    await preferences.setInt(_getCacheExprPathOfSchool(schoolType),
        expirationDate.millisecondsSinceEpoch);
  }

  Future<void> clearCache(SchoolType schoolType) async {
    await preferences.remove(_getCacheExprPathOfSchool(schoolType));
    await preferences.remove(_getCachePathOfSchool(schoolType));
  }

  bool menuCacheValid(SchoolType schoolType) {
    final cacheExpiration =
        preferences.getInt(_getCacheExprPathOfSchool(schoolType));
    if (cacheExpiration == null) return false;

    final now = DateTime.now();

    return cacheExpiration > now.millisecondsSinceEpoch;
  }

  static Uri getMenuUri(SchoolType schoolType) {
    return Uri.https("www.tedistanbul.com.tr", "/sofra/MobilHaftalik.aspx",
        {"school": schoolType.id.toString()});
  }

  Future<String> fetchMenuHtml(SchoolType schoolType) async {
    final http.Response response;
    try {
      response = await http.get(getMenuUri(schoolType),
          headers: {"Access-Control-Allow-Origin": "*"});
    } catch (e) {
      throw AppError(
          "Bağlantı hatası",
          "Menü sitesine erişirken bir hata oluşmuştur. Lütfen internet bağlantınızı kontrol ediniz.",
          "${e.runtimeType}\n$e",
          Icons.wifi_off);
    }
    if (response.statusCode != 200) {
      throw AppError(
          "Site hatası",
          "Menü sitesi çökmüştür; lütfen sonra tekrar deneyiniz.",
          response.body,
          Icons.public_off);
    }
    return response.body;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
