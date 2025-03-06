import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/views/pages/nuevo_movimiento/nuevo_movimiento_provider.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:finanzaspersonales/util/constants.dart';
import 'package:finanzaspersonales/util/date_helper.dart';
import 'package:finanzaspersonales/views/widgets/custom_appbar.dart';
import 'package:finanzaspersonales/views/widgets/custom_dropdown_string.dart';
import 'package:finanzaspersonales/views/widgets/custom_textformfield.dart';
import 'package:finanzaspersonales/views/widgets/custom_textformfield_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuevoMovimientoPage extends StatefulWidget {
  final int? movimientoId;

  const NuevoMovimientoPage({super.key, this.movimientoId}); // Constructor que acepta un ID de movimiento opcional

  @override
  _NuevoMovimientoPageState createState() => _NuevoMovimientoPageState();
}

class _NuevoMovimientoPageState extends State<NuevoMovimientoPage> {
  final _formKey = GlobalKey<FormState>();
  //String _tipo = 'ingreso';
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  // Definimos un ValueNotifier para el campo _tipo
  final ValueNotifier<String> _tipoNotifier = ValueNotifier<String>('ingreso'); // Valor por defecto
  final ValueNotifier<String> _fechaNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  void _inicializar(){
    // carga de datos en el formulario
    if (widget.movimientoId != null) {
      _cargarMovimiento(widget.movimientoId!);
    } else {
      _limpiarMovimiento();
    }
    // eventos
    _fechaController.addListener((){
      _fechaNotifier.value = _fechaController.text;
    });
  }

  void _limpiarMovimiento() async{
    final nuevoMovimientoProvider = Provider.of<NuevoMovimientoProvider>(context, listen: false);
    nuevoMovimientoProvider.limpiarMovimiento();
  }

  void _cargarMovimiento(int id) async {
    final nuevoMovimientoProvider = Provider.of<NuevoMovimientoProvider>(context, listen: false);
    try {
      await nuevoMovimientoProvider.cargarMovimiento(id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el movimiento: $error')),
      );
    }
  }

  Widget _widgetTextFieldDescription(){
    return CustomTextFormField(
        controller: _descripcionController,
        labelText: "Descripción",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese una descripción';
          }
          return null;
        },
    );
  }

  Widget _widgetTextFieldMonto(){
    return CustomTextFormField(
      controller: _montoController,
      labelText: "Monto",
      inputType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese un monto';
        }
        return null;
      },
    );
  }

  Widget _widgetTextFieldFecha(){
    return ValueListenableBuilder<String>(
      valueListenable: _fechaNotifier,
      builder: (context, value, child){
        return CustomTextFormFieldDate(
            controller: _fechaController,
            labelText: "Fecha",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, seleccione una fecha';
              }
              return null;
            }
        );
      },
    );
  }

  Widget _widgetDropdownTipoMovimiento(){
    return ValueListenableBuilder(
      valueListenable: _tipoNotifier,
      builder: (context, value, child){
        return CustomDropdownString(
            labelText: "Tipo de movimiento",
            value: _tipoNotifier.value,
            items: [
              DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
              DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
            ],
            onChanged: (value){
              if(value!=null){
                _tipoNotifier.value = value;
              }
            });
      },
    );
  }

  Widget _widgetButtonSave(){
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          _guardarMovimiento(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text(
        widget.movimientoId == null ?
        'Registrar' : 'Actualizar',
        style: TextStyle(
            color: Colors.white
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.movimientoId == null ?
          'Registrar Movimiento' : 'Editar Movimiento'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<NuevoMovimientoProvider>(
          builder: (context, provider, child){
            return _widgetForm(provider);
          },
        ),
      ),
    );
  }

  Widget _widgetForm(NuevoMovimientoProvider provider){
    // Aquí se obtienen los valores del movimiento si ya se ha cargado
    final movimiento = provider.movimiento;
    if (movimiento != null) {
      _descripcionController.text = movimiento.descripcion;
      _montoController.text = movimiento.cantidad.toString();
      _tipoNotifier.value = movimiento.tipo;
      _fechaController.text = DateHelper.formatearDesdeDatabase(movimiento.fecha);
    }
    else{
      _descripcionController.clear();
      _montoController.clear();
      _tipoNotifier.value = "ingreso";
      _fechaController.text = DateHelper.formatearDesdeDatabase(DateTime.now().toIso8601String());
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _widgetTextFieldDescription(),
            SizedBox(height: defaultSpacing),
            _widgetTextFieldMonto(),
            SizedBox(height: defaultSpacing),
            _widgetTextFieldFecha(),
            SizedBox(height: defaultSpacing),
            _widgetDropdownTipoMovimiento(),
            SizedBox(height: defaultSpacing),
            // Botón de Registro/Actualización
            SizedBox(
                width: double.infinity,
                child: _widgetButtonSave()
            ),
          ],
        ),
      ),
    );
  }

  void _guardarMovimiento(BuildContext context) async {
    final nuevoMovimientoProvider = Provider.of<NuevoMovimientoProvider>(context, listen: false);
    final movimiento = Movimiento(
      id: widget.movimientoId,
      descripcion: _descripcionController.text,
      cantidad: double.tryParse(_montoController.text) ?? 0.0,
      fecha: DateHelper.convertirADatabase(_fechaController.text),
      tipo: _tipoNotifier.value,
    );
    try {
      if (widget.movimientoId == null) {
        await nuevoMovimientoProvider.registrarMovimiento(movimiento);
      } else {
        await nuevoMovimientoProvider.actualizarMovimiento(movimiento);
      }
      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar/actualizar el movimiento: $error')),
      );
    }
  }
}