class Quiz {
  final String id, title, beaconUUID, color;
  final int rssi;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.beaconUUID,
    required this.rssi,
    required this.title,
    required this.questions,
    required this.color,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'],
      title: json['title'],
      beaconUUID: json['beacon'],
      rssi: json['rssi'],
      color: json['color'],
      questions: List<Question>.from(
          json['questions'].map((question) => Question.fromJson(question))),
    );
  }
}

class Question {
  final String text, color;
  final List<Option> options;

  Question({
    required this.text,
    required this.options,
    required this.color,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      color: json['color'],
      options: List<Option>.from(
          json['options'].map((option) => Option.fromJson(option))),
    );
  }
}

class Option {
  final String awnser;
  final bool isCorrect;

  Option({
    required this.awnser,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      awnser: json['answer'],
      isCorrect: json['isCorrect'],
    );
  }
}
