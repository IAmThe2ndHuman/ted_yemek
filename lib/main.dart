import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:ted_yemek/html/parser.dart';
import 'package:ted_yemek/html/day.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const String html = """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>

</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
    <link href="../ted2006.css" rel="stylesheet" type="text/css" /></head>
<body>
    <form name="form1" method="post" action="./MobilHaftalik.aspx?school=3" id="form1">
<div>
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwULLTIwODA1MzUzNjdkZMIdZoHLllyUBG2Bt8JwuEbYbjPfM2zsOGgZgzICAG7t" />
</div>

<div>

	<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="B0D34A4C" />
</div>
    <table width="100%" border="0" cellpadding="2" cellspacing="2" align="center">
        <tr>
            <td class="balomavi">
         
                <span id="lblCaption">ORTAOKUL-LİSE HAFTALIK YEMEK MENÜSÜ</span>
             
            </td>
        </tr>
        <tr>
            <td class="TEXT" align="center">
                <div align="center">
                    
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    27 Mart 2023 Pazartesi
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong>
                                    <span id="lblPazartesi">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Domates Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Mantı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sebze Sote
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kalburabastı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kısır
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Barbunya Pilaki
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    28 Mart 2023 Salı
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblSali">SABAH ATIŞTIRMASI</span> </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Mantar Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kıymalı Ispanak
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Makarna
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Haydari
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Mercimek Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sütlaç
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    29 Mart 2023 Çarşamba
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblCarsamba">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Mercimek Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kremalı Mantarlı Tavuk
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Bulgur Pilavı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Haşhaşpare
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kuru Üzümlü Coleslaw
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Nohut Salatası
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    30 Mart 2023 Perşembe
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblPersembe">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Terbiyeli Havuç Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Etli Kuru Fasulye
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Pirinç Pilavı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kazandibi
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kuru Cacık
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Karışık Turşu
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    31 Mart 2023 Cuma
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblCuma">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Ezogelin Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Köfte Fajita
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Fırın Patates
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                İrmik Helvası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Makarna Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Havuç Vişi
                            </td>
                        </tr>
                        
                    </table>
                </div>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>""";

class _MyHomePageState extends State<MyHomePage> {
  List<Day> menu = [];

  Future<void> _updateMenu() async {
    // var response = await http.get(Uri.https("www.tedistanbul.com.tr", "/sofra/MobilHaftalik.aspx", {"school": "3"}));
    //
    // print(response.body);
    // var document = parse(response.body);
    setState(() {
      menu = HtmlParser.toMenu(html);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("yummy food of the week"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          children: [
            Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text("Pazartesi", style: Theme.of(context).textTheme.headlineLarge,),
                  subtitle: Text("food\nfood\nfood\nfood",),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
