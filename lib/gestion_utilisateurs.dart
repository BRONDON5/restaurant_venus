import 'package:flutter/material.dart';

class GestionUtilisateursPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Liste des utilisateurs', style: TextStyle(fontSize: 20)),
            // Ici, vous afficherez la liste des utilisateurs avec les options pour ajouter, modifier et supprimer
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers la page d'ajout d'utilisateur
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
