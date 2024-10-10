import 'package:flutter/material.dart';
import 'confirmation_commande_page.dart'; // Importer la nouvelle page de confirmation

class PanierPage extends StatefulWidget {
  final List<Map<String, dynamic>>
      panier; // Récupérer la liste d'articles dans le panier

  PanierPage({required this.panier});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Votre Panier'),
        backgroundColor: const Color.fromARGB(255, 146, 183, 58),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors
                  .white, // Rendre l'icône blanche pour plus de visibilité
            ),
            onPressed: () {
              // Action de l'icône de panier (si nécessaire)
            },
          ),
        ],
      ),
      body: widget.panier.isEmpty
          ? Center(
              child: Text(
                'Votre panier est vide.',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.panier.length,
                    itemBuilder: (context, index) {
                      final menu = widget.panier[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            menu['imageUrl'] ?? 'assets/default_image.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(menu['title'] ?? 'Sans titre'),
                          subtitle: Text('Prix: ${menu['price']} Fcfa'),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              _retirerDuPanier(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total : ${_calculerTotal()} Fcfa',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: widget.panier.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConfirmationCommandePage(
                                      panier: widget.panier,
                                      total: _calculerTotal().toDouble(),
                                    ),
                                  ),
                                );
                              }
                            : null, // Désactive si le panier est vide
                        child: Text('Passer à la Caisse'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6A1B9A), // Couleur du bouton
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Fonction pour retirer un article du panier
  void _retirerDuPanier(int index) {
    setState(() {
      widget.panier.removeAt(index); // Retirer l'article à l'index donné
    });

    // Message d'information pour confirmer la suppression
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Article retiré du panier.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Fonction pour calculer le total du panier
  int _calculerTotal() {
    int total = 0;
    for (var menu in widget.panier) {
      total += int.parse(menu['price']);
    }
    return total;
  }
}
