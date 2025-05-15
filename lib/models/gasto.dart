class Gasto {
  int? id;
  String descripcion;
  String categoria;
  double monto;
  DateTime fecha;

  Gasto({
    this.id,
    required this.descripcion,
    required this.categoria,
    required this.monto,
    required this.fecha
  });

  // Convertir un objeto Gasto a un Map<String, dynamic> para guardar en SQLite
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha.toIso8601String() // Para guardarla como String ISO
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Crear un objeto Gasto desde un Map<String, dynamic> que ha sido recuperado desde SQLite
  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      monto: map['monto'],
      fecha: DateTime.parse(map['fecha'])
    );
  }

}