import 'package:flutter/material.dart';
import 'menu_details_page.dart';
import 'panier_page.dart';
import 'payment_page.dart'; // Importer la page de paiement

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Map<String, dynamic>> menus = [
    {
      'title': 'Menu du Jour',
      'description': 'Découvrez nos plats préparés avec des ingrédients frais.',
      'rating': 4.5,
      'price': '1500',
      'restaurant': 'Restaurant A',
      'locality': 'Mfandéna',
      'imageUrl': 'assets/menu_du_jour.jpg',
      'similar_menus': [
        {
          'title': 'Menu Spécial',
          'description': 'Un plat du jour unique.',
          'price': '1800',
          'imageUrl': 'assets/menu_special.jpg',
        },
        {
          'title': 'Menu Dégustation',
          'description': 'Un menu à partager.',
          'price': '2200',
          'imageUrl': 'assets/menu_deguster.jpg',
        },
      ],
    },
    {
      'title': 'Menu Végétarien',
      'description': 'Une sélection de plats savoureux sans viande.',
      'rating': 4.0,
      'price': '1200',
      'restaurant': 'Restaurant B',
      'locality': 'Etoug-Ebe',
      'imageUrl': 'assets/menu_vegetarien.jpg',
      'similar_menus': [
        {
          'title': 'Menu Veggie Delight',
          'description': 'Savourez nos plats à base de légumes frais.',
          'price': '500',
          'imageUrl': 'assets/menu_veggie.jpg',
        },
      ],
    },
    {
      'title': 'Menu Enfant',
      'description': 'Des plats adaptés pour les plus petits.',
      'rating': 4.8,
      'price': '500',
      'restaurant': 'Restaurant C',
      'locality': 'Elig-Essono',
      'imageUrl': 'assets/menu_enfant.jpg',
      'similar_menus': [
        {
          'title': 'Menu Mini Chef',
          'description': 'Des plats amusants pour les enfants.',
          'price': '1000',
          'imageUrl': 'assets/menu_mini_chef.jpg',
        },
        {
          'title': 'Menu Petit Gourmet',
          'description': 'Des recettes délicieuses et adaptées.',
          'price': '1000',
          'imageUrl': 'assets/menu_petit_gourmet.jpg',
        },
        {
          'title': 'Menu Bonbon',
          'description': 'Un menu sucré qui plaira aux enfants.',
          'price': '500',
          'imageUrl': 'assets/menu_bonbon.jpg',
        },
      ],
    },
  ];

  // Liste des articles dans le panier
  List<Map<String, dynamic>> panier = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu du Restaurant Venus'),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Icône de panier dans l'AppBar
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigue vers la page du panier lorsqu'on clique sur l'icône
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanierPage(
                      panier:
                          panier), // Passer les articles du panier à la page du panier
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];

          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    menu['imageUrl'] ?? 'assets/default_image.jpg',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 5),
                  Text(
                    menu['title'] ?? 'Titre non disponible',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    menu['description'] ?? 'Description non disponible',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text('Prix: ${menu['price']} Fcfa'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _ajouter_au_panier(menu);
                        },
                        child: Text('Ajouter au Panier'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _consulter_menu(context, menu);
                        },
                        child: Text('Voir Détails'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _ajouter_au_panier(Map<String, dynamic> menu) {
    setState(() {
      // Vérifier si le prix est valide et non nul
      if (menu.containsKey('price') &&
          menu['price'] != null &&
          menu['price'] != '') {
        panier.add(menu); // Ajoute le menu au panier
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${menu['title']} ajouté au panier'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Afficher un message d'erreur si le prix est manquant ou incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: Prix manquant pour ce menu.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _consulter_menu(BuildContext context, Map<String, dynamic> menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailsPage(
          title: menu['title'],
          description: menu['description'],
          price: menu['price'],
          restaurant: menu['restaurant'],
          locality: menu['locality'],
          imageUrl: menu['imageUrl'] ?? 'assets/default_image.jpg',
          similarMenus: menu['similar_menus'],
          panier: panier, // Passe le panier pour gérer les similar_menus
        ),
      ),
    );
  }
}
