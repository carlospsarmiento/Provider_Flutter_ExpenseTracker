import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/repositories/movimiento_api_repository.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:flutter/material.dart';

class NuevoMovimientoProvider with ChangeNotifier {

  final MovimientoRepository _movimientoRepository = MovimientoRepository();
  //final MovimientoApiRepository _movimientoRepository = MovimientoApiRepository();

  // Método para registrar un nuevo movimiento
  Future<void> registrarMovimiento(Movimiento movimiento) async {
    try {
      await _movimientoRepository.insertarMovimiento(movimiento); // Llama al método del repositorio

      notifyListeners(); // Notificar a la UI si es necesario
    } catch (error) {
      // Manejo de errores, podrías lanzar una excepción o mostrar un mensaje
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

  Future<Movimiento?> obtenerMovimientoPorId(int id) async {
    try {
      return await _movimientoRepository.obtenerMovimientoPorId(id);
    } catch (error) {
      throw error;
    }
  }
}