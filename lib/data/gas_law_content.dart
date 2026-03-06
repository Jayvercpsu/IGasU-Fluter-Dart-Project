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
        return 'V1/T1 = V2/T2';
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
    required this.keyPoints,
    required this.whyItHappens,
    required this.reminders,
    required this.exampleQuestion,
    required this.exampleInputs,
    required this.exampleSteps,
    required this.finalAnswer,
  });

  final GasLawType type;
  final String header;
  final String description;
  final String welcomeLine;
  final String lessonSummary;
  final List<String> keyPoints;
  final List<String> whyItHappens;
  final List<String> reminders;
  final String exampleQuestion;
  final List<String> exampleInputs;
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

class PracticeProblem {
  PracticeProblem.boyle({
    required this.question,
    required this.p1,
    required this.v1,
    required this.p2,
  }) : type = GasLawType.boyle,
       t1 = null,
       t2 = null;

  PracticeProblem.charles({
    required this.question,
    required this.v1,
    required this.t1,
    required this.t2,
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

  List<GivenField> get givenFields {
    switch (type) {
      case GasLawType.boyle:
        return [
          GivenField(label: 'P1', value: _formatNumber(p1!), unit: 'atm'),
          GivenField(label: 'V1', value: _formatNumber(v1), unit: 'L'),
          GivenField(label: 'P2', value: _formatNumber(p2!), unit: 'atm'),
        ];
      case GasLawType.charles:
        return [
          GivenField(label: 'V1', value: _formatNumber(v1), unit: 'L'),
          GivenField(label: 'T1', value: _formatNumber(t1!), unit: 'K'),
          GivenField(label: 'T2', value: _formatNumber(t2!), unit: 'K'),
        ];
    }
  }

  List<String> get givenLines {
    final lines = givenFields
        .map((field) => '${field.label} = ${field.value} ${field.unit}')
        .toList();
    lines.add('V2 = ?');
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
          'P1V1 = P2V2',
          '',
          'Given:',
          'P1 = ${_formatNumber(p1!)} atm',
          'V1 = ${_formatNumber(v1)} L',
          'P2 = ${_formatNumber(p2!)} atm',
          'V2 = ?',
          '',
          'Solve for V2:',
          'V2 = (P1 x V1) / P2',
          'V2 = (${_formatNumber(p1!)} x ${_formatNumber(v1)}) / ${_formatNumber(p2!)}',
          'V2 = ${_formatNumber(numerator)} / ${_formatNumber(p2!)}',
          'V2 = ${_formatNumber(answer)} L',
          '',
          'Final answer: ${_formatNumber(answer)} L',
        ].join('\n');
      case GasLawType.charles:
        final numerator = v1 * t2!;
        return [
          'Using Charles\' Law:',
          'V1/T1 = V2/T2',
          '',
          'Given:',
          'V1 = ${_formatNumber(v1)} L',
          'T1 = ${_formatNumber(t1!)} K',
          'T2 = ${_formatNumber(t2!)} K',
          'V2 = ?',
          '',
          'Solve for V2:',
          'V2 = (V1 x T2) / T1',
          'V2 = (${_formatNumber(v1)} x ${_formatNumber(t2!)}) / ${_formatNumber(t1!)}',
          'V2 = ${_formatNumber(numerator)} / ${_formatNumber(t1!)}',
          'V2 = ${_formatNumber(answer)} L',
          '',
          'Final answer: ${_formatNumber(answer)} L',
        ].join('\n');
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
        'In this lesson, we will explore Boyle\'s Law. Boyle\'s Law explains the relationship between pressure and volume when temperature remains constant. It states that pressure and volume are inversely proportional.',
    keyPoints: [
      'When volume decreases, pressure increases.',
      'When volume increases, pressure decreases.',
    ],
    whyItHappens: [
      'According to the Kinetic Molecular Theory, gas particles move randomly and continuously collide with the walls of the container.',
      'If we reduce the volume, the particles have less space to move. Because of this, collisions happen more often. More collisions mean higher pressure.',
    ],
    reminders: [
      'Keep temperature constant when using Boyle\'s Law.',
      'Use the formula P1V1 = P2V2.',
    ],
    exampleQuestion:
        'A gas has a volume of 2.0 liters at 1 atmosphere. If the volume decreases to 1.0 liter, what happens to the pressure?',
    exampleInputs: ['P1 = 1 atm', 'V1 = 2.0 L', 'V2 = 1.0 L', 'P2 = ?'],
    exampleSteps: [
      'Open the Gas Law Solver in iGasU.',
      'Enter the values, then tap Solve.',
      'P1V1 = P2V2',
      '(1 x 2.0) = (P2 x 1.0)',
      '2 = P2',
      'P2 = 2 atm',
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
        'In this lesson, we will study Charles\' Law. Charles\' Law explains how temperature affects volume when pressure remains constant. It states that volume and temperature are directly proportional.',
    keyPoints: [
      'When temperature increases, volume increases.',
      'When temperature decreases, volume decreases.',
    ],
    whyItHappens: [
      'Based on the Kinetic Molecular Theory, heating a gas makes its particles move faster.',
      'Faster particles spread farther apart. This causes the gas to expand.',
    ],
    reminders: [
      'Temperature must always be in Kelvin.',
      'Use the formula V1/T1 = V2/T2.',
    ],
    exampleQuestion:
        'A gas has a volume of 2.0 liters at 300 Kelvin. If the temperature increases to 450 Kelvin, what will be the new volume?',
    exampleInputs: ['V1 = 2.0 L', 'T1 = 300 K', 'T2 = 450 K', 'V2 = ?'],
    exampleSteps: [
      'Open the Gas Law Solver in iGasU.',
      'Enter the values, then tap Solve.',
      'V1/T1 = V2/T2',
      '2.0 / 300 = V2 / 450',
      '2.0 x 450 = 300V2',
      'V2 = 3.0 L',
    ],
    finalAnswer: 'The new volume is 3.0 liters.',
  ),
];

const List<VideoTutorialReference> videoTutorialReferences = [
  VideoTutorialReference(
    title: 'Boyle\'s Law',
    duration: '4:30',
    videoAssetPath: "assets/videos/BOYLE'S-LAW_Animation.mp4",
    color: Color(0xFF4A90E2),
    type: GasLawType.boyle,
  ),
  VideoTutorialReference(
    title: 'Charles\' Law',
    duration: '3:12',
    videoAssetPath: "assets/videos/CHARLES'-LAW_Animation.mp4",
    color: Color(0xFF5CB85C),
    type: GasLawType.charles,
  ),
  VideoTutorialReference(
    title: 'The Kinetic Molecular Theory',
    duration: 'Tutorial',
    videoAssetPath:
        'assets/videos/The-Kinetic-Molecular-Theory.mp4',
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
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 6 L at 3 atm. If the pressure decreases to 1 atm, what is the new volume?',
    p1: 3,
    v1: 6,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 10 L at 5 atm. If the pressure becomes 10 atm, find the new volume.',
    p1: 5,
    v1: 10,
    p2: 10,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 8 L at 2 atm. If pressure increases to 4 atm, find the new volume.',
    p1: 2,
    v1: 8,
    p2: 4,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 12 L at 3 atm. If pressure decreases to 2 atm, what is the new volume?',
    p1: 3,
    v1: 12,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 15 L at 5 atm. If pressure changes to 3 atm, what is the new volume?',
    p1: 5,
    v1: 15,
    p2: 3,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 7 L at 1 atm. If pressure becomes 7 atm, what is the new volume?',
    p1: 1,
    v1: 7,
    p2: 7,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 20 L at 2 atm. If pressure becomes 5 atm, what is the new volume?',
    p1: 2,
    v1: 20,
    p2: 5,
  ),
  PracticeProblem.boyle(
    question:
        'A gas occupies 16 L at 4 atm. If pressure decreases to 2 atm, what is the new volume?',
    p1: 4,
    v1: 16,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A diver has an air bubble with a volume of 30 L at a pressure of 5 atm underwater. As the diver rises, the pressure decreases to 2 atm. What is the new volume of the bubble?',
    p1: 5,
    v1: 30,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A syringe contains 12 L of gas at 6 atm pressure. When the plunger is pulled back, the pressure drops to 3 atm. What is the new volume?',
    p1: 6,
    v1: 12,
    p2: 3,
  ),
  PracticeProblem.boyle(
    question:
        'An air tank used by firefighters contains gas with a volume of 20 L at 10 atm. If the pressure inside the tank drops to 4 atm, what will be the new volume?',
    p1: 10,
    v1: 20,
    p2: 4,
  ),
  PracticeProblem.boyle(
    question:
        'A balloon inside a laboratory chamber has a volume of 18 L at 9 atm pressure. When the pressure is reduced to 3 atm, what will be the new volume?',
    p1: 9,
    v1: 18,
    p2: 3,
  ),
  PracticeProblem.boyle(
    question:
        'A scuba diver\'s air pocket measures 16 L at 8 atm deep underwater. As the diver moves upward, the pressure becomes 4 atm. What is the new volume?',
    p1: 8,
    v1: 16,
    p2: 4,
  ),
  PracticeProblem.boyle(
    question:
        'A medical breathing bag contains 10 L of air at 5 atm. If the pressure decreases to 2 atm, what is the new volume?',
    p1: 5,
    v1: 10,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A weather balloon has a volume of 40 L at 8 atm near the ground. As it rises into the atmosphere, the pressure drops to 2 atm. What is its new volume?',
    p1: 8,
    v1: 40,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'Inside a sealed laboratory cylinder, gas occupies 14 L at 7 atm. If the pressure becomes 1 atm, what is the new volume?',
    p1: 7,
    v1: 14,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'A compressed air container holds 22 L of gas at 11 atm. If the pressure drops to 5 atm, what is the new volume?',
    p1: 11,
    v1: 22,
    p2: 5,
  ),
  PracticeProblem.boyle(
    question:
        'A research chamber contains 50 L of gas at 10 atm. Scientists reduce the pressure to 2 atm. What will be the new volume?',
    p1: 10,
    v1: 50,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A compressed oxygen tank has 24 L of gas at 12 atm. If the pressure decreases to 6 atm, what is the new volume?',
    p1: 12,
    v1: 24,
    p2: 6,
  ),
  PracticeProblem.boyle(
    question:
        'A deep-sea submarine air pocket measures 35 L at 7 atm. If the pressure changes to 5 atm, what is the new volume?',
    p1: 7,
    v1: 35,
    p2: 5,
  ),
  PracticeProblem.boyle(
    question:
        'A gas pump cylinder contains 28 L at 14 atm pressure. If the pressure decreases to 7 atm, what is the new volume?',
    p1: 14,
    v1: 28,
    p2: 7,
  ),
  PracticeProblem.boyle(
    question:
        'A scientific vacuum container has gas with 21 L volume at 3 atm. If the pressure increases to 9 atm, what is the new volume?',
    p1: 3,
    v1: 21,
    p2: 9,
  ),
  PracticeProblem.boyle(
    question:
        'A laboratory piston chamber holds 60 L of gas at 6 atm. If the pressure increases to 15 atm, what is the new volume?',
    p1: 6,
    v1: 60,
    p2: 15,
  ),
  PracticeProblem.boyle(
    question:
        'Inside a car tire, air occupies 32 L at 8 atm pressure. After releasing some air, the pressure becomes 4 atm. What is the new volume of the air?',
    p1: 8,
    v1: 32,
    p2: 4,
  ),
  PracticeProblem.boyle(
    question:
        'A plastic water bottle traps 15 L of air at 3 atm when squeezed tightly. If the pressure decreases to 1 atm, what is the new volume?',
    p1: 3,
    v1: 15,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a soccer ball occupies 20 L at 5 atm. If the pressure increases to 10 atm, what is the new volume?',
    p1: 5,
    v1: 20,
    p2: 10,
  ),
  PracticeProblem.boyle(
    question:
        'A vacuum storage container holds gas with a volume of 18 L at 6 atm. If the pressure drops to 2 atm, what is the new volume?',
    p1: 6,
    v1: 18,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a basketball has a volume of 12 L at 4 atm. If the pressure drops to 2 atm, what is the new volume?',
    p1: 4,
    v1: 12,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A sealed laboratory flask contains gas with a volume of 50 L at 10 atm. If the pressure becomes 5 atm, what is the new volume?',
    p1: 10,
    v1: 50,
    p2: 5,
  ),
  PracticeProblem.boyle(
    question:
        'A gas storage tank holds 40 L of gas at 8 atm. If the pressure decreases to 4 atm, what is the new volume?',
    p1: 8,
    v1: 40,
    p2: 4,
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped inside a sealed jar occupies 9 L at 3 atm. If the pressure increases to 9 atm, what is the new volume?',
    p1: 3,
    v1: 9,
    p2: 9,
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a mechanical piston chamber occupies 30 L at 6 atm. If the pressure increases to 12 atm, what is the new volume?',
    p1: 6,
    v1: 30,
    p2: 12,
  ),
  PracticeProblem.boyle(
    question:
        'A sealed medical oxygen bag contains 14 L of gas at 7 atm. If the pressure drops to 1 atm, what is the new volume?',
    p1: 7,
    v1: 14,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'Gas inside a pressure cooker safety chamber occupies 16 L at 8 atm. If the pressure decreases to 4 atm, what is the new volume?',
    p1: 8,
    v1: 16,
    p2: 4,
  ),
  PracticeProblem.boyle(
    question:
        'A camping air mattress pump compresses 60 L of air at 3 atm. If the pressure increases to 9 atm, what is the new volume?',
    p1: 3,
    v1: 60,
    p2: 9,
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped inside a glass laboratory tube occupies 11 L at 11 atm. If the pressure decreases to 1 atm, what is the new volume?',
    p1: 11,
    v1: 11,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'A compressed air spray can contains 24 L of gas at 12 atm. If the pressure becomes 6 atm, what is the new volume?',
    p1: 12,
    v1: 24,
    p2: 6,
  ),
  PracticeProblem.boyle(
    question:
        'A diving air tank contains 28 L of air at 7 atm pressure. If the pressure drops to 1 atm, what is the new volume?',
    p1: 7,
    v1: 28,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a laboratory syringe occupies 10 L at 5 atm. If the pressure increases to 10 atm, what is the new volume?',
    p1: 5,
    v1: 10,
    p2: 10,
  ),
  PracticeProblem.boyle(
    question:
        'A scuba diver\'s air bag contains 18 L of air at 6 atm. If the pressure decreases to 3 atm, what is the new volume?',
    p1: 6,
    v1: 18,
    p2: 3,
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped in a laboratory balloon occupies 22 L at 2 atm. If the pressure becomes 1 atm, what is the new volume?',
    p1: 2,
    v1: 22,
    p2: 1,
  ),
  PracticeProblem.boyle(
    question:
        'A hydraulic piston chamber contains gas with a volume of 35 L at 7 atm. If the pressure increases to 14 atm, what is the new volume?',
    p1: 7,
    v1: 35,
    p2: 14,
  ),
  PracticeProblem.boyle(
    question:
        'Gas inside a scientific testing tube occupies 16 L at 4 atm. If the pressure drops to 2 atm, what is the new volume?',
    p1: 4,
    v1: 16,
    p2: 2,
  ),
  PracticeProblem.boyle(
    question:
        'A car air compressor holds 45 L of gas at 9 atm. If the pressure decreases to 3 atm, what is the new volume?',
    p1: 9,
    v1: 45,
    p2: 3,
  ),
  PracticeProblem.boyle(
    question:
        'Air trapped inside a metal container occupies 12 L at 6 atm. If the pressure increases to 12 atm, what is the new volume?',
    p1: 6,
    v1: 12,
    p2: 12,
  ),
  PracticeProblem.boyle(
    question:
        'A laboratory gas chamber contains 27 L of air at 9 atm. If the pressure becomes 3 atm, what is the new volume?',
    p1: 9,
    v1: 27,
    p2: 3,
  ),
  PracticeProblem.boyle(
    question:
        'Air inside a rescue breathing bag occupies 20 L at 4 atm. If the pressure drops to 1 atm, what is the new volume?',
    p1: 4,
    v1: 20,
    p2: 1,
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 2.5 L at 290 K. If the temperature increases to 330 K, what will be the new volume?',
    v1: 2.5,
    t1: 290,
    t2: 330,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.2 L at 300 K. If the temperature rises to 360 K, what is the new volume?',
    v1: 3.2,
    t1: 300,
    t2: 360,
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 1.8 L at 280 K. What will be its volume at 350 K?',
    v1: 1.8,
    t1: 280,
    t2: 350,
  ),
  PracticeProblem.charles(
    question:
        'A container of gas occupies 5.6 L at 310 K. What volume will it occupy at 400 K?',
    v1: 5.6,
    t1: 310,
    t2: 400,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 7.5 L at 350 K. If the temperature decreases to 300 K, what is the new volume?',
    v1: 7.5,
    t1: 350,
    t2: 300,
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 9.0 L at 320 K. What is its volume at 380 K?',
    v1: 9,
    t1: 320,
    t2: 380,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.4 L at 295 K. What will its volume be at 355 K?',
    v1: 4.4,
    t1: 295,
    t2: 355,
  ),
  PracticeProblem.charles(
    question: 'A gas has a volume of 6.2 L at 305 K. Find its volume at 370 K.',
    v1: 6.2,
    t1: 305,
    t2: 370,
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 8.5 L at 315 K. What is the volume at 420 K?',
    v1: 8.5,
    t1: 315,
    t2: 420,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 10.2 L at 330 K. What will be the volume at 390 K?',
    v1: 10.2,
    t1: 330,
    t2: 390,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.9 L at 275 K. What will be its volume at 340 K?',
    v1: 3.9,
    t1: 275,
    t2: 340,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 5.0 L at 290 K. What will be the volume at 350 K?',
    v1: 5,
    t1: 290,
    t2: 350,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 6.8 L at 300 K. What is its volume at 420 K?',
    v1: 6.8,
    t1: 300,
    t2: 420,
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 2.1 L at 285 K. What is its volume at 345 K?',
    v1: 2.1,
    t1: 285,
    t2: 345,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.7 L at 295 K. What volume will it have at 365 K?',
    v1: 4.7,
    t1: 295,
    t2: 365,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.3 L at 310 K. What is its volume at 450 K?',
    v1: 8.3,
    t1: 310,
    t2: 450,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 1.9 L at 260 K. What will be its volume at 300 K?',
    v1: 1.9,
    t1: 260,
    t2: 300,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 7.1 L at 315 K. What is its volume at 380 K?',
    v1: 7.1,
    t1: 315,
    t2: 380,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 5.9 L at 300 K. What will be the volume at 360 K?',
    v1: 5.9,
    t1: 300,
    t2: 360,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 4.3 L at 275 K. What volume will it occupy at 350 K?',
    v1: 4.3,
    t1: 275,
    t2: 350,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 6.4 L at 290 K. What will be the volume at 410 K?',
    v1: 6.4,
    t1: 290,
    t2: 410,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 9.7 L at 320 K. What is the volume at 390 K?',
    v1: 9.7,
    t1: 320,
    t2: 390,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 2.8 L at 280 K. What will be its volume at 340 K?',
    v1: 2.8,
    t1: 280,
    t2: 340,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 7.6 L at 305 K. What volume will it occupy at 390 K?',
    v1: 7.6,
    t1: 305,
    t2: 390,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.5 L at 295 K. What will be its volume at 365 K?',
    v1: 3.5,
    t1: 295,
    t2: 365,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.5 L at 290 K. Find its volume at 360 K.',
    v1: 5.5,
    t1: 290,
    t2: 360,
  ),
  PracticeProblem.charles(
    question:
        'A balloon of gas has a volume of 6.3 L at 310 K. What is its volume at 390 K?',
    v1: 6.3,
    t1: 310,
    t2: 390,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.1 L at 300 K. Determine its volume at 420 K.',
    v1: 8.1,
    t1: 300,
    t2: 420,
  ),
  PracticeProblem.charles(
    question: 'A gas has a volume of 2.6 L at 280 K. Find its volume at 350 K.',
    v1: 2.6,
    t1: 280,
    t2: 350,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 4.8 L at 295 K. What is its volume at 370 K?',
    v1: 4.8,
    t1: 295,
    t2: 370,
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 9.2 L at 320 K. What volume will it occupy at 400 K?',
    v1: 9.2,
    t1: 320,
    t2: 400,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 3.4 L at 270 K. Find its volume at 330 K.',
    v1: 3.4,
    t1: 270,
    t2: 330,
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 7.8 L at 305 K. What is its volume at 385 K?',
    v1: 7.8,
    t1: 305,
    t2: 385,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.1 L at 290 K. Find its volume at 355 K.',
    v1: 5.1,
    t1: 290,
    t2: 355,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 6.7 L at 315 K. What will be its volume at 395 K?',
    v1: 6.7,
    t1: 315,
    t2: 395,
  ),
  PracticeProblem.charles(
    question:
        'A balloon contains 2.3 L of gas at 275 K. Find the new volume at 340 K.',
    v1: 2.3,
    t1: 275,
    t2: 340,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.9 L at 320 K. Determine its volume at 430 K.',
    v1: 8.9,
    t1: 320,
    t2: 430,
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 4.0 L at 285 K. What is its volume at 345 K?',
    v1: 4,
    t1: 285,
    t2: 345,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.6 L at 300 K. Find its volume at 380 K.',
    v1: 5.6,
    t1: 300,
    t2: 380,
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 3.7 L at 290 K. What volume will it occupy at 355 K?',
    v1: 3.7,
    t1: 290,
    t2: 355,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 2.9 L at 280 K. What will its volume be at 330 K?',
    v1: 2.9,
    t1: 280,
    t2: 330,
  ),
  PracticeProblem.charles(
    question: 'A gas has a volume of 7.5 L at 310 K. Find its volume at 385 K.',
    v1: 7.5,
    t1: 310,
    t2: 385,
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 4.2 L at 290 K. What will be the volume at 345 K?',
    v1: 4.2,
    t1: 290,
    t2: 345,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 6.8 L at 305 K. Determine its volume at 390 K.',
    v1: 6.8,
    t1: 305,
    t2: 390,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.3 L at 275 K. What will be its volume at 325 K?',
    v1: 3.3,
    t1: 275,
    t2: 325,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 9.4 L at 315 K. Find its volume at 430 K.',
    v1: 9.4,
    t1: 315,
    t2: 430,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.7 L at 300 K. Determine its volume at 360 K.',
    v1: 5.7,
    t1: 300,
    t2: 360,
  ),
  PracticeProblem.charles(
    question:
        'A balloon has a volume of 2.5 L at 285 K. What will its volume be at 340 K?',
    v1: 2.5,
    t1: 285,
    t2: 340,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 7.2 L at 310 K. What is its volume at 400 K?',
    v1: 7.2,
    t1: 310,
    t2: 400,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 4.5 L at 295 K. Determine its volume at 355 K.',
    v1: 4.5,
    t1: 295,
    t2: 355,
  ),
  PracticeProblem.charles(
    question:
        'A gas has a volume of 6.0 L at 300 K. Find the new volume at 375 K.',
    v1: 6,
    t1: 300,
    t2: 375,
  ),
  PracticeProblem.charles(
    question:
        'A gas occupies 3.8 L at 285 K. What will be its volume at 345 K?',
    v1: 3.8,
    t1: 285,
    t2: 345,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 8.6 L at 320 K. Determine its volume at 400 K.',
    v1: 8.6,
    t1: 320,
    t2: 400,
  ),
  PracticeProblem.charles(
    question:
        'A balloon contains 2.7 L of gas at 275 K. What will be its volume at 330 K?',
    v1: 2.7,
    t1: 275,
    t2: 330,
  ),
  PracticeProblem.charles(
    question: 'A gas occupies 5.0 L at 290 K. Find the volume at 365 K.',
    v1: 5,
    t1: 290,
    t2: 365,
  ),
];

List<PracticeProblem> practiceProblemsFor(GasLawType type) {
  return practiceProblems.where((problem) => problem.type == type).toList();
}

int practiceProblemCountFor(GasLawType type) {
  return practiceProblems.where((problem) => problem.type == type).length;
}
