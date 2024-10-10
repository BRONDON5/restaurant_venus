import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize(BuildContext context) async {
    // Demander la permission de notification
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Permission de notification: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notifications autorisées');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message reçu en premier plan: ${message.notification?.title}');
        if (message.notification != null) {
          _showSnackBar(context,
              '${message.notification!.title}: ${message.notification!.body}');
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Notification ouverte: ${message.notification?.title}');
        // Ajouter des actions pour naviguer à une page spécifique
      });

      // Obtenez le token de l'appareil
      String? token = await _firebaseMessaging.getToken();
      print('Token Firebase Messaging: $token');
    } else {
      print('Notifications non autorisées');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
