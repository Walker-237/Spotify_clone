import 'package:flutter_test/flutter_test.dart';

import 'package:spotify/main.dart';

void main() {
  testWidgets('Search tab shows browse categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SpotifyApp());

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Browse all'), findsOneWidget);
    expect(find.text('Discover something new'), findsOneWidget);
    expect(find.text('Pop'), findsWidgets);
    expect(find.text('Hip-Hop'), findsOneWidget);
  });
}
