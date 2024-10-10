import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String?
      selectedPaymentMethod; // Variable pour stocker la méthode de paiement sélectionnée

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode de paiement'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez votre mode de paiement :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Options de paiement
            _buildPaymentOption('Paiement à la livraison'),
            _buildPaymentOption('Paiement par Orange Money/MTN Mobile'),
            _buildPaymentOption('Paiement par carte bancaire'),
            Spacer(), // Pour espacer automatiquement les éléments
            // Bouton de confirmation de paiement
            ElevatedButton(
              onPressed: selectedPaymentMethod != null
                  ? _confirmPayment
                  : null, // Activer seulement si une méthode est sélectionnée
              child: Text('Confirmer le paiement'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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

  // Widget pour afficher les options de paiement avec un radio button
  Widget _buildPaymentOption(String paymentMethod) {
    return ListTile(
      title: Text(paymentMethod),
      leading: Radio<String>(
        value: paymentMethod, // Chaque radio button a une valeur unique
        groupValue: selectedPaymentMethod, // Gérer la valeur sélectionnée
        onChanged: (String? value) {
          setState(() {
            selectedPaymentMethod =
                value; // Mettre à jour la méthode de paiement sélectionnée
          });
        },
      ),
    );
  }

  // Méthode pour afficher une boîte de dialogue de confirmation de paiement
  void _confirmPayment() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Vous avez choisi : $selectedPaymentMethod.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                Navigator.of(context)
                    .pop(); // Retourner à la page précédente après confirmation
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
