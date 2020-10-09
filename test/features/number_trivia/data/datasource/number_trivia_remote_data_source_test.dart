import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:trivia/core/error/exception.dart';
import 'package:trivia/featrures/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/featrures/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixture/fixture_reader.dart';

class MockHtppClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl datasource;
  MockHtppClient mockHttpClient;
  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  setUp(() {
    mockHttpClient = MockHtppClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('header'))).thenAnswer((_) async=> http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHtppClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('header'))).thenAnswer((_) async=> http.Response('Something went wrong', 404));

  }

  group('getConcreteNumberTrivia', () {
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      setUpMockHttpClientSuccess200();
    });

    datasource.getConcreNumberTrivia(tNumber);

    verify(mockHttpClient.get(
      'http://numbersapi.com/$tNumber',
      headers: {'Content-Type': 'application/json'},
    ));
  });

  test('should return NumberTrivia when the response code is 200 (success)',
      () async {
    setUpMockHttpClientSuccess200();

    final result = await datasource.getConcreNumberTrivia(tNumber);

    expect(result, equals(tNumberTriviaModel));
  });

  test('should throw a ServerException when the response code is 404 or other',
      () async {
   setUpMockHtppClientFailure404();
  
    final call = datasource.getConcreNumberTrivia;

    // ignore: deprecated_member_use
    expect(call, throwsA(TypeMatcher<ServerException>()));
  });
}
