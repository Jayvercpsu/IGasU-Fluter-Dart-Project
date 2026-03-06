import 'package:flutter/foundation.dart';

import 'gas_law_content.dart';

class LearningStats extends ChangeNotifier {
  LearningStats._();

  static final LearningStats instance = LearningStats._();

  int _totalAttempts = 0;
  int _correctAnswers = 0;
  final List<double> _averageHistory = <double>[];
  final Map<GasLawType, int> _attemptsByTopic = <GasLawType, int>{
    GasLawType.boyle: 0,
    GasLawType.charles: 0,
  };
  final Map<GasLawType, int> _correctByTopic = <GasLawType, int>{
    GasLawType.boyle: 0,
    GasLawType.charles: 0,
  };

  int get totalAttempts => _totalAttempts;
  int get correctAnswers => _correctAnswers;
  int get averageScore => _totalAttempts == 0
      ? 0
      : ((_correctAnswers / _totalAttempts) * 100).round();

  List<double> get averageHistory {
    if (_averageHistory.isEmpty) {
      return const <double>[0];
    }
    return List<double>.unmodifiable(_averageHistory);
  }

  int attemptsFor(GasLawType type) => _attemptsByTopic[type] ?? 0;
  int correctFor(GasLawType type) => _correctByTopic[type] ?? 0;

  int accuracyFor(GasLawType type) {
    final attempts = attemptsFor(type);
    if (attempts == 0) {
      return 0;
    }
    return ((correctFor(type) / attempts) * 100).round();
  }

  bool get isPro => totalAttempts >= 5 && averageScore >= 80;

  void recordAttempt({required GasLawType type, required bool isCorrect}) {
    _totalAttempts += 1;
    _attemptsByTopic[type] = attemptsFor(type) + 1;

    if (isCorrect) {
      _correctAnswers += 1;
      _correctByTopic[type] = correctFor(type) + 1;
    }

    _averageHistory.add(averageScore.toDouble());
    notifyListeners();
  }
}
