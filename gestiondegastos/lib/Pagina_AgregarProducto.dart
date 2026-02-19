import 'package:flutter/material.dart';

class PaginaAgregarProducto extends StatefulWidget {
  const PaginaAgregarProducto({super.key});

  @override
  State<PaginaAgregarProducto> createState() => _PaginaAgregarProductoState();
}

class _PaginaAgregarProductoState extends State<PaginaAgregarProducto> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  DateTime? _selectedDate;

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

  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );

    if (picked == null) return;

    setState(() => _selectedDate = picked);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _save() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Selecciona una fecha.")));
      return;
    }

    final newExpense = <String, dynamic>{
      "title": _titleCtrl.text.trim(),
      "amount": double.parse(_amountCtrl.text.trim()),
      "icon": _selectedOption["icon"],
      "date": _formatDate(_selectedDate!),
    };

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
                  if (val <= 0) return "Debe ser mayor a 0.";
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
                label: Text(
                  _selectedDate == null
                      ? "Seleccionar fecha"
                      : "Fecha: ${_formatDate(_selectedDate!)}",
                ),
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
