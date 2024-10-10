import 'package:flutter/material.dart';

class ConfirmationCommandePage extends StatefulWidget {
  final List<Map<String, dynamic>> panier; // Les éléments du panier
  final double total; // Le total de la commande

  ConfirmationCommandePage({required this.panier, required this.total});

  @override
  _ConfirmationCommandePageState createState() =>
      _ConfirmationCommandePageState();
}

class _ConfirmationCommandePageState extends State<ConfirmationCommandePage> {
  String _selectedOption = 'Livraison'; // Option par défaut
  String _selectedDeliveryMethod = 'Moto'; // Moyen de livraison par défaut
  String _deliveryAddress = 'Aucune adresse ajoutée'; // Adresse par défaut
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _confirmerCommande() {
    String message = _selectedOption == 'Livraison'
        ? 'Votre commande sera livrée à l\'adresse suivante : $_deliveryAddress.'
        : 'Votre commande a été réservée. Vous pouvez venir la récupérer au restaurant.';

    String messageLivreur = _messageController.text.isNotEmpty
        ? 'Message pour le livreur : ${_messageController.text}'
        : 'Aucun message pour le livreur.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message\n$messageLivreur')),
    );

    // Ajouter la logique pour enregistrer la commande et rediriger l'utilisateur
  }

  void _ajouterAdresseLivraison() {
    setState(() {
      _deliveryAddress = _addressController.text.isNotEmpty
          ? _addressController.text
          : 'Aucune adresse ajoutée';
    });
    Navigator.pop(context); // Ferme la boîte de dialogue après l'ajout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation de commande'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de la commande:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.panier.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: widget.panier[index]['imageUrl'] != null
                          ? Image.network(
                              widget.panier[index]['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image, size: 50),
                      title:
                          Text(widget.panier[index]['title'] ?? 'Sans titre'),
                      subtitle: Text('${widget.panier[index]['price']} FCFA'),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Total: ${widget.total} FCFA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Affichage et ajout de l'adresse de livraison
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Adresse de livraison : $_deliveryAddress',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_location),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Ajouter une adresse de livraison'),
                          content: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Entrer l\'adresse de livraison',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: _ajouterAdresseLivraison,
                              child: Text('Ajouter'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Sélection des moyens de livraison
            Text(
              'Moyen de livraison:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _selectedDeliveryMethod,
              items: [
                DropdownMenuItem(child: Text('Moto'), value: 'Moto'),
                DropdownMenuItem(child: Text('Voiture'), value: 'Voiture'),
                DropdownMenuItem(
                    child: Text('Camionnette'), value: 'Camionnette'),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDeliveryMethod = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            // Champ pour le message du livreur
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message ou recommandation pour le livreur',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmerCommande,
              child: Text('Confirmer la commande'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
