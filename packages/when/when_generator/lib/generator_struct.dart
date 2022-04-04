class GeneratorStruct {
  final argumentList = <String>[];
  final conditionList = <String>[];
  final expressionList = <String>[];

  List<String> get blockList {
    return List.generate(
      expressionList.length,
      (i) {
        return '''if (${conditionList[i]}) {
          ${expressionList[i]}; 
        }''';
      },
    );
  }

  void push({required String argument, required String condition, required String expression}) {
    argumentList.add(argument);
    conditionList.add(condition);
    expressionList.add(expression);
  }
}
