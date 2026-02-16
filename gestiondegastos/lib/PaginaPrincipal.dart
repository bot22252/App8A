import 'package:flutter/material.dart';

class PaginaPrincipal extends StatelessWidget {
  final List<Map<String, dynamic>> expenses = [
    {"title": "Curso Dart", "amount": 199.90, "icon": Icons.work, "date": "2/10/2026"},
    {"title": "Cine", "amount": 200.00, "icon": Icons.movie, "date": "2/10/2026"},
    {"title": "Mi Viaje", "amount": 234.00, "icon": Icons.flight, "date": "2/3/2026"},
    {"title": "Viaje Nuevo", "amount": 10000.00, "icon": Icons.flight, "date": "2/2/2026"},
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 175, 216), 
      appBar: AppBar(
        title: Text("Control Gastos Flutter"),
        backgroundColor: Color.fromARGB(255, 56, 34, 109), 
      ),
      body: Column(
        children: [
        
          Container(
            height: 150,
            color: Color.fromARGB(255, 147, 175, 216),
            child: Center(
              child: Text(
                "Aquí iría el gráfico de gastos",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(expense["icon"], color: Colors.black),
                    title: Text(expense["title"], style: TextStyle(color: Colors.black)),
                    subtitle: Text(expense["date"], style: TextStyle(color: Colors.black54)),
                    trailing: Text(
                      "\$${expense["amount"]}",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[700],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Agregar nueva opción")),
          );
        },
      ),
    );
  }
}
