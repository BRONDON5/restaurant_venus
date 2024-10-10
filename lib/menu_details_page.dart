import 'package:flutter/material.dart';
import 'panier_page.dart';

class MenuDetailsPage extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String restaurant;
  final String locality;
  final String imageUrl;
  final List<Map<String, dynamic>> similarMenus;
  final List<Map<String, dynamic>> panier; // Récupérer le panier

  MenuDetailsPage({
    required this.title,
    required this.description,
    required this.price,
    required this.restaurant,
    required this.locality,
    required this.imageUrl,
    required this.similarMenus,
    required this.panier,
  });

  @override
  _MenuDetailsPageState createState() => _MenuDetailsPageState();
}

class _MenuDetailsPageState extends State<MenuDetailsPage> {
  List<Map<String, dynamic>> reviews = []; // Liste des avis
  double averageRating = 0.0; // Moyenne des notes

  // Fonction pour calculer la moyenne des notes
  void _calculateAverageRating() {
    if (reviews.isNotEmpty) {
      double totalRating = reviews.fold(0, (sum, item) => sum + item['rating']);
      setState(() {
        averageRating = totalRating / reviews.length;
      });
    }
  }

  // Fonction pour ajouter un avis
  void _addReview(String reviewText, double rating) {
    setState(() {
      reviews.add({'review': reviewText, 'rating': rating});
      _calculateAverageRating();
    });
  }

  // Fonction pour ajouter un menu au panier
  void _ajouterAuPanier(BuildContext context, Map<String, dynamic> menu) {
    widget.panier.add(menu);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanierPage(panier: widget.panier),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Image.asset(widget.imageUrl, height: 250, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(widget.description),
                SizedBox(height: 10),
                Text('Prix: ${widget.price} Fcfa',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Restaurant: ${widget.restaurant}'),
                SizedBox(height: 5),
                Text('Localité: ${widget.locality}'),
                SizedBox(height: 20),
                Text(
                  'Note moyenne : ${averageRating.toStringAsFixed(1)} / 5',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildReviewSection(),
                SizedBox(height: 20),
                _buildAddReviewSection(),
                SizedBox(height: 20),
                Text(
                  'Menus Similaires',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.similarMenus.length,
                  itemBuilder: (context, index) {
                    final similarMenu = widget.similarMenus[index];
                    return Card(
                      child: ListTile(
                        leading: Image.asset(similarMenu['imageUrl']),
                        title: Text(similarMenu['title']),
                        subtitle: Text('Prix: ${similarMenu['price']} Fcfa'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _ajouterAuPanier(context, similarMenu);
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuDetailsPage(
                                title: similarMenu['title'],
                                description: similarMenu['description'],
                                price: similarMenu['price'],
                                restaurant: widget.restaurant,
                                locality: widget.locality,
                                imageUrl: similarMenu['imageUrl'],
                                similarMenus: widget.similarMenus,
                                panier: widget.panier,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section pour afficher les avis
  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avis des clients',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (reviews.isNotEmpty)
          ...reviews.map((review) {
            return ListTile(
              title: Text('Note : ${review['rating'].toString()} / 5'),
              subtitle: Text(review['review']),
            );
          }).toList(),
        if (reviews.isEmpty)
          Text(
              'Aucun avis pour le moment. Soyez le premier à donner un avis !'),
      ],
    );
  }

  // Section pour ajouter un avis
  Widget _buildAddReviewSection() {
    final TextEditingController _reviewController = TextEditingController();
    double _rating = 3.0; // Note par défaut

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajouter un avis',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _reviewController,
          decoration: InputDecoration(
            labelText: 'Votre avis',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Text('Votre note : $_rating / 5'),
        Slider(
          value: _rating,
          min: 1,
          max: 5,
          divisions: 4,
          label: _rating.toString(),
          onChanged: (value) {
            setState(() {
              _rating = value;
            });
          },
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_reviewController.text.isNotEmpty) {
              _addReview(_reviewController.text, _rating);
              _reviewController.clear();
            }
          },
          child: Text('Soumettre'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
