import 'package:flutter/material.dart';

class GestionCommandesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des commandes'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Liste des commandes', style: TextStyle(fontSize: 20)),
            // Afficher la liste des commandes et permettre la mise à jour de leur statut
          ],
        ),
      ),
    );
  }
}
