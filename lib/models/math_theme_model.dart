class MathTopic {
  final String id;
  final String title;
  final String description;
  final String summaryContent;
  final List<String> keyFormulas;
  final String exampleProblem;
  final String exampleSolution;

  const MathTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.summaryContent,
    required this.keyFormulas,
    required this.exampleProblem,
    required this.exampleSolution,
  });
}

class MathTheme {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final String themeColorHex;
  final List<MathTopic> topics;

  const MathTheme({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.themeColorHex,
    required this.topics,
  });
}
