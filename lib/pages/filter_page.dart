import 'package:flutter/material.dart';

const List<String> productList = [
  'Cereales',
  'Granolas',
  'Pasas',
  'Dátiles',
  'Arándanos',
  'Almendras',
  'Nueces',
  'Pistachos',
  'Lentejas',
  'Garbanzos',
  'Frijoles',
  'Chía',
  'Lino',
  'Sésamo',
  'Orégano',
  'Romero',
  'Pimienta',
  'Harina de trigo',
  'Harina de avena',
  'Harina de centeno',
  'Azúcar blanca',
  'Azúcar morena',
  'Té',
  'Café',
  'Arroz',
  'Pasta seca',
  'Avena',
  'Muesli',
  'Cereales de maíz',
  'Quinoa',
  'Amaranto',
  'Trigo sarraceno',
  'Gomitas',
  'Chocolates',
  'Caramelo',
  'Aceite de oliva',
  'Aceite de girasol',
  'Aceite de coco',
  'Sal',
  'Pimienta',
  'Levadura nutricional',
  'Proteínas en polvo',
  'Miel de abeja',
  'Queso fresco',
  'Queso oaxaca',
  'Vinagre',
  'Hongos'
];

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  // final String valorInicial;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<String> selected = [];
  List<String> searchItems = productList;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 5),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(40))),
        child: SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      "Filtro de mercados",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        selected.clear();
                        Navigator.pop(context, selected);
                      },
                      icon: const Icon(Icons.expand_more))
                ],
              ),
              SearchAnchor(
                isFullScreen: false,
                builder: (context, controller) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SearchBar(
                      hintText: 'Busca algún producto',
                      controller: controller,
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (value) {
                        controller.openView();
                        setState(() {
                          searchItems.removeWhere((element) => !element
                              .toLowerCase()
                              .contains(value.toLowerCase()));
                        });
                        print('ola');
                      },
                    ),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return List<ListTile>.generate(
                      searchItems.length,
                      (index) => ListTile(
                            title: Text(searchItems[index]),
                            onTap: () {
                              setState(() {
                                selected.add(searchItems[index]);
                                controller.closeView(searchItems[index]);
                              });
                            },
                          ));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      width: MediaQuery.of(context).size.width - 100,
                      alignment: Alignment.center,
                      height: 50,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: selected
                            .map((producto) => Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 50, minHeight: 40),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Text(
                                          producto,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        InkWell(
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            weight: 300,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selected.removeWhere((element) =>
                                                  element == producto);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          selected.clear();
                        });
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(selected),
                child: Container(
                  // agrega un margen de 10 píxeles a todos los lados
                  padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal:
                          20), // agrega un relleno de 10 píxeles verticalmente y 20 píxeles horizontalmente
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(
                        20), // agrega un borde redondeado de 20 píxeles
                  ),
                  child: const Text('Aplicar filtro',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
