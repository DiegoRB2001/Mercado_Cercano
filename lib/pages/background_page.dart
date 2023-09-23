import 'package:flutter/material.dart';
import 'package:mercado_cercano/functions/data_fetch.dart';
import 'package:mercado_cercano/functions/market_sort.dart';
import 'package:mercado_cercano/models/market.dart';
import 'package:mercado_cercano/pages/filter_page.dart';
import '../widgets/custom_card.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key});

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  List<String> filter = [];
  late List<Market> _markets;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: filter.isNotEmpty,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  filter.clear();
                  setState(() {});
                },
                child: const Icon(Icons.close),
              ),
            ),
            Visibility(
              visible: filter.isEmpty,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  filter = (await showModalBottomSheet<List<String>>(
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40))),
                    context: context,
                    builder: (BuildContext context) {
                      return const FilterPage();
                    },
                  ))!;
                  setState(() {});
                },
                child: const Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        body: FutureBuilder<Map<String, dynamic>>(
            future: getData(filter),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Cargando información",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const CircularProgressIndicator(),
                  ],
                );
              }
              _markets = snapshot.data!['markets'];
              sortMarkets(_markets, snapshot.data!['position']);

              return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return <Widget>[
                      const SliverAppBar(
                        expandedHeight: 200.0,
                        floating: false,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text("Mercado cercano",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                        ),
                      ),
                    ];
                  },
                  body: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: _markets.isEmpty
                                  ? [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Mostrando mercados de: ',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                '${snapshot.data!['location']['city']}, ${snapshot.data!['location']['state']}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            const Expanded(
                                              child: Center(
                                                child: Text(
                                                  'No se encontraron resultados',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]
                                  : [
                                      const Text(
                                        'Mostrando mercados de: ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          '${snapshot.data!['location']['city']}, ${snapshot.data!['location']['state']}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      ..._markets
                                          .map((e) => FutureBuilder<String>(
                                              future: getURL(e.cover),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      '${snapshot.error}');
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  child: CustomCard(
                                                    image: NetworkImage(
                                                        snapshot.data!),
                                                    market: e,
                                                  ),
                                                );
                                              }))
                                          .toList()
                                    ],
                            )),
                      )));
            }),
      ),
    );
  }
}
