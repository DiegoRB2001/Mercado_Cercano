import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:mercado_cercano/models/market.dart';
import 'package:mercado_cercano/pages/map_page.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key, required this.market, required this.header});

  final Market market;
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 200, 201),
      appBar: AppBar(
        title: const Text("Acerca del mercado"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: header),
            const SizedBox(
              height: 10,
            ),
            Text(
              market.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Divider(
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Text(
              market.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(market.schedule),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(market.phone),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Productos en venta:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).primaryColorLight,
                ),
                width: double.infinity,
                alignment: Alignment.center,
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: market.products
                      .map((producto) => Container(
                            constraints: const BoxConstraints(minWidth: 50),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                producto,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorLight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                      child: Text(
                        'Ubicación:',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.room),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            market.address,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapPage(
                                      market: market.name,
                                      geolocation: market.geolocation,
                                    ),
                                  ));
                            },
                            child: const Row(
                              children: [
                                Text("Abrir mapa"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.directions),
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
              child: Text(
                'Imagenes:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: market.images
                      .map((e) => InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SizedBox(
                                      child: Scaffold(
                                          appBar: AppBar(
                                            backgroundColor: Colors.black,
                                          ),
                                          body: PhotoView(
                                              imageProvider: NetworkImage(
                                            e,
                                          ))),
                                    ),
                                  ));
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                e,
                                loadingBuilder:
                                    ((context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                }),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ))
                      .toList()),
            ),
          ]),
        ),
      ),
    );
  }
}
