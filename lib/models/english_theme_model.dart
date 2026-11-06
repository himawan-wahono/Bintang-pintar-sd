class EnglishTopic {
  final String id;
  final String title;
  final String description;
  final String summaryContent;
  final List<String> keyPhrases;
  final String exampleSentence;
  final String exampleTranslation;

  const EnglishTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.summaryContent,
    required this.keyPhrases,
    required this.exampleSentence,
    required this.exampleTranslation,
  });
}

class EnglishTheme {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final String themeColorHex;
  final List<EnglishTopic> topics;

  const EnglishTheme({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.themeColorHex,
    required this.topics,
  });
}
