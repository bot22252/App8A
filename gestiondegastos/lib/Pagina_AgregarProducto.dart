import 'package:flutter/material.dart';

class PaginaAgregarProducto extends StatefulWidget {
  const PaginaAgregarProducto({super.key});

  @override
  State<PaginaAgregarProducto> createState() => _PaginaAgregarProductoState();
}

class _PaginaAgregarProductoState extends State<PaginaAgregarProducto> {
  // Control del formulario (para validar después)
  final _formKey = GlobalKey<FormState>();

  // Campos del formulario
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  // “Categorías” (mismas del equipo, por ícono)
  final List<Map<String, dynamic>> _options = const [
    {"label": "Trabajo / Curso", "icon": Icons.work},
    {"label": "Cine", "icon": Icons.movie},
    {"label": "Viaje", "icon": Icons.flight},
  ];

  late Map<String, dynamic> _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = _options[0];
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  // Placeholder: en commit 2 aquí irá el DatePicker
  void _pickDate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pendiente: seleccionar fecha")),
    );
  }

  // Placeholder: cancelar sí puede cerrar desde el commit 1
  void _cancel() {
    Navigator.pop(context);
  }

  // Placeholder: en commit 2 aquí irá el guardado real
  void _save() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Pendiente: guardar gasto")));
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                  return null;
                },
              ),
              const SizedBox(height: 12),

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

              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: const Text("Seleccionar fecha"),
              ),
              const SizedBox(height: 16),

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
