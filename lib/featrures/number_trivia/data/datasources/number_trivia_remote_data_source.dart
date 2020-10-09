import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trivia/core/error/exception.dart';
import 'package:trivia/featrures/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({@required this.client});
  @override
  Future<NumberTriviaModel> getConcreNumberTrivia(int number) =>
    getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => 
    getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> getTriviaFromUrl(String url) async {
    final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
  }
}
