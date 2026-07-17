import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:i_gas_u/data/gas_law_content.dart';
import 'package:i_gas_u/main.dart';
import 'package:i_gas_u/screens/problem_solving_page.dart';

void main() {
  testWidgets('shows the iGasU home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const IGasUApp(showStartupFlow: false));

    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('Video Tutorials'), findsOneWidget);
    expect(find.text('Problem Solver'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('problem solver renders ABCD choices', (tester) async {
    await _pumpProblemSolver(tester);

    expect(find.text('A.'), findsOneWidget);
    expect(find.text('B.'), findsOneWidget);
    expect(find.text('C.'), findsOneWidget);
    expect(find.text('D.'), findsOneWidget);
    expect(find.text('Submit Answer'), findsOneWidget);
  });

  testWidgets('wrong answer reduces attempts', (tester) async {
    await _pumpProblemSolver(tester);

    await tester.tap(find.text('1L'));
    await tester.tap(find.text('Submit Answer'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect answer. Attempts left: 2'), findsOneWidget);
    expect(find.text('You have 2 attempts for this question.'), findsOneWidget);
  });

  testWidgets('correct answer shows solution and next question action', (
    tester,
  ) async {
    await _pumpProblemSolver(tester);

    await tester.tap(find.text('2L'));
    await tester.tap(find.text('Submit Answer'));
    await tester.pumpAndSettle();

    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Explanation:'), findsOneWidget);
    expect(find.text('Next Question'), findsOneWidget);
  });

  testWidgets('exhausted attempts show rewatch action', (tester) async {
    await _pumpProblemSolver(tester);
    await _missFirstProblemThreeTimes(tester);

    expect(find.text('No attempts left'), findsOneWidget);
    expect(find.text('REWATCH VIDEO'), findsOneWidget);
    expect(find.text('Submit Answer'), findsNothing);
  });

  testWidgets('rewatch completion restores attempts', (tester) async {
    await _pumpProblemSolver(tester, onRewatchVideo: (_) async => true);
    await _missFirstProblemThreeTimes(tester);

    await tester.tap(find.text('REWATCH VIDEO'));
    await tester.pumpAndSettle();

    expect(find.text('You have 3 attempts for this question.'), findsOneWidget);
    expect(find.text('Submit Answer'), findsOneWidget);
  });
}

Future<void> _pumpProblemSolver(
  WidgetTester tester, {
  RewatchVideoHandler? onRewatchVideo,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(home: ProblemSolvingPage(onRewatchVideo: onRewatchVideo)),
  );
  await tester.pumpAndSettle();
}

Future<void> _missFirstProblemThreeTimes(WidgetTester tester) async {
  final correctAnswer = practiceProblemsFor(
    GasLawType.boyle,
  ).first.correctChoice.text;
  final wrongChoice = practiceProblemsFor(
    GasLawType.boyle,
  ).first.choices.firstWhere((choice) => choice.text != correctAnswer);

  for (var i = 0; i < 3; i += 1) {
    await tester.tap(find.text(wrongChoice.text));
    await tester.tap(find.text('Submit Answer'));
    await tester.pumpAndSettle();
  }
}
