import 'package:flutter/material.dart';

enum GasLawType { boyle, charles }

extension GasLawTypePresentation on GasLawType {
  String get label {
    switch (this) {
      case GasLawType.boyle:
        return 'Boyle\'s Law';
      case GasLawType.charles:
        return 'Charles\' Law';
    }
  }

  String get formula {
    switch (this) {
      case GasLawType.boyle:
        return 'P1V1 = P2V2';
      case GasLawType.charles:
        return 'V₁/T₁ = V₂/T₂';
    }
  }

  Color get color {
    switch (this) {
      case GasLawType.boyle:
        return const Color(0xFF4A90E2);
      case GasLawType.charles:
        return const Color(0xFF5CB85C);
    }
  }

  String get shortDescription {
    switch (this) {
      case GasLawType.boyle:
        return 'Pressure and volume are inversely proportional at constant temperature.';
      case GasLawType.charles:
        return 'Volume and temperature are directly proportional at constant pressure.';
    }
  }
}

class TutorialLesson {
  const TutorialLesson({
    required this.type,
    required this.header,
    required this.description,
    required this.welcomeLine,
    required this.lessonSummary,
    required this.exampleQuestion,
    required this.exampleSteps,
    required this.finalAnswer,
  });

  final GasLawType type;
  final String header;
  final String description;
  final String welcomeLine;
  final String lessonSummary;
  final String exampleQuestion;
  final List<String> exampleSteps;
  final String finalAnswer;
}

class VideoTutorialReference {
  const VideoTutorialReference({
    required this.title,
    required this.duration,
    required this.videoAssetPath,
    required this.color,
    this.type,
    this.subtitle,
  });

  final String title;
  final String duration;
  final String videoAssetPath;
  final Color color;
  final GasLawType? type;
  final String? subtitle;
}

class GivenField {
  const GivenField({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;
}

class AnswerChoice {
  const AnswerChoice({required this.label, required this.text});

  final String label;
  final String text;
}

class PracticeProblem {
  PracticeProblem.boyle({
    required this.question,
    required this.p1,
    required this.v1,
    required this.p2,
    required this.choices,
    required this.correctChoiceLabel,
  }) : type = GasLawType.boyle,
       t1 = null,
       t2 = null;

  PracticeProblem.charles({
    required this.question,
    required this.v1,
    required this.t1,
    required this.t2,
    required this.choices,
    required this.correctChoiceLabel,
  }) : type = GasLawType.charles,
       p1 = null,
       p2 = null;

  final GasLawType type;
  final String question;
  final double? p1;
  final double v1;
  final double? p2;
  final double? t1;
  final double? t2;
  final List<AnswerChoice> choices;
  final String correctChoiceLabel;

  AnswerChoice get correctChoice {
    return choices.firstWhere((choice) => choice.label == correctChoiceLabel);
  }

  List<GivenField> get givenFields {
    switch (type) {
      case GasLawType.boyle:
        return [
          GivenField(label: 'P₁', value: _formatNumber(p1!), unit: 'atm'),
          GivenField(label: 'V₁', value: _formatNumber(v1), unit: 'L'),
          GivenField(label: 'P₂', value: _formatNumber(p2!), unit: 'atm'),
        ];
      case GasLawType.charles:
        return [
          GivenField(label: 'V₁', value: _formatNumber(v1), unit: 'L'),
          GivenField(label: 'T₁', value: _formatNumber(t1!), unit: 'K'),
          GivenField(label: 'T₂', value: _formatNumber(t2!), unit: 'K'),
        ];
    }
  }

  List<String> get givenLines {
    final lines = givenFields
        .map((field) => '${field.label} = ${field.value} ${field.unit}')
        .toList();
    lines.add('V₂ = ?');
    return lines;
  }

  String get givenText => givenLines.join(', ');

  double get answer {
    switch (type) {
      case GasLawType.boyle:
        return (p1! * v1) / p2!;
      case GasLawType.charles:
        return (v1 * t2!) / t1!;
    }
  }

  String get answerText => '${_formatNumber(answer)} L';

  String get solutionText {
    switch (type) {
      case GasLawType.boyle:
        final numerator = p1! * v1;
        return [
          'Using Boyle\'s Law:',
          'P₁V₁ = P₂V₂',
          '',
          'Given:',
          'P₁ = ${_formatNumber(p1!)} atm',
          'V₁ = ${_formatNumber(v1)} L',
          'P₂ = ${_formatNumber(p2!)} atm',
          'V₂ = ?',
          '',
          'Solve for V₂:',
          'V₂ = @@ P₁ × V₁ | P₂',
          'V₂ = @@ ${_formatNumber(p1!)} × ${_formatNumber(v1)} | ${_formatNumber(p2!)}',
          'V₂ = @@ ${_formatNumber(numerator)} | ${_formatNumber(p2!)}',
          'V₂ = ${_formatNumber(answer)} L',
          '',
          'Final answer: ${_formatNumber(answer)} L',
        ].join('\n');
      case GasLawType.charles:
        final numerator = v1 * t2!;
        return [
          'Using Charles\' Law:',
          'V₁ @@ T₁ = V₂ @@ T₂',
          '',
          'Given:',
          'V₁ = ${_formatNumber(v1)} L',
          'T₁ = ${_formatNumber(t1!)} K',
          'T₂ = ${_formatNumber(t2!)} K',
          'V₂ = ?',
          '',
          'Solve for V₂:',
          'V₂ = @@ V₁ × T₂ | T₁',
          'V₂ = @@ ${_formatNumber(v1)} × ${_formatNumber(t2!)} | ${_formatNumber(t1!)}',
          'V₂ = @@ ${_formatNumber(numerator)} | ${_formatNumber(t1!)}',
          'V₂ = ${_formatNumber(answer)} L',
          '',
          'Final answer: ${_formatNumber(answer)} L',
        ].join('\n');
    }
  }

  List<String> get solutionLines {
    switch (type) {
      case GasLawType.boyle:
        final numerator = p1! * v1;
        final p1Str = _formatNumber(p1!);
        final v1Str = _formatNumber(v1);
        final p2Str = _formatNumber(p2!);
        final numStr = _formatNumber(numerator);
        final ansStr = _formatNumber(answer);
        return [
          'Using Boyle\'s Law:',
          'P₁V₁ = P₂V₂',
          '',
          'Given:',
          'P₁ = $p1Str atm',
          'V₁ = $v1Str L',
          'P₂ = $p2Str atm',
          'V₂ = ?',
          '',
          'Solve for V₂:',
          'V₂ = @@ P₁V₁ | P₂',
          'V₂ = @@ (${p1Str}atm)(${v1Str}L) | ${p2Str}atm',
          'V₂ = @@ ${numStr}L | $p2Str',
          'V₂ = ${ansStr}L',
          '',
          'Final answer: $ansStr L',
        ];
      case GasLawType.charles:
        final num = v1 * t2!;
        final v1Str = _formatNumber(v1);
        final t1Str = _formatNumber(t1!);
        final t2Str = _formatNumber(t2!);
        final numStr = _formatNumber(num);
        final ansStr = _formatNumber(answer);
        return [
          'Given:',
          '• V₁ = $v1Str L',
          '• T₁ = $t1Str K',
          '• T₂ = $t2Str K',
          '',
          'Formula:',
          'V₁ @@ T₁ = V₂ @@ T₂',
          'V₂ = @@ (V₁T₂) | T₁',
          '',
          'Solution:',
          'V₂ = @@ ($v1Str × $t2Str) | $t1Str',
          'V₂ = @@ $numStr | $t1Str',
          'V₂ = $ansStr L',
        ];
    }
  }
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  final fixed = value.toStringAsFixed(2);
  return fixed
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

const List<TutorialLesson> tutorialLessons = [
  TutorialLesson(
    type: GasLawType.boyle,
    header: 'Pressure and volume at constant temperature',
    description:
        'A guided Boyle\'s Law lesson based on the current content script.',
    welcomeLine: 'Welcome to iGasU!',
    lessonSummary:
        'In this lesson, we will explore Boyle\'s Law. Boyle\'s Law explains the relationship between pressure and volume when temperature remains constant. It states that pressure and volume are inversely proportional. \n\nThis means:\nWhen volume decreases, pressure increases. \nWhen volume increases, pressure decreases.\n\nWhy does this happen? \n-According to the Kinetic Molecular Theory, gas particles move randomly and continuously collide with the walls of the container. \nIf we reduce the volume, the particles have less space to move. Because of this, collisions happen more often. More collisions mean higher pressure. \n\nThe formula for Boyle\'s Law is: P₁V₁ = P₂V₂',
    exampleQuestion:
        'A gas has a volume of 2.0 liters at 1 atmosphere. If the volume decreases to 1.0 liter, what happens to the pressure?\n(Step-by-Step)',
    exampleSteps: [
      'CHOOSE ANSWER FROM MULTIPLE CHOICE',
      'ONCE THE ANSWER IS CORRECT',
      'The app shows: Formula substitution Step-by-step solution.',
      'Given',
      'P₁ = 1 atm',
      'V₁ = 2.0 L',
      'V₂ = 1.0 L',
      'P₂ ?',
      'P₁V₁ = P₂V₂',
      'P₂ = P₁V₁ | V₂',
      'P₂ = (1atm)(2L) | 1L',
      'P₂ = 2 | 1',
      'P₂ = 2 atm',
      'Final answer: The new pressure is 2.0 atm.',
    ],
    finalAnswer: 'The new pressure is 2.0 atm.',
  ),
  TutorialLesson(
    type: GasLawType.charles,
    header: 'Temperature and volume at constant pressure',
    description:
        'A guided Charles\' Law lesson based on the current content script.',
    welcomeLine: 'Welcome back to iGasU!',
    lessonSummary:
        'In this lesson, we will study Charles\' Law. Charles\' Law explains how temperature affects volume when pressure remains constant. It states that volume and temperature are directly proportional. \n\nThis means:\nWhen temperature increases, volume increases. \nWhen temperature decreases, volume decreases.\n\nWhy does this happen? \n-Based on the Kinetic Molecular Theory, heating a gas makes its particles move faster. \nFaster particles spread farther apart. This causes the gas to expand. \n\nThe formula for Charles\' Law is: V₁/T₁ = V₂/T₂',
    exampleQuestion:
        'A gas has a volume of 2.0 liters at 300 Kelvin. If the temperature increases to 450 Kelvin, what will be the new volume?\n(Step-by-Step)',
    exampleSteps: [
      'CHOOSE ANSWER FROM MULTIPLE CHOICE',
      'ONCE THE ANSWER IS CORRECT',
      'The app shows: Formula substitution Step-by-step solution.',
      'Given',
      'V₁ = 2.0 L',
      'T₁ = 300 K',
      'T₂ = 450 K',
      'V₂ = ?',
      'V₁ @@ T₁ = V₂ @@ T₂',
      'V₂ = @@ (V₁ x T₂) | T₁',
      'V₂ = @@ (2.0 x 450) | 300',
      'V₂ = @@ 900 | 300',
      'V₂ = 3.0 L',
      'Final answer: The new volume is 3.0 liters.',
    ],
    finalAnswer: 'The new volume is 3.0 liters.',
  ),
];

const List<VideoTutorialReference> videoTutorialReferences = [
  VideoTutorialReference(
    title: 'Boyle\'s Law',
    duration: '2:52',
    videoAssetPath: "assets/videos/BOYLE'S-LAW_Animation.mp4",
    color: Color(0xFF4A90E2),
    type: GasLawType.boyle,
  ),
  VideoTutorialReference(
    title: 'Charles\' Law',
    duration: '3:20',
    videoAssetPath: "assets/videos/CHARLES'-LAW_Animation.mp4",
    color: Color(0xFF5CB85C),
    type: GasLawType.charles,
  ),
  VideoTutorialReference(
    title: 'The Kinetic Molecular Theory',
    duration: '1:20',
    videoAssetPath: 'assets/videos/The-Kinetic-Molecular-Theory.mp4',
    color: Color(0xFFFF8A3D),
    subtitle: 'Supporting theory for Boyle\'s and Charles\' laws',
  ),
];

final List<PracticeProblem> practiceProblems = [
  PracticeProblem.boyle(
    question:
        'A gas has a volume of 4 L at a pressure of 2 atm. If the pressure becomes 4 atm, what is the new volume?',
    p1: 2,
    v1: 4,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '1L'),
      AnswerChoice(label: 'B', text: '2L'),
      AnswerChoice(label: 'C', text: '4L'),
      AnswerChoice(label: 'D', text: '8L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 6 L at 3 atm. If the pressure decreases to 1 atm, what is the new volume?',
    p1: 3,
    v1: 6,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '12L'),
      AnswerChoice(label: 'B', text: '9L'),
      AnswerChoice(label: 'C', text: '18L'),
      AnswerChoice(label: 'D', text: '24L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 10 L at 5 atm. If the pressure becomes 10 atm, find the new volume.',
    p1: 5,
    v1: 10,
    p2: 10,
    choices: const [
      AnswerChoice(label: 'A', text: '2.4L'),
      AnswerChoice(label: 'B', text: '5L'),
      AnswerChoice(label: 'C', text: '10L'),
      AnswerChoice(label: 'D', text: '20L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 8 L at 2 atm. If pressure increases to 4 atm, find the new volume.',
    p1: 2,
    v1: 8,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '2L'),
      AnswerChoice(label: 'B', text: '6L'),
      AnswerChoice(label: 'C', text: '4L'),
      AnswerChoice(label: 'D', text: '8L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 12 L at 3 atm. If pressure decreases to 2 atm, what is the new volume?',
    p1: 3,
    v1: 12,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '6L'),
      AnswerChoice(label: 'B', text: '12L'),
      AnswerChoice(label: 'C', text: '15L'),
      AnswerChoice(label: 'D', text: '18L'),
    ],
    correctChoiceLabel: 'D',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 15 L at 5 atm. If pressure changes to 3 atm, what is the new volume?',
    p1: 5,
    v1: 15,
    p2: 3,
    choices: const [
      AnswerChoice(label: 'A', text: '20L'),
      AnswerChoice(label: 'B', text: '25L'),
      AnswerChoice(label: 'C', text: '30L'),
      AnswerChoice(label: 'D', text: '35L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 7 L at 1 atm. If pressure becomes 7 atm, what is the new volume?',
    p1: 1,
    v1: 7,
    p2: 7,
    choices: const [
      AnswerChoice(label: 'A', text: '0.5L'),
      AnswerChoice(label: 'B', text: '1L'),
      AnswerChoice(label: 'C', text: '7L'),
      AnswerChoice(label: 'D', text: '14L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 9 L at 3 atm. If pressure becomes 6 atm, find the new volume.',
    p1: 3,
    v1: 9,
    p2: 6,
    choices: const [
      AnswerChoice(label: 'A', text: '3L'),
      AnswerChoice(label: 'B', text: '4.5L'),
      AnswerChoice(label: 'C', text: '6L'),
      AnswerChoice(label: 'D', text: '9L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 20 L at 2 atm. If pressure becomes 5 atm, what is the new volume?',
    p1: 2,
    v1: 20,
    p2: 5,
    choices: const [
      AnswerChoice(label: 'A', text: '5L'),
      AnswerChoice(label: 'B', text: '8L'),
      AnswerChoice(label: 'C', text: '10L'),
      AnswerChoice(label: 'D', text: '20L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 16 L at 4 atm. If pressure decreases to 2 atm, what is the new volume?',
    p1: 4,
    v1: 16,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '16L'),
      AnswerChoice(label: 'B', text: '32L'),
      AnswerChoice(label: 'C', text: '24L'),
      AnswerChoice(label: 'D', text: '64L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A diver has an air bubble with a volume of 30 L at a pressure of 5 atm underwater. As the diver rises, the pressure decreases to 2 atm. What is the new volume of the bubble?',
    p1: 5,
    v1: 30,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '60L'),
      AnswerChoice(label: 'B', text: '75L'),
      AnswerChoice(label: 'C', text: '90L'),
      AnswerChoice(label: 'D', text: '150L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A syringe contains 12 L of gas at 6 atm pressure. When the plunger is pulled back, the pressure drops to 3 atm. What is the new volume?',
    p1: 6,
    v1: 12,
    p2: 3,
    choices: const [
      AnswerChoice(label: 'A', text: '12L'),
      AnswerChoice(label: 'B', text: '24L'),
      AnswerChoice(label: 'C', text: '26L'),
      AnswerChoice(label: 'D', text: '48L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'An air tank used by firefighters contains gas with a volume of 20 L at 10 atm. If the pressure inside the tank drops to 4 atm, what will be the new volume?',
    p1: 10,
    v1: 20,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '40L'),
      AnswerChoice(label: 'B', text: '50L'),
      AnswerChoice(label: 'C', text: '60L'),
      AnswerChoice(label: 'D', text: '80L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A balloon inside a laboratory chamber has a volume of 18 L at 9 atm pressure. When the pressure is reduced to 3 atm, what will be the new volume?',
    p1: 9,
    v1: 18,
    p2: 3,
    choices: const [
      AnswerChoice(label: 'A', text: '27L'),
      AnswerChoice(label: 'B', text: '36L'),
      AnswerChoice(label: 'C', text: '54L'),
      AnswerChoice(label: 'D', text: '72L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A scuba diver\'s air pocket measures 16 L at 8 atm deep underwater. As the diver moves upward, the pressure becomes 4 atm. What is the new volume?',
    p1: 8,
    v1: 16,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '16L'),
      AnswerChoice(label: 'B', text: '32L'),
      AnswerChoice(label: 'C', text: '48L'),
      AnswerChoice(label: 'D', text: '64L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A medical breathing bag contains 10 L of air at 5 atm. If the pressure decreases to 2 atm, what is the new volume?',
    p1: 5,
    v1: 10,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '15L'),
      AnswerChoice(label: 'B', text: '20L'),
      AnswerChoice(label: 'C', text: '25L'),
      AnswerChoice(label: 'D', text: '30'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A weather balloon has a volume of 40 L at 8 atm near the ground. As it rises into the atmosphere, the pressure drops to 2 atm. What is its new volume?',
    p1: 8,
    v1: 40,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '80L'),
      AnswerChoice(label: 'B', text: '120L'),
      AnswerChoice(label: 'C', text: '160L'),
      AnswerChoice(label: 'D', text: '200L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Inside a sealed laboratory cylinder, gas occupies 14 L at 7 atm. If the pressure becomes 1 atm, what is the new volume?',
    p1: 7,
    v1: 14,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '49L'),
      AnswerChoice(label: 'B', text: '84L'),
      AnswerChoice(label: 'C', text: '98L'),
      AnswerChoice(label: 'D', text: '112L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A compressed air container holds 22 L of gas at 11 atm. If the pressure drops to 5 atm, what is the new volume?',
    p1: 11,
    v1: 22,
    p2: 5,
    choices: const [
      AnswerChoice(label: 'A', text: '44L'),
      AnswerChoice(label: 'B', text: '46.2'),
      AnswerChoice(label: 'C', text: '48.4L'),
      AnswerChoice(label: 'D', text: '52L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A research chamber contains 50 L of gas at 10 atm. Scientists reduce the pressure to 2 atm. What will be the new volume?',
    p1: 10,
    v1: 50,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '100L'),
      AnswerChoice(label: 'B', text: '150L'),
      AnswerChoice(label: 'C', text: '250L'),
      AnswerChoice(label: 'D', text: '500L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A compressed oxygen tank has 24 L of gas at 12 atm. If the pressure decreases to 6 atm, what is the new volume?',
    p1: 12,
    v1: 24,
    p2: 6,
    choices: const [
      AnswerChoice(label: 'A', text: '24L'),
      AnswerChoice(label: 'B', text: '48L'),
      AnswerChoice(label: 'C', text: '72L'),
      AnswerChoice(label: 'D', text: '96L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A deep -sea submarine air pocket measures 35 L at 7 atm. If the pressure changes to 5 atm, what is the new volume?',
    p1: 7,
    v1: 35,
    p2: 5,
    choices: const [
      AnswerChoice(label: 'A', text: '35L'),
      AnswerChoice(label: 'B', text: '42L'),
      AnswerChoice(label: 'C', text: '49L'),
      AnswerChoice(label: 'D', text: '56L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A gas pump cylinder contains 28 L at 14 atm pressure. If the pressure decreases to 7 atm, what is the new volume?',
    p1: 14,
    v1: 28,
    p2: 7,
    choices: const [
      AnswerChoice(label: 'A', text: '42L'),
      AnswerChoice(label: 'B', text: '49L'),
      AnswerChoice(label: 'C', text: '56L'),
      AnswerChoice(label: 'D', text: '70L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A scientific vacuum container has gas with 21 L volume at 3 atm. If the pressure increases to 9 atm, what is the new volume?',
    p1: 3,
    v1: 21,
    p2: 9,
    choices: const [
      AnswerChoice(label: 'A', text: '5L'),
      AnswerChoice(label: 'B', text: '7L'),
      AnswerChoice(label: 'C', text: '9L'),
      AnswerChoice(label: 'D', text: '12L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A laboratory piston chamber holds 60 L of gas at 6 atm. If the pressure increases to 15 atm, what is the new volume?',
    p1: 6,
    v1: 60,
    p2: 15,
    choices: const [
      AnswerChoice(label: 'A', text: '18L'),
      AnswerChoice(label: 'B', text: '20L'),
      AnswerChoice(label: 'C', text: '24L'),
      AnswerChoice(label: 'D', text: '30L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Inside a car tire, air occupies 32 L at 8 atm pressure. After releasing some air, the pressure becomes 4 atm. What is the new volume of the air?',
    p1: 8,
    v1: 32,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '32L'),
      AnswerChoice(label: 'B', text: '64L'),
      AnswerChoice(label: 'C', text: '96L'),
      AnswerChoice(label: 'D', text: '128L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A plastic water bottle traps 15 L of air at 3 atm when squeezed tightly. If the pressure decreases to 1 atm, what is the new volume?',
    p1: 3,
    v1: 15,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '30L'),
      AnswerChoice(label: 'B', text: '36L'),
      AnswerChoice(label: 'C', text: '45L'),
      AnswerChoice(label: 'D', text: '60L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a soccer ball occupies 20 L at 5 atm. If the pressure increases to 10 atm, what is the new volume?',
    p1: 5,
    v1: 20,
    p2: 10,
    choices: const [
      AnswerChoice(label: 'A', text: '5L'),
      AnswerChoice(label: 'B', text: '10L'),
      AnswerChoice(label: 'C', text: '20L'),
      AnswerChoice(label: 'D', text: '40L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A vacuum storage container holds gas with a volume of 18 L at 6 atm. If the pressure drops to 2 atm, what is the new volume?',
    p1: 6,
    v1: 18,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '18L'),
      AnswerChoice(label: 'B', text: '36L'),
      AnswerChoice(label: 'C', text: '54L'),
      AnswerChoice(label: 'D', text: '72L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a basketball has a volume of 12 L at 4 atm. If the pressure drops to 2 atm, what is the new volume?',
    p1: 4,
    v1: 12,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '12L'),
      AnswerChoice(label: 'B', text: '24L'),
      AnswerChoice(label: 'C', text: '36L'),
      AnswerChoice(label: 'D', text: '48L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A sealed laboratory flask contains gas with a volume of 50 L at 10 atm. If the pressure becomes 5 atm, what is the new volume?',
    p1: 10,
    v1: 50,
    p2: 5,
    choices: const [
      AnswerChoice(label: 'A', text: '50L'),
      AnswerChoice(label: 'B', text: '75L'),
      AnswerChoice(label: 'C', text: '100L'),
      AnswerChoice(label: 'D', text: '150L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A gas storage tank holds 40 L of gas at 8 atm. If the pressure decreases to 4 atm, what is the new volume?',
    p1: 8,
    v1: 40,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '40L'),
      AnswerChoice(label: 'B', text: '80L'),
      AnswerChoice(label: 'C', text: '120L'),
      AnswerChoice(label: 'D', text: '160L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped inside a sealed jar occupies 9 L at 3 atm. If the pressure increases to 9 atm, what is the new volume?',
    p1: 3,
    v1: 9,
    p2: 9,
    choices: const [
      AnswerChoice(label: 'A', text: '1L'),
      AnswerChoice(label: 'B', text: '2L'),
      AnswerChoice(label: 'C', text: '3L'),
      AnswerChoice(label: 'D', text: '6L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A rubber balloon contains 25 L of gas at 5 atm. If the pressure becomes 1 atm, what is the new volume?',
    p1: 5,
    v1: 25,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '50L'),
      AnswerChoice(label: 'B', text: '75L'),
      AnswerChoice(label: 'C', text: '125L'),
      AnswerChoice(label: 'D', text: '150L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a mechanical piston chamber occupies 30 L at 6 atm. If the pressure increases to 12 atm, what is the new volume?',
    p1: 6,
    v1: 30,
    p2: 12,
    choices: const [
      AnswerChoice(label: 'A', text: '10L'),
      AnswerChoice(label: 'B', text: '15L'),
      AnswerChoice(label: 'C', text: '20L'),
      AnswerChoice(label: 'D', text: '25L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A sealed medical oxygen bag contains 14 L of gas at 7 atm. If the pressure drops to 1 atm, what is the new volume?',
    p1: 7,
    v1: 14,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '56L'),
      AnswerChoice(label: 'B', text: '84L'),
      AnswerChoice(label: 'C', text: '98L'),
      AnswerChoice(label: 'D', text: '112L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Gas inside a pressure cooker safety chamber occupies 16 L at 8 atm. If the pressure decreases to 4 atm, what is the new volume?',
    p1: 8,
    v1: 16,
    p2: 4,
    choices: const [
      AnswerChoice(label: 'A', text: '16L'),
      AnswerChoice(label: 'B', text: '32L'),
      AnswerChoice(label: 'C', text: '48L'),
      AnswerChoice(label: 'D', text: '64L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A camping air mattress pump compresses 60 L of air at 3 atm. If the pressure increases to 9 atm, what is the new volume?',
    p1: 3,
    v1: 60,
    p2: 9,
    choices: const [
      AnswerChoice(label: 'A', text: '15L'),
      AnswerChoice(label: 'B', text: '20L'),
      AnswerChoice(label: 'C', text: '30L'),
      AnswerChoice(label: 'D', text: '40'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped inside a glass laboratory tube occupies 11 L at 11 atm. If the pressure decreases to 1 atm, what is the new volume?',
    p1: 11,
    v1: 11,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '99L'),
      AnswerChoice(label: 'B', text: '110L'),
      AnswerChoice(label: 'C', text: '121L'),
      AnswerChoice(label: 'D', text: '132L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A compressed air spray can contains 24 L of gas at 12 atm. If the pressure becomes 6 atm, what is the new volume?',
    p1: 12,
    v1: 24,
    p2: 6,
    choices: const [
      AnswerChoice(label: 'A', text: '24L'),
      AnswerChoice(label: 'B', text: '48L'),
      AnswerChoice(label: 'C', text: '72L'),
      AnswerChoice(label: 'D', text: '96L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A diving air tank contains 28 L of air at 7 atm pressure. If the pressure drops to 1 atm, what is the new volume?',
    p1: 7,
    v1: 28,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '112L'),
      AnswerChoice(label: 'B', text: '168L'),
      AnswerChoice(label: 'C', text: '196L'),
      AnswerChoice(label: 'D', text: '224L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a laboratory syringe occupies 10 L at 5 atm. If the pressure increases to 10 atm, what is the new volume?',
    p1: 5,
    v1: 10,
    p2: 10,
    choices: const [
      AnswerChoice(label: 'A', text: '2L'),
      AnswerChoice(label: 'B', text: '5L'),
      AnswerChoice(label: 'C', text: '10L'),
      AnswerChoice(label: 'D', text: '20L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A scuba diver’s air bag contains 18 L of air at 6 atm. If the pressure decreases to 3 atm, what is the new volume?',
    p1: 6,
    v1: 18,
    p2: 3,
    choices: const [
      AnswerChoice(label: 'A', text: '18L'),
      AnswerChoice(label: 'B', text: '24L'),
      AnswerChoice(label: 'C', text: '36L'),
      AnswerChoice(label: 'D', text: '54L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped in a laboratory balloon occupies 22 L at 2 atm. If the pressure becomes 1 atm, what is the new volume?',
    p1: 2,
    v1: 22,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '22L'),
      AnswerChoice(label: 'B', text: '33L'),
      AnswerChoice(label: 'C', text: '44L'),
      AnswerChoice(label: 'D', text: '66L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'A hydraulic piston chamber contains gas with a volume of 35 L at 7 atm. If the pressure increases to 14 atm, what is the new volume?',
    p1: 7,
    v1: 35,
    p2: 14,
    choices: const [
      AnswerChoice(label: 'A', text: '14L'),
      AnswerChoice(label: 'B', text: '17.5L'),
      AnswerChoice(label: 'C', text: '21L'),
      AnswerChoice(label: 'D', text: '35L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'Gas inside a scientific testing tube occupies 16 L at 4 atm. If the pressure drops to 2 atm, what is the new volume?',
    p1: 4,
    v1: 16,
    p2: 2,
    choices: const [
      AnswerChoice(label: 'A', text: '16L'),
      AnswerChoice(label: 'B', text: '32L'),
      AnswerChoice(label: 'C', text: '48L'),
      AnswerChoice(label: 'D', text: '64L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A car air compressor holds 45 L of gas at 9 atm. If the pressure decreases to 3 atm, what is the new volume?',
    p1: 9,
    v1: 45,
    p2: 3,
    choices: const [
      AnswerChoice(label: 'A', text: '45L'),
      AnswerChoice(label: 'B', text: '90L'),
      AnswerChoice(label: 'C', text: '135L'),
      AnswerChoice(label: 'D', text: '180L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'trapped inside a metal container occupies 12 L at 6 atm. If the pressure increases to 12 atm, what is the new volume?',
    p1: 6,
    v1: 12,
    p2: 12,
    choices: const [
      AnswerChoice(label: 'A', text: '3L'),
      AnswerChoice(label: 'B', text: '6L'),
      AnswerChoice(label: 'C', text: '12L'),
      AnswerChoice(label: 'D', text: '24'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.boyle(
    question:
        'A laboratory gas chamber contains 27 L of air at 9 atm. If the pressure becomes 3 atm, what is the new volume?',
    p1: 9,
    v1: 27,
    p2: 3,
    choices: const [
      AnswerChoice(label: 'A', text: '54L'),
      AnswerChoice(label: 'B', text: '72L'),
      AnswerChoice(label: 'C', text: '81L'),
      AnswerChoice(label: 'D', text: '108L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a rescue breathing bag occupies 20 L at 4 atm. If the pressure drops to 1 atm, what is the new volume?',
    p1: 4,
    v1: 20,
    p2: 1,
    choices: const [
      AnswerChoice(label: 'A', text: '40L'),
      AnswerChoice(label: 'B', text: '60L'),
      AnswerChoice(label: 'C', text: '80L'),
      AnswerChoice(label: 'D', text: '100L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 2.5 L at 290 K. If the temperature increases to 330 K, what will be the new volume?',
    v1: 2.5,
    t1: 290,
    t2: 330,
    choices: const [
      AnswerChoice(label: 'A', text: '2.65 L'),
      AnswerChoice(label: 'B', text: '2.84 L'),
      AnswerChoice(label: 'C', text: '3.02 L'),
      AnswerChoice(label: 'D', text: '3.20 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.2 L at 300 K. If the temperature rises to 360 K, what is the new volume?',
    v1: 3.2,
    t1: 300,
    t2: 360,
    choices: const [
      AnswerChoice(label: 'A', text: '3.64 L'),
      AnswerChoice(label: 'B', text: '3.84 L'),
      AnswerChoice(label: 'C', text: '4.02 L'),
      AnswerChoice(label: 'D', text: '4.20 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 1.8 L at 280 K. What will be its volume at 350 K?',
    v1: 1.8,
    t1: 280,
    t2: 350,
    choices: const [
      AnswerChoice(label: 'A', text: '2.05 L'),
      AnswerChoice(label: 'B', text: '2.15 L'),
      AnswerChoice(label: 'C', text: '2.25 L'),
      AnswerChoice(label: 'D', text: '2.45 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A container of gas occupies 5.6 L at 310 K. What volume will it occupy at 400 K?',
    v1: 5.6,
    t1: 310,
    t2: 400,
    choices: const [
      AnswerChoice(label: 'A', text: '6.82 L'),
      AnswerChoice(label: 'B', text: '7.05 L'),
      AnswerChoice(label: 'C', text: '7.23 L'),
      AnswerChoice(label: 'D', text: '7.50 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 7.5 L at 350 K. If the temperature decreases to 300 K, what is the new volume?',
    v1: 7.5,
    t1: 350,
    t2: 300,
    choices: const [
      AnswerChoice(label: 'A', text: '6.21 L'),
      AnswerChoice(label: 'B', text: '6.43 L'),
      AnswerChoice(label: 'C', text: '6.60 L'),
      AnswerChoice(label: 'D', text: '6.85 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 9.0 L at 320 K. What is its volume at 380 K?',
    v1: 9,
    t1: 320,
    t2: 380,
    choices: const [
      AnswerChoice(label: 'A', text: '10.12 L'),
      AnswerChoice(label: 'B', text: '10.45 L'),
      AnswerChoice(label: 'C', text: '10.69 L'),
      AnswerChoice(label: 'D', text: '10.90 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.4 L at 295 K. What will its volume be at 355 K?',
    v1: 4.4,
    t1: 295,
    t2: 355,
    choices: const [
      AnswerChoice(label: 'A', text: '5.12 L'),
      AnswerChoice(label: 'B', text: '5.30 L'),
      AnswerChoice(label: 'C', text: '5.48 L'),
      AnswerChoice(label: 'D', text: '5.62 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas has a volume of 6.2 L at 305 K. Find its volume at 370 K.',
    v1: 6.2,
    t1: 305,
    t2: 370,
    choices: const [
      AnswerChoice(label: 'A', text: '7.18 L'),
      AnswerChoice(label: 'B', text: '7.36 L'),
      AnswerChoice(label: 'C', text: '7.52 L'),
      AnswerChoice(label: 'D', text: '7.80 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 8.5 L at 315 K. What is the volume at 420 K?',
    v1: 8.5,
    t1: 315,
    t2: 420,
    choices: const [
      AnswerChoice(label: 'A', text: '10.92 L'),
      AnswerChoice(label: 'B', text: '11.15 L'),
      AnswerChoice(label: 'C', text: '11.33 L'),
      AnswerChoice(label: 'D', text: '11.60 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 10.2 L at 330 K. What will be the volume at 390 K?',
    v1: 10.2,
    t1: 330,
    t2: 390,
    choices: const [
      AnswerChoice(label: 'A', text: '11.82 L'),
      AnswerChoice(label: 'B', text: '12.05 L'),
      AnswerChoice(label: 'C', text: '12.25 L'),
      AnswerChoice(label: 'D', text: '12.50 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.9 L at 275 K. What will be its volume at 340 K?',
    v1: 3.9,
    t1: 275,
    t2: 340,
    choices: const [
      AnswerChoice(label: 'A', text: '4.55 L'),
      AnswerChoice(label: 'B', text: '4.82 L'),
      AnswerChoice(label: 'C', text: '5.02 L'),
      AnswerChoice(label: 'D', text: '5.20 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 5.0 L at 290 K. What will be the volume at 350 K?',
    v1: 5,
    t1: 290,
    t2: 350,
    choices: const [
      AnswerChoice(label: 'A', text: '5.82 L'),
      AnswerChoice(label: 'B', text: '6.03 L'),
      AnswerChoice(label: 'C', text: '6.20 L'),
      AnswerChoice(label: 'D', text: '6.35 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 6.8 L at 300 K. What is its volume at 420 K?',
    v1: 6.8,
    t1: 300,
    t2: 420,
    choices: const [
      AnswerChoice(label: 'A', text: '9.12 L'),
      AnswerChoice(label: 'B', text: '9.34 L'),
      AnswerChoice(label: 'C', text: '9.52 L'),
      AnswerChoice(label: 'D', text: '9.80 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 2.1 L at 285 K. What is its volume at 345 K?',
    v1: 2.1,
    t1: 285,
    t2: 345,
    choices: const [
      AnswerChoice(label: 'A', text: '2.35 L'),
      AnswerChoice(label: 'B', text: '2.54 L'),
      AnswerChoice(label: 'C', text: '2.71 L'),
      AnswerChoice(label: 'D', text: '2.90 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.7 L at 295 K. What volume will it have at 365 K?',
    v1: 4.7,
    t1: 295,
    t2: 365,
    choices: const [
      AnswerChoice(label: 'A', text: '5.54 L'),
      AnswerChoice(label: 'B', text: '5.82 L'),
      AnswerChoice(label: 'C', text: '6.01 L'),
      AnswerChoice(label: 'D', text: '6.20 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.3 L at 310 K. What is its volume at 450 K?',
    v1: 8.3,
    t1: 310,
    t2: 450,
    choices: const [
      AnswerChoice(label: 'A', text: '11.75 L'),
      AnswerChoice(label: 'B', text: '12.05 L'),
      AnswerChoice(label: 'C', text: '12.30 L'),
      AnswerChoice(label: 'D', text: '12.55 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 1.9 L at 260 K. What will be its volume at 300 K?',
    v1: 1.9,
    t1: 260,
    t2: 300,
    choices: const [
      AnswerChoice(label: 'A', text: '2.05 L'),
      AnswerChoice(label: 'B', text: '2.19 L'),
      AnswerChoice(label: 'C', text: '2.32 L'),
      AnswerChoice(label: 'D', text: '2.48 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 7.1 L at 315 K. What is its volume at 380 K?',
    v1: 7.1,
    t1: 315,
    t2: 380,
    choices: const [
      AnswerChoice(label: 'A', text: '8.22 L'),
      AnswerChoice(label: 'B', text: '8.57 L'),
      AnswerChoice(label: 'C', text: '8.82 L'),
      AnswerChoice(label: 'D', text: '9.04 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 5.9 L at 300 K. What will be the volume at 360 K?',
    v1: 5.9,
    t1: 300,
    t2: 360,
    choices: const [
      AnswerChoice(label: 'A', text: '6.82 L'),
      AnswerChoice(label: 'B', text: '7.08 L'),
      AnswerChoice(label: 'C', text: '7.24 L'),
      AnswerChoice(label: 'D', text: '7.50 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.3 L at 275 K. What volume will it occupy at 350 K?',
    v1: 4.3,
    t1: 275,
    t2: 350,
    choices: const [
      AnswerChoice(label: 'A', text: '5.24 L'),
      AnswerChoice(label: 'B', text: '5.47 L'),
      AnswerChoice(label: 'C', text: '5.70 L'),
      AnswerChoice(label: 'D', text: '5.92 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.9 L at 275 K. What will be its volume at 340 K?',
    v1: 3.9,
    t1: 275,
    t2: 340,
    choices: const [
      AnswerChoice(label: 'A', text: '4.21 L'),
      AnswerChoice(label: 'B', text: '4.82 L'),
      AnswerChoice(label: 'C', text: '5.10 L'),
      AnswerChoice(label: 'D', text: '5.82 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 5.0 L at 290 K. What will be the volume at 350 K?',
    v1: 5,
    t1: 290,
    t2: 350,
    choices: const [
      AnswerChoice(label: 'A', text: '5.85 L'),
      AnswerChoice(label: 'B', text: '6.03 L'),
      AnswerChoice(label: 'C', text: '6.50 L'),
      AnswerChoice(label: 'D', text: '6.83 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 6.8 L at 300 K. What is its volume at 420 K?',
    v1: 6.8,
    t1: 300,
    t2: 420,
    choices: const [
      AnswerChoice(label: 'A', text: '8.52 L'),
      AnswerChoice(label: 'B', text: '9.12 L'),
      AnswerChoice(label: 'C', text: '9.52 L'),
      AnswerChoice(label: 'D', text: '10.02 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 2.1 L at 285 K. What is its volume at 345 K?',
    v1: 2.1,
    t1: 285,
    t2: 345,
    choices: const [
      AnswerChoice(label: 'A', text: '2.34 L'),
      AnswerChoice(label: 'B', text: '2.54 L'),
      AnswerChoice(label: 'C', text: '2.74 L'),
      AnswerChoice(label: 'D', text: '2.94 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.7 L at 295 K. What volume will it have at 365 K?',
    v1: 4.7,
    t1: 295,
    t2: 365,
    choices: const [
      AnswerChoice(label: 'A', text: '5.42 L'),
      AnswerChoice(label: 'B', text: '5.62 L'),
      AnswerChoice(label: 'C', text: '5.82 L'),
      AnswerChoice(label: 'D', text: '6.02 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.3 L at 310 K. What is its volume at 450 K?',
    v1: 8.3,
    t1: 310,
    t2: 450,
    choices: const [
      AnswerChoice(label: 'A', text: '11.05 L'),
      AnswerChoice(label: 'B', text: '11.55 L'),
      AnswerChoice(label: 'C', text: '12.05 L'),
      AnswerChoice(label: 'D', text: '12.55 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 1.9 L at 260 K. What will be its volume at 300 K?',
    v1: 1.9,
    t1: 260,
    t2: 300,
    choices: const [
      AnswerChoice(label: 'A', text: '2.09 L'),
      AnswerChoice(label: 'B', text: '2.19 L'),
      AnswerChoice(label: 'C', text: '2.29 L'),
      AnswerChoice(label: 'D', text: '2.39 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 7.1 L at 315 K. What is its volume at 380 K?',
    v1: 7.1,
    t1: 315,
    t2: 380,
    choices: const [
      AnswerChoice(label: 'A', text: '8.37 L'),
      AnswerChoice(label: 'B', text: '8.57 L'),
      AnswerChoice(label: 'C', text: '8.77 L'),
      AnswerChoice(label: 'D', text: '8.97 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 5.9 L at 300 K. What will be the volume at 360 K?',
    v1: 5.9,
    t1: 300,
    t2: 360,
    choices: const [
      AnswerChoice(label: 'A', text: '6.88 L'),
      AnswerChoice(label: 'B', text: '7.08 L'),
      AnswerChoice(label: 'C', text: '7.28 L'),
      AnswerChoice(label: 'D', text: '7.48 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.3 L at 275 K. What volume will it occupy at 350 K?',
    v1: 4.3,
    t1: 275,
    t2: 350,
    choices: const [
      AnswerChoice(label: 'A', text: '5.07 L'),
      AnswerChoice(label: 'B', text: '5.27 L'),
      AnswerChoice(label: 'C', text: '5.47 L'),
      AnswerChoice(label: 'D', text: '5.67 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 9.2 L at 320 K. What volume will it occupy at 400 K?',
    v1: 9.2,
    t1: 320,
    t2: 400,
    choices: const [
      AnswerChoice(label: 'A', text: '11.10 L'),
      AnswerChoice(label: 'B', text: '11.30 L'),
      AnswerChoice(label: 'C', text: '11.70 L'),
      AnswerChoice(label: 'D', text: '11.50 L'),
    ],
    correctChoiceLabel: 'D',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 3.4 L at 270 K. Find its volume at 330 K.',
    v1: 3.4,
    t1: 270,
    t2: 330,
    choices: const [
      AnswerChoice(label: 'A', text: '4.16 L'),
      AnswerChoice(label: 'B', text: '4.06 L'),
      AnswerChoice(label: 'C', text: '4.96 L'),
      AnswerChoice(label: 'D', text: '4.26 L'),
    ],
    correctChoiceLabel: 'A',
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 7.8 L at 305 K. What is its volume at 385 K?',
    v1: 7.8,
    t1: 305,
    t2: 385,
    choices: const [
      AnswerChoice(label: 'A', text: '9.45 L'),
      AnswerChoice(label: 'B', text: '9.65 L'),
      AnswerChoice(label: 'C', text: '9.85 L'),
      AnswerChoice(label: 'D', text: '10.05 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.1 L at 290 K. Find its volume at 355 K.',
    v1: 5.1,
    t1: 290,
    t2: 355,
    choices: const [
      AnswerChoice(label: 'A', text: '6.04 L'),
      AnswerChoice(label: 'B', text: '6.14 L'),
      AnswerChoice(label: 'C', text: '6.24 L'),
      AnswerChoice(label: 'D', text: '6.34 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 6.7 L at 315 K. What will be its volume at 395 K?',
    v1: 6.7,
    t1: 315,
    t2: 395,
    choices: const [
      AnswerChoice(label: 'A', text: '8.20 L'),
      AnswerChoice(label: 'B', text: '8.30 L'),
      AnswerChoice(label: 'C', text: '8.50 L'),
      AnswerChoice(label: 'D', text: '8.40 L'),
    ],
    correctChoiceLabel: 'D',
  ),
  PracticeProblem.charles(
    question:
        'A balloon contains 2.3 L of gas at 275 K. Find the new volume at 340 K.',
    v1: 2.3,
    t1: 275,
    t2: 340,
    choices: const [
      AnswerChoice(label: 'A', text: '2.64 L'),
      AnswerChoice(label: 'B', text: '2.84 L'),
      AnswerChoice(label: 'C', text: '2.64 L'),
      AnswerChoice(label: 'D', text: '2.94 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.9 L at 320 K. Determine its volume at 430 K.',
    v1: 8.9,
    t1: 320,
    t2: 430,
    choices: const [
      AnswerChoice(label: 'A', text: '11.56 L'),
      AnswerChoice(label: 'B', text: '11.76 L'),
      AnswerChoice(label: 'C', text: '11.96 L'),
      AnswerChoice(label: 'D', text: '12.16 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 4.0 L at 285 K. What is its volume at 345 K?',
    v1: 4,
    t1: 285,
    t2: 345,
    choices: const [
      AnswerChoice(label: 'A', text: '4.64 L'),
      AnswerChoice(label: 'B', text: '4.84 L'),
      AnswerChoice(label: 'C', text: '4.74 L'),
      AnswerChoice(label: 'D', text: '4.94 L'),
    ],
    correctChoiceLabel: 'B',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.6 L at 300 K. Find its volume at 380 K.',
    v1: 5.6,
    t1: 300,
    t2: 380,
    choices: const [
      AnswerChoice(label: 'A', text: '6.89 L'),
      AnswerChoice(label: 'B', text: '6.99 L'),
      AnswerChoice(label: 'C', text: '7.09 L'),
      AnswerChoice(label: 'D', text: '7.19 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 3.7 L at 290 K. What volume will it occupy at 355 K?',
    v1: 3.7,
    t1: 290,
    t2: 355,
    choices: const [
      AnswerChoice(label: 'A', text: '4.33 L'),
      AnswerChoice(label: 'B', text: '4.43 L'),
      AnswerChoice(label: 'C', text: '4.53 L'),
      AnswerChoice(label: 'D', text: '4.63 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 2.9 L at 280 K. What will its volume be at 330 K?',
    v1: 2.9,
    t1: 280,
    t2: 330,
    choices: const [
      AnswerChoice(label: 'A', text: '3.22 L'),
      AnswerChoice(label: 'B', text: '3.32 L'),
      AnswerChoice(label: 'C', text: '3.52 L'),
      AnswerChoice(label: 'D', text: '3.42 L'),
    ],
    correctChoiceLabel: 'D',
  ),
  PracticeProblem.charles(
    question: 'A gas has a volume of 7.5 L at 310 K. Find its volume at 385 K.',
    v1: 7.5,
    t1: 310,
    t2: 385,
    choices: const [
      AnswerChoice(label: 'A', text: '9.11 L'),
      AnswerChoice(label: 'B', text: '9.21 L'),
      AnswerChoice(label: 'C', text: '9.41 L'),
      AnswerChoice(label: 'D', text: '9.31 L'),
    ],
    correctChoiceLabel: 'D',
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 4.2 L at 290 K. What will be the volume at 345 K?',
    v1: 4.2,
    t1: 290,
    t2: 345,
    choices: const [
      AnswerChoice(label: 'A', text: '4.79 L'),
      AnswerChoice(label: 'B', text: '4.89 L'),
      AnswerChoice(label: 'C', text: '4.99 L'),
      AnswerChoice(label: 'D', text: '5.09 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 6.8 L at 305 K. Determine its volume at 390 K.',
    v1: 6.8,
    t1: 305,
    t2: 390,
    choices: const [
      AnswerChoice(label: 'A', text: '8.49 L'),
      AnswerChoice(label: 'B', text: '8.59 L'),
      AnswerChoice(label: 'C', text: '8.69 L'),
      AnswerChoice(label: 'D', text: '8.79 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.3 L at 275 K. What will be its volume at 325 K?',
    v1: 3.3,
    t1: 275,
    t2: 325,
    choices: const [
      AnswerChoice(label: 'A', text: '3.70 L'),
      AnswerChoice(label: 'B', text: '3.80 L'),
      AnswerChoice(label: 'C', text: '3.90 L'),
      AnswerChoice(label: 'D', text: '4.00 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 9.4 L at 315 K. Find its volume at 430 K.',
    v1: 9.4,
    t1: 315,
    t2: 430,
    choices: const [
      AnswerChoice(label: 'A', text: '12.43 L'),
      AnswerChoice(label: 'B', text: '12.63 L'),
      AnswerChoice(label: 'C', text: '12.83 L'),
      AnswerChoice(label: 'D', text: '13.03 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.7 L at 300 K. Determine its volume at 360 K.',
    v1: 5.7,
    t1: 300,
    t2: 360,
    choices: const [
      AnswerChoice(label: 'A', text: '6.64 L'),
      AnswerChoice(label: 'B', text: '6.74 L'),
      AnswerChoice(label: 'C', text: '6.84 L'),
      AnswerChoice(label: 'D', text: '6.94 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 2.5 L at 285 K. What will its volume be at 340 K?',
    v1: 2.5,
    t1: 285,
    t2: 340,
    choices: const [
      AnswerChoice(label: 'A', text: '2.78 L'),
      AnswerChoice(label: 'B', text: '2.88 L'),
      AnswerChoice(label: 'C', text: '2.98 L'),
      AnswerChoice(label: 'D', text: '3.08 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 7.2 L at 310 K. What is its volume at 400 K?',
    v1: 7.2,
    t1: 310,
    t2: 400,
    choices: const [
      AnswerChoice(label: 'A', text: '9.09 L'),
      AnswerChoice(label: 'B', text: '9.19 L'),
      AnswerChoice(label: 'C', text: '9.29 L'),
      AnswerChoice(label: 'D', text: '9.39 L'),
    ],
    correctChoiceLabel: 'C',
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 4.5 L at 295 K. Determine its volume at 355 K.',
    v1: 4.5,
    t1: 295,
    t2: 355,
    choices: const [
      AnswerChoice(label: 'A', text: '5.22 L'),
      AnswerChoice(label: 'B', text: '5.32 L'),
      AnswerChoice(label: 'C', text: '5.42 L'),
      AnswerChoice(label: 'D', text: '5.52 L'),
    ],
    correctChoiceLabel: 'C',
  ),
];

List<PracticeProblem> practiceProblemsFor(GasLawType type) {
  return practiceProblems.where((problem) => problem.type == type).toList();
}

int practiceProblemCountFor(GasLawType type) {
  return practiceProblems.where((problem) => problem.type == type).length;
}
