import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nulldle/main.dart';
import 'package:nulldle/view/game_screen.dart';
import 'package:nulldle/view_model/game_view_model.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('HomeScreen UI elements remain consistent', (WidgetTester tester) async {
    // Pump the widget tree
    await tester.pumpWidget(WordleApp());

    // Title
    expect(find.text('Nulldle'), findsOneWidget);

    // Instruction text (substring match so it still passes if wrapped/refactored)
    expect(
      find.textContaining('Guess the hidden five-letter word'),
      findsOneWidget,
    );
    // Image
    expect(find.byType(Image), findsOneWidget);
    // Play Game button
    final playButton = find.widgetWithText(ElevatedButton, 'Play Game');
    expect(playButton, findsOneWidget);
    // Tap Play Game navigates to GameScreen
    await tester.tap(playButton);
    await tester.pump(const Duration(seconds: 1));
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(GameScreen), findsOneWidget);
  });


  
   testWidgets('GameScreen UI elements remain consistent', (WidgetTester tester) async {
  // Pump GameScreen
  await tester.binding.setSurfaceSize(const Size(1080, 1920));
  final vm = GameViewModel();
  vm.isLoading = true; // Set it to simulate loading

  await tester.pumpWidget(
    ChangeNotifierProvider<GameViewModel>.value(
      value: vm,
      child: MaterialApp(home: GameScreen()),
    ),
  );

  await tester.pump(const Duration(milliseconds: 100));
  expect(find.byType(CircularProgressIndicator), findsOneWidget);    //only this can be tested at the current setup even all ui elements are there.
});}