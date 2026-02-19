import 'package:flutter/material.dart';

// Esta pantalla es para agregar un gasto desde un formulario.
// Al guardar, regresa un Map con el mismo formato que usa la pantalla principal:
// {"title": ..., "amount": ..., "icon": ..., "date": ...}
class PaginaAgregarProducto extends StatefulWidget {
  const PaginaAgregarProducto({super.key});

  @override
  State<PaginaAgregarProducto> createState() => _PaginaAgregarProductoState();
}

class _PaginaAgregarProductoState extends State<PaginaAgregarProducto> {
  // Key del formulario: me sirve para validar todos los campos con validate()
  final _formKey = GlobalKey<FormState>();

  // Controladores para leer lo que escriba el usuario en los campos
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  // Aquí guardo la fecha que el usuario selecciona (al inicio es null)
  DateTime? _selectedDate;

  // Opciones del dropdown. Uso iconos porque así lo maneja mi pantalla principal.
  final List<Map<String, dynamic>> _options = const [
    {"label": "Trabajo / Curso", "icon": Icons.work},
    {"label": "Cine", "icon": Icons.movie},
    {"label": "Viaje", "icon": Icons.flight},
  ];

  // La opción seleccionada del dropdown
  late Map<String, dynamic> _selectedOption;

  @override
  void initState() {
    super.initState();
    // Dejo seleccionada la primera opción por defecto
    _selectedOption = _options[0];
  }

  @override
  void dispose() {
    // Importante: libero los controladores para evitar fugas de memoria
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  // Convierto la fecha a texto en formato d/m/yyyy para mostrarlo y guardarlo
  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";

  // Abre el calendario para elegir una fecha y la guardo en _selectedDate
  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );

    // Si el usuario cancela, no hago nada
    if (picked == null) return;

    // setState para que se actualice el texto del botón con la fecha elegida
    setState(() => _selectedDate = picked);
  }

  // Cancela y regresa a la pantalla anterior sin devolver datos
  void _cancel() {
    Navigator.pop(context);
  }

  // Valido, armo el gasto y lo regreso a la pantalla principal
  void _save() {
    // Primero valido los campos del formulario
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    // La fecha no está en un TextFormField, por eso la valido aquí
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Selecciona una fecha.")));
      return;
    }

    // Creo el Map con el mismo formato que ya usa la lista principal
    final newExpense = <String, dynamic>{
      "title": _titleCtrl.text.trim(),
      "amount": double.parse(_amountCtrl.text.trim()),
      "icon":
          _selectedOption["icon"], // este icono se usa en el ListTile leading
      "date": _formatDate(_selectedDate!), // aquí ya sé que no es null
    };

    // Cierro la pantalla y regreso el Map para que la pantalla principal lo agregue
    Navigator.pop(context, newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar gasto"),
        backgroundColor: const Color.fromARGB(255, 56, 34, 109),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Form agrupa los campos y me permite validar todo con _formKey
        child: Form(
          key: _formKey,
          // ListView evita overflow y permite scroll si el teclado tapa algo
          child: ListView(
            children: [
              // Campo de título
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = (v ?? "").trim();
                  if (t.isEmpty) return "Escribe un título.";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Campo de monto
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Monto",
                  prefixText: "\$ ",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = (v ?? "").trim();
                  final val = double.tryParse(t);
                  if (t.isEmpty) return "Escribe un monto.";
                  if (val == null) return "Monto inválido.";
                  if (val <= 0) return "Debe ser mayor a 0.";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Dropdown para elegir el tipo
              DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedOption,
                decoration: const InputDecoration(
                  labelText: "Tipo",
                  border: OutlineInputBorder(),
                ),
                items: _options
                    .map(
                      (opt) => DropdownMenuItem<Map<String, dynamic>>(
                        value: opt,
                        child: Text(opt["label"] as String),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _selectedOption = v);
                },
              ),
              const SizedBox(height: 12),

              // Botón para seleccionar fecha
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  _selectedDate == null
                      ? "Seleccionar fecha"
                      : "Fecha: ${_formatDate(_selectedDate!)}",
                ),
              ),
              const SizedBox(height: 16),

              // Botones finales: cancelar / guardar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text("Guardar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
