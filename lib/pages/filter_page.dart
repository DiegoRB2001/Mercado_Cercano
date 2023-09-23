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
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Text(
                  "Filtro de mercados",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: DropdownButton<String>(
                      hint: const Text(
                        "Selecciona un producto",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.black),
                      items: productList
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (!selected.contains(value)) {
                            selected.add(value!);
                          }
                        });
                      },
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
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                          selected.removeWhere(
                                              (element) => element == producto);
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
