import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gasto.dart';
import '../providers/gasto_provider.dart';

class AddGastoScreen extends StatefulWidget {
  final Gasto? gastoExistente;

  const AddGastoScreen({super.key, this.gastoExistente});

  @override
  State<AddGastoScreen> createState() => _AddGastoScreenState();
}

class _AddGastoScreenState extends State<AddGastoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();

  String _categoriaSeleccionada = 'General';
  DateTime _fechaSeleccionada = DateTime.now();

  final List<String> _categorias = [
    'General',
    'Alimentos',
    'Educación',
    'Transporte',
    'Diversión',
    'Salud',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.gastoExistente != null) {
      _descripcionController.text = widget.gastoExistente!.descripcion;
      _montoController.text = widget.gastoExistente!.monto.toString();
      _categoriaSeleccionada = widget.gastoExistente!.categoria;
      _fechaSeleccionada = widget.gastoExistente!.fecha;
    }
  }

  void _guardarGasto() {
    if (_formKey.currentState!.validate()) {
      final proveedor = Provider.of<GastoProvider>(context, listen: false);
      if (widget.gastoExistente == null) {
        final gasto = Gasto(
          descripcion: _descripcionController.text,
          monto: double.parse(_montoController.text),
          categoria: _categoriaSeleccionada,
          fecha: _fechaSeleccionada,
        );
        proveedor.agregarGasto(gasto);
      } else {
        final gasto = Gasto(
          id: widget.gastoExistente!.id,
          descripcion: _descripcionController.text,
          monto: double.parse(_montoController.text),
          categoria: _categoriaSeleccionada,
          fecha: _fechaSeleccionada,
        );
        proveedor.actualizarGasto(gasto);
      }

      Navigator.pop(context);
    }
  }

  void _seleccionarFecha() async {
    final DateTime? fechaElegida = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );

    if (fechaElegida != null) {
      setState(() {
        _fechaSeleccionada = fechaElegida;
      });
    }
  }

  void _confirmarEliminacion() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('¿Eliminar este gasto?'),
            content: const Text('Esta acción es irreversible'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<GastoProvider>(
                    context,
                    listen: false,
                  ).eliminarGasto(widget.gastoExistente!.id!);
                  Navigator.of(ctx).pop();
                  Navigator.of(
                    context,
                  ).pop(); // Volver a la actividad anterior (Home)
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
              ),
              TextFormField(
                controller: _montoController,
                decoration: const InputDecoration(labelText: 'Monto (\$)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obligatorio';
                  final monto = double.tryParse(value);
                  return (monto == null || monto <= 0)
                      ? 'Monto inválido'
                      : null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items:
                    _categorias.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _categoriaSeleccionada = valor!;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Fecha: ${_fechaSeleccionada.day.toString().padLeft(2, '0')}/${_fechaSeleccionada.month.toString().padLeft(2, '0')}/${_fechaSeleccionada.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _seleccionarFecha,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fechaSeleccionada = DateTime.now();
                      });
                    },
                    child: const Text('Hoy'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fechaSeleccionada = DateTime.now().subtract(
                          const Duration(days: 1),
                        );
                      });
                    },
                    child: const Text('Ayer'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarGasto,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Gasto'),
              ),
              const SizedBox(height: 20),
              if (widget.gastoExistente != null)
                ElevatedButton.icon(
                  onPressed: _confirmarEliminacion,
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar Gasto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
