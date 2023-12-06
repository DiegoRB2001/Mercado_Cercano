import 'package:flutter/material.dart';
import 'package:mercado_cercano/models/market.dart';
import 'package:mercado_cercano/pages/market_page.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.market, required this.header});

  final Market market;
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MarketPage(
                        market: market,
                        header: header,
                      )));
        },
        child: Column(
          children: [
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
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 15,
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
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.map),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    market.location['city']!,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
