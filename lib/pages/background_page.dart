import 'package:flutter/material.dart';
import 'package:mercado_cercano/functions/data_fetch.dart';
import 'package:mercado_cercano/functions/market_sort.dart';
import 'package:mercado_cercano/pages/filter_page.dart';
import '../widgets/market_card.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key, required this.initialData});
  final Map<String, dynamic> initialData;

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  List<String> filter = [];
  Widget header = const CircularProgressIndicator();
  late Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = Future.value(widget.initialData);
  }

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
                      _data = getData(context, filter);
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
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40))),
                        context: context,
                        builder: (BuildContext context) {
                          return const FilterPage();
                        },
                      ))!;
                      if (context.mounted) _data = getData(context, filter);
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
                future: _data,
                builder: (context, snapshot) {
                  Widget header = const Center(
                    child: CircularProgressIndicator(),
                  );
                  Widget content = Column(
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
                  if (snapshot.hasError) {
                    header = const Center(
                      child: Text('Se ha producido un error.'),
                    );
                    content = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Ha ocurrido un error",
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              _data = getData(context, filter);
                              setState(() {});
                            },
                            child: const Text('Volver a cargar'))
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    String cityName = snapshot.data!['location']['city']
                        .toString()
                        .replaceAll(' ', '_');
                    header = FutureBuilder(
                        future: getURL('$cityName.jpg'),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Se ha producido un error.'),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Image.network(snapshot.data!, fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          });
                        });
                    sortMarkets(
                        snapshot.data!['markets'], snapshot.data!['position']);
                    List<Widget> listHeader = [
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
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(color: Colors.black),
                      ),
                    ];
                    content = RefreshIndicator(
                      onRefresh: () async {
                        _data = getData(context, filter);
                        setState(() {});
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: snapshot.data!['markets'].isEmpty
                                  ? [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Column(
                                          children: [
                                            ...listHeader,
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
                                      ...listHeader,
                                      ...snapshot.data!['markets']
                                          .map((e) => FutureBuilder<String>(
                                              future: getURL(e.cover),
                                              builder: (context, snapshot) {
                                                Widget header = Container();
                                                bool ignoring = true;
                                                if (!snapshot.hasData) {
                                                  ignoring = true;
                                                  header = const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: SizedBox(
                                                        height: 200,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  ignoring = true;
                                                  header = const Center(
                                                    child: Text(
                                                        'Ha ocurrido un error'),
                                                  );
                                                }
                                                if (snapshot.hasData) {
                                                  ignoring = false;
                                                  header = Image.network(
                                                    loadingBuilder: ((context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: SizedBox(
                                                          height: 200,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    snapshot.data!,
                                                    height: 200,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.fill,
                                                  );
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  child: CustomCard(
                                                    ignoring: ignoring,
                                                    header: header,
                                                    market: e,
                                                  ),
                                                );
                                              }))
                                          .toList()
                                    ],
                            )),
                      ),
                    );
                  }
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 200.0,
                          floating: false,
                          pinned: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: header,
                            centerTitle: true,
                            title: const Text("Mercado cercano",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                )),
                          ),
                        ),
                      ];
                    },
                    body: content,
                  );
                })));
  }
}
