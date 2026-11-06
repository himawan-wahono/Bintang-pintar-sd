class Question {
  final String id;
  final String gradeLevel; // 'SD', 'SMP', or 'Umum'
  final int classNum; // 1-9
  final String subject; // 'Matematika', etc.
  final String topic;
  final String level; // 'Dasar', 'Sedang', 'HOTS' 🟢 🟡 🔴
  final String questionText;
  final String? imageUrl; // Optional URL or asset path for image-based questions 🖼️
  final String? visualType; // 'fraction_pie', 'analog_clock', 'shape_rectangle', 'shape_triangle', 'shape_cylinder'
  final Map<String, dynamic>? visualData; // Parameters for dynamic vector rendering
  final String? visualLabel; // Optional caption label
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final bool isCustom; // Custom question created by parent/teacher

  Question({
    required this.id,
    required this.gradeLevel,
    required this.classNum,
    required this.subject,
    required this.topic,
    this.level = 'Dasar',
    required this.questionText,
    this.imageUrl,
    this.visualType,
    this.visualData,
    this.visualLabel,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gradeLevel': gradeLevel,
      'classNum': classNum,
      'subject': subject,
      'topic': topic,
      'level': level,
      'questionText': questionText,
      'imageUrl': imageUrl,
      'visualType': visualType,
      'visualData': visualData,
      'visualLabel': visualLabel,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'isCustom': isCustom,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      gradeLevel: json['gradeLevel'] ?? 'SD',
      classNum: json['classNum'] ?? 1,
      subject: json['subject'] ?? 'Matematika',
      topic: json['topic'] ?? 'Umum',
      level: json['level'] ?? 'Dasar',
      questionText: json['questionText'] ?? '',
      imageUrl: json['imageUrl'],
      visualType: json['visualType'],
      visualData: json['visualData'] != null ? Map<String, dynamic>.from(json['visualData']) : null,
      visualLabel: json['visualLabel'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      isCustom: json['isCustom'] ?? false,
    );
  }
}
