import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/util/database_helper.dart';

class MovimientoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insertar un nuevo movimiento
  Future<int> insertarMovimiento(Movimiento movimiento) async {
    return await _dbHelper.insert('movimientos', movimiento.toMap());
  }

  // Obtener todos los movimientos
  Future<List<Movimiento>> obtenerMovimientos() async {
    final List<Map<String, dynamic>> result = await _dbHelper.query('movimientos');
    return result.map((map) => Movimiento.fromMap(map)).toList();
  }

  // Obtener solo ingresos
  Future<List<Movimiento>> obtenerIngresos() async {
    final List<Map<String, dynamic>> result = await _dbHelper.query('movimientos', where: 'tipo = ?', whereArgs: ['ingreso']);
    return result.map((map) => Movimiento.fromMap(map)).toList();
  }

  // Obtener solo gastos
  Future<List<Movimiento>> obtenerGastos() async {
    final List<Map<String, dynamic>> result = await _dbHelper.query('movimientos', where: 'tipo = ?', whereArgs: ['gasto']);
    return result.map((map) => Movimiento.fromMap(map)).toList();
  }

  // Actualizar un movimiento
  Future<int> actualizarMovimiento(Movimiento movimiento) async {
    return await _dbHelper.update(
      'movimientos',
      movimiento.toMap(),
      'id = ?',
      [movimiento.id],
    );
  }

  // Eliminar un movimiento
  Future<int> eliminarMovimiento(int id) async {
    return await _dbHelper.delete(
      'movimientos',
      'id = ?',
      [id],
    );
  }

  Future<Movimiento?> obtenerMovimientoPorId(int id) async {
    final List<Map<String, dynamic>> maps = await _dbHelper.query(
      'movimientos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movimiento.fromMap(maps.first);
    }
    return null;
  }
}