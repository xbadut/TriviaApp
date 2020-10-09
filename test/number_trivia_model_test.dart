import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/featrures/number_trivia/data/models/number_trivia_model.dart';
import 'fixture/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should return a valid model when the JSON number is an integer',
      () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

    final result = NumberTriviaModel.fromJson(jsonMap);

    expect(result, tNumberTriviaModel);
  });

  group("toJson", () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final expectedJsonMap = {
        "text": "Test Text",
        "number": 1,
      };

      expect(result, expectedJsonMap);
    });
  });
}
