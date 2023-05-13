import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ted_yemek/html/parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (light, dark) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: light ?? ThemeData.light().colorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: dark ?? ThemeData.dark().colorScheme,
          cardColor: dark?.onSurface,
        ),
        home: const MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const String html = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwULLTIwODA1MzUzNjdkZMIdZoHLllyUBG2Bt8JwuEbYbjPfM2zsOGgZgzICAG7t" />

<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="B0D34A4C" />
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
                                    8 Mayıs 2023 Pazartesi
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
                                Tarhana Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kadınbudu Köfte
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Erişte
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Patlıcan Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Karnabahar
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
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    9 Mayıs 2023 Salı
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
                                Ezogelin Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kıymalı Ispanak
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Su Böreği
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Mantar Pilaki
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kakaolu Şarlot
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kabak-Havuç Tarator
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    10 Mayıs 2023 Çarşamba
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
                                Terbiyeli Havuç Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Köri Soslu Tavuk
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Bulgur Pilavı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Beyaz Lahana Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kemalpaşa
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Patates Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Orbit Fasulye
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    11 Mayıs 2023 Perşembe
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
                                Zeytinyağlı Brokoli
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sütlü İrmik Tatlısı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sebze Çorba
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    12 Mayıs 2023 Cuma
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
                                Brokoli Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Hamburger
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Patates Tava
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Buğday Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Enginar
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sütlaç
                            </td>
                        </tr>
                        
                    </table>
                </div>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
""";

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> menu = [];

  Future<void> _updateMenu() async {
    // var response = await get(Uri.https("www.tedistanbul.com.tr", "/sofra/MobilHaftalik.aspx", {"school": "3"}));
    //
    // var html = response.body;

    var weeklyMenu = HtmlParser.toMenu(html);
    var today = kDebugMode ? weeklyMenu.days[0] : weeklyMenu.today;

    Duration? timeUntilLunch;
    if (today != null) {
      timeUntilLunch = today.durationUntilLunch();
    }

    setState(() {
      menu = [
        Text("${weeklyMenu.mondayDate} ve sonrası için menü",
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
        if (today != null)
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Günlük Menü",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        today.dayOfTheWeek,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                  for (var dish in today.dishes) DishCard(dishName: dish, dense: true),
                  const SizedBox(height: 5),
                  timeUntilLunch != null
                      ? UntilLunchTimer(timeUntilLunch)
                      : Text("YEMEK ZİLİ GEÇMİŞTİR", style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
          ),
        for (var day in weeklyMenu.days) ...[
          DayTile(dayOfTheWeek: day.dayOfTheWeek),
          for (var dish in day.dishes) DishCard(dishName: dish)
        ]
      ];
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
        title: Text("TED Yemek Menüsü"),
      ),
      body: ListView(
        children: menu,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _updateMenu,
      ),
    );
  }
}

// THIS SUCKS TODO FIX IT
class UntilLunchTimer extends StatefulWidget {
  final Duration durationUntilLunch;

  const UntilLunchTimer(this.durationUntilLunch, {Key? key}) : super(key: key);

  @override
  State<UntilLunchTimer> createState() => _UntilLunchTimerState();
}

class _UntilLunchTimerState extends State<UntilLunchTimer> {
  late Timer _timeUntilLunch;
  late int _secondsUntilLunch;

  void _initializeTimer() {
    _secondsUntilLunch = widget.durationUntilLunch.inSeconds;
    _timeUntilLunch = Timer.periodic(Duration(seconds: 1), (timer) {
      print("bruh");
      if (_secondsUntilLunch <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsUntilLunch--;
        });
      }
    });
  }

  @override
  void initState() {
    _initializeTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timeUntilLunch.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sec = (_secondsUntilLunch % 60).toString().padLeft(2, "0");
    var minPre = (_secondsUntilLunch / 60).floor();
    var min = (minPre % 60).toString().padLeft(2, "0");
    var hour = (minPre / 60).floor().toString().padLeft(2, "0");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Text("YEMEĞE KALAN SÜRE", style: Theme.of(context).textTheme.labelMedium),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topLeft,
          child: Text(_secondsUntilLunch == 0 ? "BİRAZDAN ZİL ÇALAR :)" : "$hour:$min:$sec",
              style: Theme.of(context).textTheme.displayMedium),
        ),
      ],
    );
  }
}

class DayTile extends StatelessWidget {
  final String dayOfTheWeek;
  const DayTile({Key? key, required this.dayOfTheWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Text(dayOfTheWeek, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(width: 10),
          Expanded(child: Divider())
        ],
      ),
    );
  }
}

class DishCard extends StatelessWidget {
  final String dishName;
  final bool dense;
  // final Icon? _dishIcon;

  const DishCard({Key? key, required this.dishName, this.dense = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: dense ? EdgeInsets.symmetric(horizontal: 0) : null,
      dense: true,
      title: Text(dishName, style: Theme.of(context).textTheme.bodyLarge),
      leading: Icon(Icons.remove),
    );
  }
}

// Card(
// margin: EdgeInsets.all(8),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 8),
// child: ListTile(
// title: Text(
// "Pazartesi",
// style: Theme.of(context).textTheme.headlineLarge,
// ),
// subtitle: Text(
// menu[0].dishes.join(""),
// ),
// ),
// ),
// )
