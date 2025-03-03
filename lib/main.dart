import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/tmdb_service.dart';
import 'screens/feed_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TMDbService())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movies',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FeedScreen(),
    );
  }
}
