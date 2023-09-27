import 'package:flutter/material.dart';

Future<void> customDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Permisos de ubicacion desactivados'),
        content: const Text(
          'Para el funcionamiento de esta aplicación es necesario que actives los servicios de ubicación de tu dispositivo.',
          textAlign: TextAlign.justify,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
