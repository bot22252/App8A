import 'package:flutter/material.dart';
import 'Pagina_AgregarProducto.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {

  final List<Map<String, dynamic>> expenses = [];

  double get _totalGastos {
    return expenses.fold(0, (sum, item) => sum + item["amount"]);
  }

  Map<IconData, double> get _gastosPorCategoria {
    final Map<IconData, double> datos = {};

    for (var expense in expenses) {
      final IconData icon = expense["icon"];
      final double amount = expense["amount"];

      if (datos.containsKey(icon)) {
        datos[icon] = datos[icon]! + amount;
      } else {
        datos[icon] = amount;
      }
    }

    return datos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 147, 175, 216),
      appBar: AppBar(
        title: const Text("Control Gastos Flutter"),
        backgroundColor: const Color.fromARGB(255, 56, 34, 109),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildVerticalLayout();
          } else {
            return _buildHorizontalLayout();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[700],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final nuevoGasto = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaginaAgregarProducto(),
            ),
          );

          if (nuevoGasto != null) {
            setState(() {
              expenses.add(nuevoGasto);
            });
          }
        },
      ),
    );
  }

  // ================= LAYOUT VERTICAL =================
  Widget _buildVerticalLayout() {
    return Column(
      children: [
        _buildGrafica(),
        Expanded(child: _buildLista()),
      ],
    );
  }

  // ================= LAYOUT HORIZONTAL =================
  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildGrafica()),
        Expanded(flex: 2, child: _buildLista()),
      ],
    );
  }

  // ================= GRAFICA =================
  Widget _buildGrafica() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(12),
          child: expenses.isEmpty
              ? const Center(
                  child: Text(
                    "No hay gastos registrados",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _gastosPorCategoria.entries.map((entry) {
                    final icon = entry.key;
                    final amount = entry.value;

                    double alturaMaxima = 100;
                    double altura = (_totalGastos == 0)
                        ? 0
                        : (amount / _totalGastos) * alturaMaxima;

                    if (altura < 8) altura = 8;

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "\$${amount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: altura,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Icon(icon, size: 18),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  // ================= LISTA =================
  Widget _buildLista() {

    
    final gastosOrdenados = [...expenses];
    gastosOrdenados.sort(
      (a, b) => (b["date"] as DateTime)
          .compareTo(a["date"] as DateTime),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: expenses.isEmpty
            ? const Center(
                child: Text(
                  "Aún no has agregado gastos",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: gastosOrdenados.length,
                itemBuilder: (context, index) {
                  final expense = gastosOrdenados[index];

                  return ListTile(
                    onTap: () async {
                      final gastoEditado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaginaAgregarProducto(
                                gastoExistente: expense,
                              ),
                        ),
                      );

                      if (gastoEditado != null) {
                        setState(() {
                          final indexOriginal =
                              expenses.indexOf(expense);
                          expenses[indexOriginal] = gastoEditado;
                        });
                      }
                    },
                    leading: Icon(
                      expense["icon"],
                      color: Colors.deepPurple,
                    ),
                    title: Text(expense["title"]),
                    subtitle: Text(
                      "${expense["date"].day}/${expense["date"].month}/${expense["date"].year}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${expense["amount"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              expenses.remove(expense);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}