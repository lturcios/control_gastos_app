import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/gasto_provider.dart';

class ConsultaMensualScreen extends StatefulWidget {
  const ConsultaMensualScreen({super.key});

  @override
  State<ConsultaMensualScreen> createState() => _ConsultaMensualScreenState();
}

class _ConsultaMensualScreenState extends State<ConsultaMensualScreen> {
  late DateTime _mesSeleccionado;

  @override
  void initState() {
    super.initState();
    _mesSeleccionado = DateTime.now();
  }

  void _cambiarMes(int cantidad) {
    setState(() {
      _mesSeleccionado = DateTime(
        _mesSeleccionado.year,
        _mesSeleccionado.month + cantidad,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final gastos =
        Provider.of<GastoProvider>(context).gastos
            .where(
              (gasto) =>
                  gasto.fecha.month == _mesSeleccionado.month &&
                  gasto.fecha.year == _mesSeleccionado.year,
            )
            .toList();

    final totalMes = gastos.fold<double>(0.0, (suma, g) => suma + g.monto);

    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de Gastos por Mes')),
      body: Column(
        children: [
          _barraDeMes(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Total: \$${totalMes.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child:
                gastos.isEmpty
                    ? const Center(child: Text('No hay gastos en este mes.'))
                    : ListView.builder(
                      itemCount: gastos.length,
                      itemBuilder: (context, index) {
                        final gasto = gastos[index];
                        return Card(
                          child: ListTile(
                            title: Text(gasto.descripcion),
                            subtitle: Text(
                              '${DateFormat.yMMMMd('es_ES').format(gasto.fecha)} • ${gasto.categoria}',
                            ),
                            trailing: Text(
                              '\$${gasto.monto.toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _barraDeMes() {
    final formato = DateFormat.yMMMM('es_ES');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _cambiarMes(-1),
        ),
        Text(
          formato.format(_mesSeleccionado),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _cambiarMes(1),
        ),
      ],
    );
  }
}
