import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TMDbService extends ChangeNotifier {
  final String apiKey = '449a79e6936db938259c1bdb7d87fcd1'; //  API Key de TMDB
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Obtener películas populares
  Future<List<dynamic>> getPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al cargar las películas');
    }
  }

  // Obtener detalles de una película
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los detalles de la película');
    }
  }

  // Obtener créditos de una película (actores)
  Future<List<dynamic>> getMovieCredits(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Error al cargar los créditos de la película');
    }
  }

  // Obtener detalles de un actor
  Future<Map<String, dynamic>> getActorDetails(int actorId) async {
    final url = Uri.parse('$baseUrl/person/$actorId?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los detalles del actor');
    }
  }

  // Obtener películas en las que ha participado un actor
  Future<List<dynamic>> getActorMovies(int actorId) async {
    final url = Uri.parse(
      '$baseUrl/person/$actorId/movie_credits?api_key=$apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Error al cargar las películas del actor');
    }
  }
}
