import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'models/gasto.dart';

class TestDBScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  TestDBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Base de Datos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _insertarGasto, 
            child: const Text('Insertar Gasto')
            ),
            ElevatedButton(onPressed: _consultarGastos, 
            child: const Text('Consultar Gastos')
            )
          ],
        ),
      ),
    );
  }

  void _insertarGasto() async {
    Gasto nuevoGasto = Gasto(
        descripcion: 'Café',
        categoria: 'Alimentos',
        monto: 2.5,
        fecha: DateTime.now()
      );

      int id = await dbHelper.insertGasto(nuevoGasto);
      debugPrint('Gasto insertado con id: $id');
  }

  void _consultarGastos() async {
    List<Gasto> gastos = await dbHelper.getGastos();
    for (var gasto in gastos) {
      debugPrint(
        'ID: ${gasto.id}, Descripcion: ${gasto.descripcion}, Categoria: ${gasto.categoria}, Monto: ${gasto.monto}, Fecha: ${gasto.fecha}'
      );
    }
  }

}