import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/repositories/movimiento_api_repository.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:flutter/material.dart';

class NuevoMovimientoProvider with ChangeNotifier {

  final MovimientoRepository _movimientoRepository = MovimientoRepository();
  //final MovimientoApiRepository _movimientoRepository = MovimientoApiRepository();

  Movimiento? _movimiento;
  Movimiento? get movimiento => _movimiento;

  // Método para registrar un nuevo movimiento
  Future<void> registrarMovimiento(Movimiento movimiento) async {
    try {
      await _movimientoRepository.insertarMovimiento(movimiento); // Llama al método del repositorio
      notifyListeners(); // Notificar a la UI si es necesario
    } catch (error) {
      throw error;
    }
  }

  Future<void> actualizarMovimiento(Movimiento movimiento) async {
    try {
      await _movimientoRepository.actualizarMovimiento(movimiento);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> cargarMovimiento(int id) async {
    try {
      _movimiento = await _movimientoRepository.obtenerMovimientoPorId(id);
      notifyListeners(); // Notificar a los listeners cuando se cargue el movimiento
    } catch (error) {
      throw error;
    }
  }

  void limpiarMovimiento() {
    _movimiento = null;
    notifyListeners();  // Notificar que el movimiento ha sido limpiado
  }
}