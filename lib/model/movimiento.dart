class Movimiento {
  int? id;
  String descripcion;
  double cantidad;
  String fecha;
  String tipo; // 'ingreso' o 'gasto'

  Movimiento({
    this.id,
    required this.descripcion,
    required this.cantidad,
    required this.fecha,
    required this.tipo,
  });

  // Convertir un Movimiento a Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'fecha': fecha,
      'tipo': tipo,
    };
  }

  // Crear un Movimiento a partir de un Map
  factory Movimiento.fromMap(Map<String, dynamic> map) {
    return Movimiento(
      id: map['id'],
      descripcion: map['descripcion'],
      //cantidad: map['cantidad'],
      //cantidad: map['cantidad'] is double ? map['cantidad'] : (map['cantidad'] as int).toDouble(),
      cantidad: map['cantidad'] is String
          ? double.parse(map['cantidad']) // Convertir de String a double
          : map['cantidad'].toDouble(), // Asegurarse de que sea double si es un número
      fecha: map['fecha'],
      tipo: map['tipo'],
    );
  }
}