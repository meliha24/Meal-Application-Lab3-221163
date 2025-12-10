// lib/main.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';
import 'firebase/my_firebase_messaging_service.dart';
import 'models/favorite_meal.dart';
import 'providers/favorites_provider.dart';
import 'providers/meals_provider.dart';
import 'screens/tabs_screen.dart';
import 'screens/meal_detail_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();



tz.TZDateTime _nextInstanceOf10AM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
  tz.TZDateTime(tz.local, now.year, now.month, now.day, 10, 0);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  return scheduledDate;
}


Future<void> scheduleDailyNotification() async {
  final recipes = [
    "Chicken Alfredo",
    "Greek Salad",
    "Tortilla Wrap",
    "Sushi Rolls",
    "Oven Baked Salmon",
    "Mediterranean Pasta",
    "Avocado Toast",
  ];
  final random = Random();
  final recipe = recipes[random.nextInt(recipes.length)];

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Recipe of the Day',
    recipe,
    _nextInstanceOf10AM(),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_recipe_channel',
        'Daily Recipes',
        channelDescription: 'Daily reminder for a random recipe', // Додаден description
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await MyFirebaseMessagingService.initializeNotifications();


  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..loadFavorites()),
        ChangeNotifierProvider(create: (_) => MealsProvider()),
      ],
      child: const MyApp(),
    ),
  );

  Future.delayed(const Duration(seconds: 1), () {
    scheduleDailyNotification();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const TabsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/meal-detail') {
          final meal = settings.arguments as FavoriteMeal;
          return MaterialPageRoute(
            builder: (context) => MealDetailScreen(meal: meal),
          );
        }
        return null;
      },
    );
  }
}