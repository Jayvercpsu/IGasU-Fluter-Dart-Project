import 'package:flutter_test/flutter_test.dart';

import 'package:i_gas_u/main.dart';

void main() {
  testWidgets('shows the iGasU home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const IGasUApp(showStartupFlow: false));

    expect(find.text('iGasU'), findsOneWidget);
    expect(find.text('Video Tutorials'), findsOneWidget);
    expect(find.text('Problem Solving'), findsOneWidget);
    expect(find.text('Learning Dashboard'), findsOneWidget);
  });
}
