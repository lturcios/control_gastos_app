import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/gasto.dart';

class GastoProvider extends ChangeNotifier {
  List<Gasto> _gastos = [];
  final dbHelper = DatabaseHelper();

  List<Gasto> get gastos => _gastos;

  double get totalMensual {
    final ahora = DateTime.now();
    return _gastos
      .where((g) =>
        g.fecha.year == ahora.year && g.fecha.month == ahora.month)
      .fold(0.0, (suma, g) => suma + g.monto);
  }

  double get totalDelDia {
    final hoy = DateTime.now();
    return _gastos
      .where((g) => 
        g.fecha.year == hoy.year &&
        g.fecha.month == hoy.month && 
        g.fecha.day == hoy.day)
      .fold(0.0, (suma, g) => suma + g.monto);
  }

  Future<void> cargarGastos() async {
    _gastos = await dbHelper.getGastos();
    notifyListeners();
  }

  Future<void> agregarGasto(Gasto gasto) async {
    await dbHelper.insertGasto(gasto);
    await cargarGastos();
  }

  Future<void> actualizarGasto(Gasto gasto) async {
    await dbHelper.updateGasto(gasto);
    await cargarGastos();
  }

  Future<void> eliminarGasto(int id) async {
    await dbHelper.deleteGasto(id);
    await cargarGastos();
  }
}