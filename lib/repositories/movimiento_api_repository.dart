import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finanzaspersonales/model/movimiento.dart';

class MovimientoApiRepository {
  //final String baseUrl = 'http://localhost:3000/movimientos';
  final String baseUrl = "https://wdqjjd59-5000.brs.devtunnels.ms/movimientos";

  // Insertar un nuevo movimiento en el servidor
  Future<Movimiento?> insertarMovimiento(Movimiento movimiento) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movimiento.toMap()),
    );

    if (response.statusCode == 201) {
      return Movimiento.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar el movimiento');
    }
  }

  // Obtener todos los movimientos desde el servidor
  Future<List<Movimiento>> obtenerMovimientos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((map) => Movimiento.fromMap(map)).toList();
    } else {
      throw Exception('Error al obtener los movimientos');
    }
  }

  // Obtener un movimiento por ID
  Future<Movimiento?> obtenerMovimientoPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Movimiento.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null; // Movimiento no encontrado
    } else {
      throw Exception('Error al obtener el movimiento');
    }
  }

  // Actualizar un movimiento en el servidor
  Future<Movimiento?> actualizarMovimiento(Movimiento movimiento) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${movimiento.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movimiento.toMap()),
    );

    if (response.statusCode == 200) {
      return Movimiento.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar el movimiento');
    }
  }

  // Eliminar un movimiento en el servidor
  Future<void> eliminarMovimiento(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el movimiento');
    }
  }

  // Obtener solo ingresos
  Future<List<Movimiento>> obtenerIngresos() async {
    final response = await http.get(Uri.parse('$baseUrl?tipo=ingreso'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((map) => Movimiento.fromMap(map)).toList();
    } else {
      throw Exception('Error al obtener los ingresos');
    }
  }

  // Obtener solo gastos
  Future<List<Movimiento>> obtenerGastos() async {
    final response = await http.get(Uri.parse('$baseUrl?tipo=gasto'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((map) => Movimiento.fromMap(map)).toList();
    } else {
      throw Exception('Error al obtener los gastos');
    }
  }
}