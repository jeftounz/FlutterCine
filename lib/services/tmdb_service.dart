import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TMDbService extends ChangeNotifier {
  // Clave de API de TMDB. Reemplaza con tu propia clave.
  final String apiKey = '449a79e6936db938259c1bdb7d87fcd1';
  // URL base de la API de TMDB.
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Función para obtener películas populares.
  Future<List<dynamic>> getPopularMovies() async {
    // Construye la URL para la solicitud de películas populares.
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    // Realiza la solicitud GET a la API.
    final response = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON.
      final data = json.decode(response.body);
      // Retorna la lista de resultados de películas.
      return data['results'];
    } else {
      // Lanza una excepción si la solicitud falla.
      throw Exception('Error al cargar las películas');
    }
  }

  // Función para obtener detalles de una película.
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    // Construye la URL para la solicitud de detalles de la película.
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    // Realiza la solicitud GET a la API.
    final response = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200) {
      // Decodifica y retorna la respuesta JSON.
      return json.decode(response.body);
    } else {
      // Lanza una excepción si la solicitud falla.
      throw Exception('Error al cargar los detalles de la película');
    }
  }

  // Función para obtener créditos de una película (actores).
  Future<List<dynamic>> getMovieCredits(int movieId) async {
    // Construye la URL para la solicitud de créditos de la película.
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    // Realiza la solicitud GET a la API.
    final response = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON.
      final data = json.decode(response.body);
      // Retorna la lista de actores (cast).
      return data['cast'];
    } else {
      // Lanza una excepción si la solicitud falla.
      throw Exception('Error al cargar los créditos de la película');
    }
  }

  // Función para obtener detalles de un actor.
  Future<Map<String, dynamic>> getActorDetails(int actorId) async {
    // Construye la URL para la solicitud de detalles del actor.
    final url = Uri.parse('$baseUrl/person/$actorId?api_key=$apiKey');
    // Realiza la solicitud GET a la API.
    final response = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200) {
      // Decodifica y retorna la respuesta JSON.
      return json.decode(response.body);
    } else {
      // Lanza una excepción si la solicitud falla.
      throw Exception('Error al cargar los detalles del actor');
    }
  }

  // Función para obtener películas en las que ha participado un actor.
  Future<List<dynamic>> getActorMovies(int actorId) async {
    // Construye la URL para la solicitud de créditos de películas del actor.
    final url = Uri.parse(
      '$baseUrl/person/$actorId/movie_credits?api_key=$apiKey',
    );
    // Realiza la solicitud GET a la API.
    final response = await http.get(url);

    // Verifica si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON.
      final data = json.decode(response.body);
      // Retorna la lista de películas en las que ha participado el actor (cast).
      return data['cast'];
    } else {
      // Lanza una excepción si la solicitud falla.
      throw Exception('Error al cargar las películas del actor');
    }
  }
}
