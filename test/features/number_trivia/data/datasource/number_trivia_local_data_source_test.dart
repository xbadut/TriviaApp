import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/core/error/exception.dart';
import 'package:trivia/featrures/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/featrures/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixture/fixture_reader.dart';

class MockSharedPreferences extends Mock
  implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
  
    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(any))
      .thenReturn(fixture('trivia_cached.json'));

    final result = await datasource.getLastNumberTrivia();

    verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
    expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = datasource.getLastNumberTrivia();

      // ignore: deprecated_member_use
      expect(() => call, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: 1);

    test('should call SharedPreferences to cache the data', () async {
      datasource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel);

      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}