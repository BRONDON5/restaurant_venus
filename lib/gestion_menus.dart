import 'package:flutter/material.dart';

class GestionMenusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des menus'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Liste des menus', style: TextStyle(fontSize: 20)),
            // Afficher la liste des menus avec les options pour ajouter, modifier ou supprimer un élément du menu
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers la page d'ajout de menu
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
